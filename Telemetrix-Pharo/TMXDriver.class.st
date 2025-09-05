Class {
	#name : 'TMXDriver',
	#superclass : 'Object',
	#instVars : [
		'ip',
		'port',
		'commandStream',
		'listener'
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

{ #category : 'pin modes' }
TMXDriver >> beAnalogInputOnPin: aPin [
"this uses the analog pin number 0=4 !"
	self beAnalogInputOnPin: aPin differential: 0
]

{ #category : 'pin modes' }
TMXDriver >> beAnalogInputOnPin: aPin differential: anInt [
"this uses the analog pin number 0=4 ! Mode = 3
anInt can be more than 8 bits"
	| command |
	command := ByteArray with: 1 with: aPin with: 3 with: (anInt >> 8) with: (anInt bitAnd: 16rFF).
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXDriver >> beAnalogOutputOnPin: aPin [
" actually this is pwm output"
	self bePWMOutputOnPin: aPin
]

{ #category : 'pin modes' }
TMXDriver >> beDHTOnPin: aPin [
	"DHT_NEW mode is 31"
	| command |
	
	command := ByteArray with: 31 with: aPin.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXDriver >> beDigitalInputOnPin: aPin [
	"mode = 0. Note that a differential of 1 is added"
		| command |
		
	command := ByteArray with: 1 with: aPin with: 0 with: 1.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXDriver >> beDigitalInputPullupOnPin: aPin [
	"mode = 2. Note that a differential of 1 is added"
		| command |
		
	command := ByteArray with: 1 with: aPin with: 2 with: 1.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXDriver >> beDigitalOutputOnPin: aPin [
	"mode = 1"
		| command |
	
	command := ByteArray with: 1 with: aPin with: 1.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXDriver >> bePWMOutputOnPin: aPin [
	"TMX calls this analog output"
	| command |
	
	command := ByteArray with: 1 with: aPin with: 1.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXDriver >> beServoOutputOnPin: aPin [
	"pulses in microseconds)"
	self beServoOutputOnPin: aPin minPulse: 544  maxPulse: 2400
]

{ #category : 'pin modes' }
TMXDriver >> beServoOutputOnPin: aPin minPulse: int1 maxPulse: int2 [
	"mode = servo_attach = 7 with m,in en max pulse length
	minPulse eand maxPulse as 16 bits number, bigendian (if I am right.."
	| command |
	
	command := ByteArray with: 7 with: aPin with: (int1 bitAnd: 16rFF00) with: (int1 bitAnd: 16rFF)
														with: (int2 bitAnd: 16rFF00) with: (int2 bitAnd: 16rFF).
	self sendCommand: command
	
]

{ #category : 'accessing' }
TMXDriver >> commandStream [
	^commandStream
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

{ #category : 'io protocols' }
TMXDriver >> digitalValue: oneOrZero intoPin: aPin [
	"digital_write = 2"
	| command |
	
	command := ByteArray with: 2 with: aPin with: oneOrZero .
	self sendCommand: command
]

{ #category : 'as yet unclassified' }
TMXDriver >> disableAllReporting [
]

{ #category : 'as yet unclassified' }
TMXDriver >> disableAnalogReporting [
]

{ #category : 'as yet unclassified' }
TMXDriver >> disableDigitalReporting [
]

{ #category : 'as yet unclassified' }
TMXDriver >> enableAnalogReporting [
]

{ #category : 'as yet unclassified' }
TMXDriver >> enableDigitalReporting [
]

{ #category : 'as yet unclassified' }
TMXDriver >> i2cRead [
]

{ #category : 'as yet unclassified' }
TMXDriver >> i2cReadRestartTransmission [
]

{ #category : 'as yet unclassified' }
TMXDriver >> i2cWrite [
]

{ #category : 'initialization' }
TMXDriver >> initialize [ 

	super initialize.
	
	
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
TMXDriver >> listener [
	^listener
]

{ #category : 'as yet unclassified' }
TMXDriver >> loopback: aByte [
	"send aByte. It should be returned in an TMXLoopbackEvent"
	
	| buffer |
	buffer := ByteArray with: 0 with: aByte.
	self sendCommand: buffer
]

{ #category : 'as yet unclassified' }
TMXDriver >> neopixelClear [
]

{ #category : 'as yet unclassified' }
TMXDriver >> neopixelFill [
]

{ #category : 'as yet unclassified' }
TMXDriver >> neopixelSetValue [
]

{ #category : 'as yet unclassified' }
TMXDriver >> neopixelShow [
]

{ #category : 'as yet unclassified' }
TMXDriver >> openI2C [
]

{ #category : 'as yet unclassified' }
TMXDriver >> openIMU [
]

{ #category : 'as yet unclassified' }
TMXDriver >> openMichrophone [
]

{ #category : 'as yet unclassified' }
TMXDriver >> openNeopixel [
]

{ #category : 'as yet unclassified' }
TMXDriver >> openSPI [
]

{ #category : 'as yet unclassified' }
TMXDriver >> openSonar [
]

{ #category : 'accessing' }
TMXDriver >> port [

	^ port
]

{ #category : 'accessing' }
TMXDriver >> port: anObject [

	port := anObject
]

{ #category : 'io protocols' }
TMXDriver >> pwmValue: aNumber intoPin: aPin [
]

{ #category : 'testing' }
TMXDriver >> sendCommand: aByteArray [
	| buffer |
	(aByteArray size > 255) ifTrue: [self halt].
	buffer := (aByteArray size asByteArray) , aByteArray .
	commandStream nextPutAll: buffer; flush
]

{ #category : 'as yet unclassified' }
TMXDriver >> servoDetach [
]

{ #category : 'as yet unclassified' }
TMXDriver >> servoWrite [
]

{ #category : 'as yet unclassified' }
TMXDriver >> setAnalogScanInterval [
]

{ #category : 'as yet unclassified' }
TMXDriver >> setupLoopbackSubscription [
	self when: TMXLoopbackEvent do: [ :ann | Transcript show: ('loopback: ', (ann data)) ]  for: self
]

{ #category : 'as yet unclassified' }
TMXDriver >> shutdown [
]

{ #category : 'as yet unclassified' }
TMXDriver >> spiCsControl [
]

{ #category : 'as yet unclassified' }
TMXDriver >> spiReadBlocking [
]

{ #category : 'as yet unclassified' }
TMXDriver >> spiSetFormat [
]

{ #category : 'as yet unclassified' }
TMXDriver >> spiWriteBlocking [
]

{ #category : 'initialization' }
TMXDriver >> startListener [ 
	listener ifNotNil: [^self].
	listener := (TMXListener new withStream: commandStream; yourself).
	listener start
]

{ #category : 'protocol' }
TMXDriver >> when: anEvent do: aBlock [ 
	listener announcer when: anEvent do: aBlock
]

{ #category : 'protocol' }
TMXDriver >> when: anEvent do: aBlock for: anObject [ 
	listener announcer when: anEvent do: aBlock for: anObject
]
