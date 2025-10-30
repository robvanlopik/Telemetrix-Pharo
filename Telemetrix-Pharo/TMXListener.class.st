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
		'listenerProcess',
		'driver'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'event handling' }
TMXListener >> announceAnalogInput: data [
	| announcement |
	announcement := TMXAnalogInputEvent new 
							pinNr: (data at: 1);
							pinValue: (data at: 2) *256 + (data at: 3);
							timestamp: DateAndTime now;
							yourself.
	self doAnnouncement: announcement
]

{ #category : 'event handling' }
TMXListener >> announceDHTReport: data [
"DHT_DATA = 0
    DHT_ERROR = 1"
	| announcement type|
	type := data at: 1.
	(type = 0) ifTrue: [   "data are correct" 
		announcement := TMXDHTEvent new 
							pinNr: (data at: 2);
							pinValue: (data at: 3) *256 + (data at: 2);
							timestamp: DateAndTime now;
							yourself.
							
	self doAnnouncement: announcement ]

]

{ #category : 'event handling' }
TMXListener >> announceDebugPrint: data [
]

{ #category : 'event handling' }
TMXListener >> announceDigitalInput: data [
	| announcement |
	announcement := TMXDigitalInputEvent new 
							pinNr: (data at: 1);
							pinValue: (data at: 2);
							timestamp: DateAndTime now;
							yourself.
	self doAnnouncement: announcement
]

{ #category : 'event handling' }
TMXListener >> announceFirmwareReport: data [
]

{ #category : 'event handling' }
TMXListener >> announceI2CReadReport: data [
	"the eventbuffer is I2C_READ_REPORT, count, address, register, bytes"
	| announcement |
	announcement := TMXI2CEvent new
							address: (data at: 2);
							register: (data at: 3);
							count: (data at: 1);
							bytes: (data allButFirst: 3);
							timestamp: DateAndTime now;
							yourself.
	self doAnnouncement: announcement 
]

{ #category : 'event handling' }
TMXListener >> announceI2CTooFewBytesRcvd: data [
]

{ #category : 'event handling' }
TMXListener >> announceI2CTooManyBytesRcvd: data [
]

{ #category : 'event handling' }
TMXListener >> announceIAMHere: data [
]

{ #category : 'event handling' }
TMXListener >> announceIMUReport: data [
]

{ #category : 'event handling' }
TMXListener >> announceLoopbackReport: data [
	"messageID = 0 , not in docs!!"
	self doAnnouncement: (TMXLoopbackEvent new data: data; timestamp: DateAndTime now; yourself)
]

{ #category : 'event handling' }
TMXListener >> announceMicrophoneReport: data [
]

{ #category : 'event handling' }
TMXListener >> announceSPIReport: data [
]

{ #category : 'event handling' }
TMXListener >> announceServoUnavailable: data [
]

{ #category : 'event handling' }
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
TMXListener >> doAnnouncement: anAnnouncement [
	"when processing the announcement can take a long time, it is better to fork the announcement process.  On the other hand this produes more overhead wich may be prohibitive when there are many events, like in analog input with differential=0"
	self driver forkAnnouncements ifTrue: 
	[[ announcer announce: anAnnouncement ] forkAt: Processor userInterruptPriority ]
ifFalse: [ announcer announce: anAnnouncement ]
]

{ #category : 'accessing' }
TMXListener >> driver [ 
	^driver
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

{ #category : 'instance creation' }
TMXListener >> withStream: aStream for: aTMXDriver [
	messageStream := aStream.
	driver := aTMXDriver 
]
