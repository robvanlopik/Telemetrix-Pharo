Class {
	#name : 'TMXListener',
	#superclass : 'Object',
	#instVars : [
		'ip',
		'port',
		'running',
		'messageStream',
		'announcer',
		'dispatchDict'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'as yet unclassified' }
TMXListener >> annopunceAnalogInput: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceDigitalInput: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceFirmwareReport: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceIAMHere: data [
]

{ #category : 'as yet unclassified' }
TMXListener >> announceServoUnavailable: data [
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
	
	buffer := ByteArray new.
	
	[  running ] whileTrue: [ 
		[messageStream isDataAvailable] whileFalse: [ 1 seconds wait ]. "is is reasonalbe, as the timestamp has the same resolution"
		messageSize := messageStream next.
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
