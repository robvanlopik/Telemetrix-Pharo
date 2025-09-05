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
TMXListener >> annopunceAnalogInput: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceDHTReport: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceDebugPrint: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceDigitalInput: data [
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
	announcer announce: (TMXLoopbackEvent new data: (data at: 1))
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

{ #category : 'as yet unclassified' }
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

{ #category : 'initialization' }
TMXListener >> initialize [ 

	super initialize.
	running := false.
	announcer := Announcer new.
	dispatchDict := {
		(2 -> #announceDigitalInput:). 
		(3 -> #annopunceAnalogInput:).
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
		}.

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
		[messageStream isDataAvailable] whileFalse: [ 1 seconds wait. 'Waiting...' traceCr]. "is is reasonalbe, as the timestamp has the same resolution"
		messageSize := messageStream next.
		    'got something ' trace. messageSize printString traceCr.
		buffer := ByteArray new: messageSize.
		messageStream next: messageSize into: buffer.
		self dispatch: buffer.
		 ] 
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
	
	messageStream isConnected ifFalse: [ messageStream := nil ].
	messageStream binary.
	running := true.
	listenerProcess := [ self listen]
			forkAt: Processor lowIOPriority named: 'TMX listener'
]

{ #category : 'accessing' }
TMXListener >> stop [ 
	running := false
]

{ #category : 'instance creation' }
TMXListener >> withStream: aStream [
	messageStream := aStream
]
