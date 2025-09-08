Class {
	#name : 'TMXListener',
	#superclass : 'Object',
	#instVars : [
		'ip',
		'port',
		'running',
		'messageStream',
		'announcer',
		'dispatchDict',
		'listenerProcess'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'as yet unclassified' }
TMXListener >> announceAnalogInput: data [
	| announcement |
	announcement := TMXAnalogInputEvent new 
							pinNr: (data at: 1);
							pinValue: (data at: 2) *256 + (data at: 3);
							timestamp: DateAndTime now;
							yourself.
	self forkAnnouncement: announcement
]

{ #category : 'as yet unclassified' }
TMXListener >> announceDHTReport: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceDebugPrint: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceDigitalInput: data [
	| announcement |
	announcement := TMXDigitalInputEvent new 
							pinNr: (data at: 1);
							pinValue: (data at: 2);
							timestamp: DateAndTime now;
							yourself.
	self forkAnnouncement: announcement
]

{ #category : 'as yet unclassified' }
TMXListener >> announceFirmwareReport: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceI2CReadReport: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceI2CTooFewBytesRcvd: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceI2CTooManyBytesRcvd: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceIAMHere: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceIMUReport: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceLoopbackReport: data [
	"messageID = 0 , not in docs!!"
	self forkAnnouncement: (TMXLoopbackEvent new data: data; timestamp: DateAndTime now; yourself)
]

{ #category : 'as yet unclassified' }
TMXListener >> announceMicrophoneReport: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceSPIReport: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceServoUnavailable: data [
]

{ #category : 'events-processing' }
TMXListener >> announceSonarDistance: data [
]

{ #category : 'accessing' }
TMXListener >> announcer [
	^announcer
]

{ #category : 'dispatching' }
TMXListener >> dispatch: aBuffer [
	"we have received a buffer and dispatch to different announcement types."
	| messageId data action | 
	
	messageId := aBuffer first.
	data := aBuffer allButFirst.
	action := dispatchDict at: messageId ifAbsent: [ self error: 'unknown messageId' ].
	self perform: action with: data.
]

{ #category : 'events-processing' }
TMXListener >> forkAnnouncement: anAnnouncement [
	"as the acitions of a subscriber are performed in the context of the announcing thread, the can hold up further announcments from the listener. Therefore all anouncements are made in new processes and run at priority userInterrupPriority (=50)"
	[ announcer announce: anAnnouncement ] forkAt: Processor userInterruptPriority 
]

{ #category : 'initialization' }
TMXListener >> initialize [ 

	super initialize.
	running := false.
	announcer := Announcer new.
	dispatchDict := {
		(0 -> #announceLoopbackReport:).
		(2 -> #announceDigitalInput:). 
		(3 -> #announceAnalogInput:).
		(5 -> #announceFirmwareReport:).
		(6 -> #announceIAMHere:).
		(7 -> #announceServoUnavailable:).
		(8 -> #announceI2CTooFewBytesRcvd: ).
		(9 -> #announceI2CTooManyBytesRcvd:).
		(10 -> #announceI2CReadReport:).
		(11 -> #announceSonarDistance:).
		(12 -> #announceIMUReport).
		(13 -> #announceMicrophoneReport:).
		(14 -> #announceDHTReport:).
		(15 -> #announceSPIReport:)	.
		(99 -> #announceDebugPrint:).
		} asDictionary.

]

{ #category : 'accessing' }
TMXListener >> ip [

	^ ip
]

{ #category : 'accessing' }
TMXListener >> ip: anObject [

	ip := anObject
]

{ #category : 'processing' }
TMXListener >> listen [
	"the main loop. Listen to incoming data and dispatch accorinng to message id"
	| buffer messageSize|
	
	
	'I am listening' traceCr.
	[  running ] whileTrue: [ 
		[messageStream isDataAvailable] whileFalse: [ 1 seconds wait].		
					 "is is reasonalbe, as the timestamp has the same resolution (but the analog loop is 19 ms!"
		messageSize := messageStream next.
		    'got something ' trace. messageSize printString trace.
		buffer := ByteArray new: messageSize.
		messageStream next: messageSize into: buffer.
		(' code: ', (buffer first printString)) traceCr.
		self dispatch: buffer].
]

{ #category : 'accessing' }
TMXListener >> port [

	^ port
]

{ #category : 'accessing' }
TMXListener >> port: anObject [

	port := anObject
]

{ #category : 'accessing' }
TMXListener >> start [
	
"	messageStream := SocketStream openConnectionToHostNamed: ip port: port."
	

	messageStream isConnected ifFalse: [ messageStream := nil ].
	"messageStream binary. zou hij l moeten zijn"
	running := true.
	listenerProcess := [ self listen]
			forkAt: Processor lowIOPriority named: 'TMX listene'
]

{ #category : 'accessing' }
TMXListener >> stop [ 
	running := false
]

{ #category : 'instance creation' }
TMXListener >> withStream: aStream [
	messageStream := aStream
]
