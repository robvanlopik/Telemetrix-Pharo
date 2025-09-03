Class {
	#name : 'TMXDriver',
	#superclass : 'Object',
	#instVars : [
		'ip',
		'port',
		'commandStream',
		'announcer'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'as yet unclassified' }
TMXDriver class >> onIP: anIPString [
	^self new
		connectOnIP: anIPString;
		yourself
]

{ #category : 'instance creation' }
TMXDriver class >> onIP: anIPString port: aPortNumber [
	^self new
		connectOnIP: anIPString port: aPortNumber;
		yourself
]

{ #category : 'testing' }
TMXDriver >> beDigitalOutputOnPin: aPin [
	"def set_pin_mode_digital_output(self, pin_number)
	command = 1 ermode and mode=1 output "
	"check for legal pin numbers!!"
	| buffer |
	
	buffer := ByteArray with: 1 with:aPin with:1.
	self sendCommand: buffer
]

{ #category : 'initialize-release' }
TMXDriver >> connectOnIP: anAddress [
	"connect with default port 31335"

	self connectOnIP: anAddress port: 31335
]

{ #category : 'initialize-release' }
TMXDriver >> connectOnIP: anIPString port: aPortNumber [
	"if the socket cannot be opened, store nil"	
			
	self isConnected ifTrue: [ ^self ].
	
	commandStream := SocketStream openConnectionToHostNamed: anIPString port: aPortNumber.
	commandStream isConnected ifFalse: [ commandStream := nil ].
	commandStream binary.
	
	ip := anIPString.
	port := aPortNumber
	
		
]

{ #category : 'initialization' }
TMXDriver >> initialize [ 

	super initialize.
	announcer := Announcer new
]

{ #category : 'accessing' }
TMXDriver >> ip [

	^ ip
]

{ #category : 'accessing' }
TMXDriver >> ip: anObject [

	ip := anObject
]

{ #category : 'testing' }
TMXDriver >> isConnected [

	^commandStream notNil
]

{ #category : 'accessing' }
TMXDriver >> port [

	^ port
]

{ #category : 'accessing' }
TMXDriver >> port: anObject [

	port := anObject
]

{ #category : 'testing' }
TMXDriver >> sendCommand: aByteArray [
	| buffer |
	(aByteArray size > 255) ifTrue: [self halt].
	buffer := (aByteArray size asByteArray) , aByteArray .
	commandStream nextPutAll: buffer; flush
]
