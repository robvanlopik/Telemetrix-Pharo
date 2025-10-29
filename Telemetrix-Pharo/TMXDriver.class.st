Class {
	#name : 'TMXDriver',
	#superclass : 'Object',
	#instVars : [
		'ip',
		'port',
		'commandStream',
		'listener',
		'forkAnnouncements',
		'i2cActivated'
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

{ #category : 'i2c' }
TMXDriver >> activateI2C [
	"activate I2C on the default pins, SDA=A4 and SCL=A5
	Note there is no way to free the pins!
	I2C_BEGIN = 10
    I2C_READ = 11
    I2C_WRITE = 12"

	self sendCommand: (ByteArray with: 10).
	i2cActivated := true
]

{ #category : 'pin modes' }
TMXDriver >> beAnalogInputOnPin: aPin [
"this uses the analog pin number 0=4 !
we set the default differential to 2 to avoid excessive event numbers"
	self beAnalogInputOnPin: aPin differential: 2
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
TMXDriver >> beNeopixelOutputOnPin: aPin pixelCount: anInt colorFill: aColor [
	"aPin must be  2-17,
	r g and b bust be smaller than 256, they represent the initial color fill
	INITIALIZE_NEO_PIXELS = 21
	also in source: self.neopixels_initiated = True
	maybe check all legal values
	OR use fillColor as parameter and use the Color class"
	| command r g b|
	r := (aColor red * 255) rounded bitAnd: 16rFF. 
	g := (aColor green * 255) rounded bitAnd: 16rFF.
	b := (aColor blue * 255) rounded bitAnd: 16rFF.
	"self.number_of_pixels = num_pixels"	
	command := ByteArray with: 21 with: aPin with: anInt with: r with: g with: b.
	self sendCommand: command
	"self.neopixels_initiated = True"
]

{ #category : 'pin modes' }
TMXDriver >> beNeopixelOutputOnPin: aPin pixelCount: anInt rFill: r gFill: g bFill: b [
	"aPin must be  2-17,
	r g and b bust be smaller than 256, they represent the initial color fill
	INITIALIZE_NEO_PIXELS = 21
	also in source: self.neopixels_initiated = True
	maybe check all legal values"
	| command |
	"self.number_of_pixels = num_pixels"	
	command := ByteArray with: 1 with: aPin with: anInt with: r with: g with: b.
	self sendCommand: command
	"self.neopixels_initiated = True"
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
	
	command := ByteArray with: 7 with: aPin with: ((int1 bitAnd: 16rFF00) >> 8) with: (int1 bitAnd: 16rFF)
														with: ((int2 bitAnd: 16rFF00) >> 8) with: (int2 bitAnd: 16rFF).
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

{ #category : 'pin modes' }
TMXDriver >> detachServoFromPin: aPin [
	"not sure what this does
	SERVO_DETACH = 9"
	| command |
	
	command := ByteArray with: 9 with: aPin .
	self sendCommand: command
]

{ #category : 'io protocols' }
TMXDriver >> digitalValue: oneOrZero intoPin: aPin [
	"digital_write = 2"
	| command |
	
	command := ByteArray with: 2 with: aPin with: oneOrZero .
	self sendCommand: command
]

{ #category : 'reporting' }
TMXDriver >> disableAllReporting [
	"MODIFY_REPORTING = 4
	REPORTING_DISABLE_ALL = 0"
	| command |
	command := ByteArray with: 4 with: 0 with: 0.
	self sendCommand: command
]

{ #category : 'as yet unclassified' }
TMXDriver >> disableAnalogReportingOnPin: aPin [
	"MODIFY_REPORTING = 4"
	"REPORTING_ANALOG_DISABLE = 3"
	| command |
	command := ByteArray with: 4 with: 3 with: aPin.
	self sendCommand: command
]

{ #category : 'as yet unclassified' }
TMXDriver >> disableDigitalReporting [
]

{ #category : 'as yet unclassified' }
TMXDriver >> enableAnalogReportingOnPin: aPin [
	"MODIFY_REPORTING = 4
	REPORTING_ANALOG_ENABLE = 1"
	| command |
	command := ByteArray with: 4 with: 1 with: aPin.
	self sendCommand: command

]

{ #category : 'as yet unclassified' }
TMXDriver >> enableDigitalReporting [
]

{ #category : 'accessing' }
TMXDriver >> forkAnnouncements [
	^forkAnnouncements
]

{ #category : 'accessing' }
TMXDriver >> forkAnnouncements: aBoolean [
	forkAnnouncements := aBoolean
]

{ #category : 'as yet unclassified' }
TMXDriver >> i2cRead [
]

{ #category : 'i2c' }
TMXDriver >> i2cReadFromAdress: anAddress register: aRegister count: byteCount [
	"read and stop transmission, ie stop_transmission = true
	I2C_READ = 11
	"
	
	i2cActivated ifTrue: [ 
		self sendCommand: (ByteArray with: 11 with: anAddress with: aRegister with: byteCount with: 1)]
]

{ #category : 'as yet unclassified' }
TMXDriver >> i2cReadRestartTransmission [
]

{ #category : 'i2c' }
TMXDriver >> i2cReadRestartTransmissionFromAdress: anAddress register: aRegister count: byteCount [
	"read and stop transmission, ie stop_transmission = false
	I2C_READ = 11
	"
	
	i2cActivated ifTrue: [ 
		self sendCommand: (ByteArray with: 11 with: anAddress with: aRegister with: byteCount with: 0)]
]

{ #category : 'i2c' }
TMXDriver >> i2cWrite: aDataArray toAddress: anAddress [
	"I2C_WRITE = 12; data is a ByteAray"
	
	i2cActivated ifTrue:	
	[self sendCommand: ((ByteArray with: 12 with: anAddress) , aDataArray)]
]

{ #category : 'initialization' }
TMXDriver >> initialize [ 

	super initialize.
	forkAnnouncements := false.
	
	
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

{ #category : 'neopixel' }
TMXDriver >> neopixelClearLater [
	"clear the display but dont immediately show it"
	"CLEAR_ALL_NEO_PIXELS = 24"
	self sendCommand: (ByteArray with: 24 with: 0)
]

{ #category : 'neopixel' }
TMXDriver >> neopixelClearNow [
	"clear the display and immediately show it"
	"CLEAR_ALL_NEO_PIXELS = 24"
	self sendCommand: (ByteArray with: 24 with: 1)
]

{ #category : 'neopixel' }
TMXDriver >> neopixelFill [
]

{ #category : 'neopixel' }
TMXDriver >> neopixelFillLaterColor: aColor [
	"Set all pixels to aColor, abut don't show it yet"
	"FILL_ALL_NEO_PIXELS = 25"
	| r g b |
	r := (aColor red * 255) rounded bitAnd: 16rFF.
	g := (aColor green * 255) rounded bitAnd: 16rFF.
	b := (aColor blue * 255) rounded bitAnd: 16rFF.
	self sendCommand: (ByteArray with: 25 with: r with: g with: b with: 0)
]

{ #category : 'neopixel' }
TMXDriver >> neopixelFillNowColor: aColor [
	"Set all pixels to aColor, and show it"
	"FILL_ALL_NEO_PIXELS = 25"
	| r g b |
	r := (aColor red * 255) rounded bitAnd: 16rFF.
	g := (aColor green * 255) rounded bitAnd: 16rFF.
	b := (aColor blue * 255) rounded bitAnd: 16rFF.
	self sendCommand: (ByteArray with: 25 with: r with: g with: b with: 1)
]

{ #category : 'neopixel' }
TMXDriver >> neopixelShow [
	"Write the NeoPixel buffer stored on the server to the NeoPixel device."
	"SHOW_NEO_PIXELS = 22"
	self sendCommand: (ByteArray with: 22)
]

{ #category : 'neopixel' }
TMXDriver >> neopixelnr: aNumber color: aColor [
	"set pixen number aNumber (0 - maxpixels) to rgb and default disable autoshow"
	"SET_NEO_PIXEL = 23"
	| auto command rValue gValue bValue|
	auto := 0.
	rValue := (aColor red * 255) rounded bitAnd: 16rFF. 
	gValue := (aColor green * 255) rounded bitAnd: 16rFF.
	bValue := (aColor blue * 255) rounded bitAnd: 16rFF.
	command := ByteArray with: 23 with: aNumber with: rValue with: gValue with: bValue with: auto.
	self sendCommand: command
]

{ #category : 'neopixel' }
TMXDriver >> neopixelnr: aNumber color: aColor autoShow: boolean [
	"set pixen number aNumber (0 - maxpixels) to rgb and enable or disable autoshow"
	"SET_NEO_PIXEL = 23"
	| auto command rValue gValue bValue|
	auto := 0.
	boolean ifTrue: [ auto := 1 ].
	rValue := (aColor red * 255) rounded bitAnd: 16rFF. 
	gValue := (aColor green * 255) rounded bitAnd: 16rFF.
	bValue := (aColor blue * 255) rounded bitAnd: 16rFF.
	command := ByteArray with: 23 with: aNumber with: rValue with: gValue with: bValue with: auto.
	self sendCommand: command
]

{ #category : 'neopixel' }
TMXDriver >> neopixelnr: aNumber r: rValue g: gValue b: bValue [
	"set pixen number aNumber (0 - maxpixels) to rgb and defalt disable autoshow"
	"SET_NEO_PIXEL = 23"
	| auto command|
	auto := 0.
	
	command := ByteArray with: 23 with: aNumber with: rValue with: gValue with: bValue with: auto.
	self sendCommand: command
]

{ #category : 'neopixel' }
TMXDriver >> neopixelnr: aNumber r: rValue g: gValue b: bValue autoShow: boolean [
	"set pixen number aNumber (0 - maxpixels) to rgb and enable or disable autoshow"
	"SET_NEO_PIXEL = 23"
	| auto command|
	auto := 0.
	boolean ifTrue: [ auto := 1 ].
	command := ByteArray with: 23 with: aNumber with: rValue with: gValue with: bValue with: auto.
	self sendCommand: command
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
	"note this is called analog_write in the Python version, as is often done. This is misleading becausoe
	 some MCU's have a real ADC for analog output. Value must be less than 256"
	"ANALOG_WRITE = 3"
	
	| command |
	
	command := ByteArray with: 3 with: aPin with: aNumber .
	self sendCommand: command
]

{ #category : 'testing' }
TMXDriver >> sendCommand: aByteArray [
	| buffer |
	(aByteArray size > 255) ifTrue: [self halt].
	buffer := (aByteArray size asByteArray) , aByteArray .
	commandStream nextPutAll: buffer; flush
]

{ #category : 'pwm-servo' }
TMXDriver >> servoDetach [
]

{ #category : 'pwm-servo' }
TMXDriver >> servoDetachFromPin: aPin [
	"evidently you can't just assign another mode to the pin
	SERVO_DETACH = 9"
	
	self sendCommand: (ByteArray with: 9 with: aPin)
]

{ #category : 'pwm-servo' }
TMXDriver >> servoValue: angle intoPin: aPin [
	"SERVO_WRITE = 8, angle between 0 and 180"

	| command |
	
	command := ByteArray with: 8 with: aPin with: angle .
	self sendCommand: command
]

{ #category : 'as yet unclassified' }
TMXDriver >> setAnalogScanInterval [
]

{ #category : 'analog io' }
TMXDriver >> setAnalogScanInterval: aByteValue [
	"default is 19 ms. Note that with a small differential this leads to an overload of messages
	SET_ANALOG_SCANNING_INTERVAL = 16"
	| command |
	command := ByteArray with: 16 with: (aByteValue bitAnd: 16rFF).
	self sendCommand: command
]

{ #category : 'as yet unclassified' }
TMXDriver >> setupAnalogInputSubscription [
	self when: TMXAnalogInputEvent do: [ :ann |
			('analog pin: ', (ann pinNr printString), ' became ', (ann pinValue printString), 
										' at ', (ann timestamp printString )) traceCr] for: self. 
	
]

{ #category : 'as yet unclassified' }
TMXDriver >> setupDigitalInputSubscription [
	self when: TMXDigitalInputEvent do: [ :ann |
			('digital pin: ', (ann pinNr printString), ' became ', (ann pinValue printString), 
										' at ', (ann timestamp printString )) traceCr] for: self. 
	
]

{ #category : 'as yet unclassified' }
TMXDriver >> setupLoopbackSubscription [
	self when: TMXLoopbackEvent do: [ :ann | ('loopback: ', (ann data) traceCr) ]  for: self
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
	listener := (TMXListener new withStream: commandStream for: self; yourself).
	listener start
]

{ #category : 'announcement handling' }
TMXDriver >> when: anEvent do: aBlock [ 
	listener announcer when: anEvent do: aBlock
]

{ #category : 'announcement handling' }
TMXDriver >> when: anEvent do: aBlock for: anObject [ 
	listener announcer when: anEvent do: aBlock for: anObject
]
