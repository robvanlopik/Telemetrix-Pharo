"
I am the abstract superclass of all Telemetrix drivers.
Telemetrix supports a number of data transport methods. 
Abstract drivers for TCP/IR transport and Serial link are my subclasses.

The transport mechanism must support the Stream protocol. In the IP case we use SocketStream. For the serial port we have TMXSerialStream that supports just enough methods to function for this purpose.

I can be opened on a stream; the subclasses specialze to opening on IP or Serial port.

I contain almost all code to implement all Telemetrix functions. Because of the asynchronous nature of the Telemetrix protocol, I am supported by TMXListener.

All results coming from the device are wrapped in announcements, subclasses of TMXAnnouncement.
At the same time the latest result are also storen in instance variable. Reading these gives the most recent result.

The specialisation for the different Telemetrix servers is for the most part accomplished through the instance variable constantsDict and dispatchDict that are filled by the initialisation method of my final subclasses.

BTW the easiest way to find the different Telemetrix servers is through the Arduino IDE: look for Telemetrix exexmples. 
"
Class {
	#name : 'TMXDriver',
	#superclass : 'Object',
	#instVars : [
		'listener',
		'forkAnnouncements',
		'i2cData',
		'diData',
		'aiData',
		'dhtData',
		'constantsDict',
		'tmxStream',
		'sonarData',
		'status',
		'dispatchDict',
		'pins'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
TMXDriver class >> connectThrough: aStream [
	"this is the fecailt method to start a TMXdriver
	aStream has to be operational
	specialisation is through the initialize method in the subclass"
	
		^self new tmxStream: aStream
	
]

{ #category : 'testing' }
TMXDriver class >> isAbstract [

	^ self == TMXDriver
]

{ #category : 'instance creation' }
TMXDriver class >> on: aTMXStream [

	^self basicNew initialize tmxStream: aTMXStream; startListener; yourself
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
	I2C_BEGIN = 10(
    I2C_READ = 11
    I2C_WRITE = 12"

	self sendCommand: (ByteArray with: (self idFrom: 'I2C_BEGIN')).
	status i2cActivated: true
]

{ #category : 'accessing' }
TMXDriver >> aiData [

	^ aiData
]

{ #category : 'accessing' }
TMXDriver >> aiData: anObject [

	aiData := anObject
]

{ #category : 'io protocols' }
TMXDriver >> analogValueFromPin: aPin [
	"should check whether pin is reporting otherwise setting it to input als activates reporting"
	| pinValue |
	(self aiData includesKey: aPin) ifFalse: [
		self beAnalogInputOnPin: aPin. 100 milliSeconds wait ].
	pinValue := (self aiData at: aPin) pinValue.
	^pinValue
	
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
anInt can be more than 8 bits. At the end add a 1 to enable reporting"
	| command |
	command := ByteArray with: (self idFrom: 'SET_PIN_MODE' ) with: aPin with: (self idFrom: 'AT_ANALOG')
		with: (anInt >> 8) with: (anInt bitAnd: 16rFF) with: 1.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXDriver >> beAnalogOutputOnPin: aPin [
" actually this is pwm output"
	self bePWMOutputOnPin: aPin
]

{ #category : 'pin modes' }
TMXDriver >> beDHTOnPin: aPin [
	"DHT_NEW mode is 31 in Nano2040 and 13 in Uno"
	| command |
	
	command := ByteArray with: (self idFrom: 'DHT_NEW') with: aPin.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXDriver >> beDigitalInputOnPin: aPin [
	"mode = 0. The 1 at the end enables reporting"
		| command |
		
	command := ByteArray with: (self idFrom: 'SET_PIN_MODE') with: aPin with: (self idFrom: 'AT_INPUT') with: 1.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXDriver >> beDigitalInputPullupOnPin: aPin [
	"mode = 2. The 1 at the end enables reporting"
		| command |
		
	command := ByteArray with: (self idFrom: 'SET_PIN_MODE') 
		with: aPin with: (self idFrom: 'AT_INPUT_PULLUP') with: 1.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXDriver >> beDigitalOutputOnPin: aPin [
	"mode = 1"
		| command |
	
	command := ByteArray with: (self idFrom: 'SET_PIN_MODE') with: aPin with: (self idFrom: 'AT_OUTPUT').
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
	command := ByteArray with: (self idFrom: 'INITIALIZE_NEO_PIXELS')
	   with: aPin with: anInt with: r with: g with: b.
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
	command := ByteArray with: (self idFrom: 'INITIALIZE_NEO_PIXELS')
		with: aPin with: anInt with: r with: g with: b.
	self sendCommand: command
	"self.neopixels_initiated = True"
]

{ #category : 'pin modes' }
TMXDriver >> bePWMOutputOnPin: aPin [
	"TMX calls this analog output"
	| command |
	
	command := ByteArray with: (self idFrom: 'SET_PIN_MODE') with: aPin with: (self idFrom: 'ANALOG_WRITE').
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
	
	command := ByteArray with: (self idFrom: 'SERVO_ATTACH') with: aPin 
		with: ((int1 bitAnd: 16rFF00) >> 8) with: (int1 bitAnd: 16rFF)
		with: ((int2 bitAnd: 16rFF00) >> 8) with: (int2 bitAnd: 16rFF).
	self sendCommand: command
	
]

{ #category : 'sonar' }
TMXDriver >> beSonarWithTrigger: pin1 echo: pin2 [
	"setup distance meqsurement. Shouls check for max nr of sonars"
	
		| command |
		command := ByteArray with: (self idFrom: 'SONAR_NEW')
				with: pin1 with: pin2 .
				
		self sendCommand: command
	
]

{ #category : 'pin modes' }
TMXDriver >> detachServoFromPin: aPin [
	"not sure what this does
	SERVO_DETACH = 9"
	| command |
	
	command := ByteArray with: (self idFrom: 'SERVO_DETACH') with: aPin .
	self sendCommand: command
]

{ #category : 'accessing' }
TMXDriver >> dhtData [

	^ dhtData
]

{ #category : 'accessing' }
TMXDriver >> dhtData: anObject [

	dhtData := anObject
]

{ #category : 'accessing' }
TMXDriver >> diData [

	^ diData
]

{ #category : 'accessing' }
TMXDriver >> diData: anObject [

	diData := anObject
]

{ #category : 'io protocols' }
TMXDriver >> digitalValue: oneOrZero intoPin: aPin [
	"digital_write = 2"
	| command |
	
	command := ByteArray with: (self idFrom: 'DIGITAL_WRITE') with: aPin with: oneOrZero .
	self sendCommand: command
]

{ #category : 'io protocols' }
TMXDriver >> digitalValueFromPin: aPin [
	"should check whether pin is reporting otherwise setting it to input als activates reporting"
	| pinValue |
	(self diData includesKey: aPin) ifFalse: [
		self beDigitalInputOnPin: aPin. 100 milliSeconds wait ].
	pinValue := (self diData at: aPin) pinValue.
	^pinValue
	
]

{ #category : 'change reporting' }
TMXDriver >> disableAllReporting [
	"MODIFY_REPORTING = 4
	REPORTING_DISABLE_ALL = 0
	dont know role of last 0"
	| command |
	command := ByteArray with: (self idFrom: 'MODIFY_REPORTING') 
		with: (self idFrom: 'REPORTING_DISABLE_ALL') with: 0.
	self sendCommand: command
]

{ #category : 'change reporting' }
TMXDriver >> disableAnalogReportingOnPin: aPin [
	"MODIFY_REPORTING = 4"
	"REPORTING_ANALOG_DISABLE = 3"
	| command |
	command := ByteArray with: (self idFrom: 'MODIFY_REPORTING') 
		with: (self idFrom: 'REPORTING_ANALOG_DISABLE') with: aPin.
	self sendCommand: command
]

{ #category : 'change reporting' }
TMXDriver >> disableDigitalReportingOnPin: aPin [
	"MODIFY_REPORTING = 4
	REPORTING_DDIGITAL_DISABLE = 4"
	| command |
	command := ByteArray with: (self idFrom: 'MODIFY_REPORTING') 
		with: (self idFrom: 'REPORTING_DDIGITAL_DISABLE' ) with: aPin.
	self sendCommand: command
]

{ #category : 'accessing' }
TMXDriver >> dispatchDict [

	^ dispatchDict
]

{ #category : 'sonar' }
TMXDriver >> distanceFronPin: pinNumber [
	^(self sonarData at: pinNumber) distance
]

{ #category : 'change reporting' }
TMXDriver >> enableAnalogReportingOnPin: aPin [
	"MODIFY_REPORTING = 4
	REPORTING_ANALOG_ENABLE = 1"
	| command |
	command := ByteArray with: (self idFrom: 'MODIFY_REPORTING')
		 with: (self idFrom: 'REPORTING_ANALOG_ENABLE') with: aPin.
	self sendCommand: command

]

{ #category : 'change reporting' }
TMXDriver >> enableDigitalReportingOnPin: aPin [
	"MODIFY_REPORTING = 4
	REPORTING_DIGITAL_ENBLE = 2"
	| command |
	command := ByteArray with: (self idFrom: 'MODIFY_REPORTING') 
		with: (self idFrom: 'REPORTING_DIGITAL_ENBLE') with: aPin.
	self sendCommand: command
]

{ #category : 'accessing' }
TMXDriver >> forkAnnouncements [
	^forkAnnouncements
]

{ #category : 'accessing' }
TMXDriver >> forkAnnouncements: aBoolean [
	forkAnnouncements := aBoolean
]

{ #category : 'dht' }
TMXDriver >> humidityFromDHTPin: pinNumber [

	^(dhtData at: pinNumber) humidity
]

{ #category : 'testing' }
TMXDriver >> i2cActivated [

	^ status i2cActivated
]

{ #category : 'testing' }
TMXDriver >> i2cActivated: aBoolean [

	status i2cActivated: aBoolean 
]

{ #category : 'accessing' }
TMXDriver >> i2cData [

	^ i2cData
]

{ #category : 'accessing' }
TMXDriver >> i2cData: anObject [

	i2cData := anObject
]

{ #category : 'i2c' }
TMXDriver >> i2cReadFromAdress: anAddress register: aRegister count: byteCount [
	"read and stop transmission, ie stop_transmission = true
	I2C_READ = 11; last ! makes stop-transmission true
	"
	
	self i2cActivated ifTrue: [ 
		self sendCommand: (ByteArray with: (self idFrom: 'I2C_READ') 
			with: anAddress with: aRegister with: byteCount with: 1)]
]

{ #category : 'i2c' }
TMXDriver >> i2cReadRestartTransmissionFromAdress: anAddress register: aRegister count: byteCount [
	"read and stop transmission, ie stop_transmission = false
	I2C_READ = 11
	"
	
	self i2cActivated ifTrue: [ 
		self sendCommand: (ByteArray with: ( self idFrom: 'I2C_READ' ) 
		with: anAddress with: aRegister with: byteCount with: 0)]
]

{ #category : 'i2c' }
TMXDriver >> i2cWrite: aDataArray toAddress: anAddress [
	"I2C_WRITE = 12; data is a ByteAray"
	
	self i2cActivated ifTrue:	
	[self sendCommand: ((ByteArray with: (self idFrom: 'I2C_WRITE') 
		with: aDataArray size with: anAddress) , aDataArray)]
]

{ #category : 'computing' }
TMXDriver >> idFrom: aString [

	(constantsDict includesKey: aString) ifFalse: [ self error: ('constant ', aString, ' not known')].
	^constantsDict at: aString
]

{ #category : 'initialization' }
TMXDriver >> initialize [ 

	super initialize.
	forkAnnouncements := false.
	i2cData := Dictionary new.
	diData := Dictionary new.
	aiData := Dictionary new.
	dhtData := Dictionary new.
	sonarData := Dictionary new.
	constantsDict := Dictionary new.
	status := TMXStatus new.
	pins := TMXPins new.

	
]

{ #category : 'testing' }
TMXDriver >> isConnected [

	^tmxStream notNil
]

{ #category : 'accessing' }
TMXDriver >> listener [
	^listener
]

{ #category : 'accessing' }
TMXDriver >> listener: anObject [

	listener := anObject
]

{ #category : 'testing' }
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
	self sendCommand: (ByteArray with: (self idFrom: 'CLEAR_ALL_NEO_PIXELS') with: 0)
]

{ #category : 'neopixel' }
TMXDriver >> neopixelClearNow [
	"clear the display and immediately show it"
	"CLEAR_ALL_NEO_PIXELS = 24"
	self sendCommand: (ByteArray with: (self idFrom: 'CLEAR_ALL_NEO_PIXELS') with: 1)
]

{ #category : 'neopixel' }
TMXDriver >> neopixelFillLaterColor: aColor [
	"Set all pixels to aColor, abut don't show it yet"
	"FILL_ALL_NEO_PIXELS = 25"
	| r g b |
	r := (aColor red * 255) rounded bitAnd: 16rFF.
	g := (aColor green * 255) rounded bitAnd: 16rFF.
	b := (aColor blue * 255) rounded bitAnd: 16rFF.
	self sendCommand: (ByteArray with: (self idFrom: 'FILL_ALL_NEO_PIXELS') with: r with: g with: b with: 0)
]

{ #category : 'neopixel' }
TMXDriver >> neopixelFillNowColor: aColor [
	"Set all pixels to aColor, and show it"
	"FILL_ALL_NEO_PIXELS = 25"
	| r g b |
	r := (aColor red * 255) rounded bitAnd: 16rFF.
	g := (aColor green * 255) rounded bitAnd: 16rFF.
	b := (aColor blue * 255) rounded bitAnd: 16rFF.
	self sendCommand: (ByteArray with: (self idFrom: 'FILL_ALL_NEO_PIXELS') with: r with: g with: b with: 1)
]

{ #category : 'neopixel' }
TMXDriver >> neopixelNr: aNumber color: aColor [
	"set pixen number aNumber (0 - maxpixels) to rgb and default disable autoshow"
	"SET_NEO_PIXEL = 23"
	| auto command rValue gValue bValue|
	auto := 0.
	rValue := (aColor red * 255) rounded bitAnd: 16rFF. 
	gValue := (aColor green * 255) rounded bitAnd: 16rFF.
	bValue := (aColor blue * 255) rounded bitAnd: 16rFF.
	command := ByteArray with: (self idFrom: 'SET_NEO_PIXEL') 
			with: aNumber with: rValue with: gValue with: bValue with: auto.
	self sendCommand: command
]

{ #category : 'neopixel' }
TMXDriver >> neopixelNr: aNumber color: aColor autoShow: boolean [
	"set pixen number aNumber (0 - maxpixels) to rgb and enable or disable autoshow"
	"SET_NEO_PIXEL = 23"
	| auto command rValue gValue bValue|
	auto := 0.
	boolean ifTrue: [ auto := 1 ].
	rValue := (aColor red * 255) rounded bitAnd: 16rFF. 
	gValue := (aColor green * 255) rounded bitAnd: 16rFF.
	bValue := (aColor blue * 255) rounded bitAnd: 16rFF.
	command := ByteArray with: (self idFrom: 'SET_NEO_PIXEL') with: aNumber with: rValue with: gValue with: bValue with: auto.
	self sendCommand: command
]

{ #category : 'neopixel' }
TMXDriver >> neopixelNr: aNumber r: rValue g: gValue b: bValue [
	"set pixen number aNumber (0 - maxpixels) to rgb and defalt disable autoshow"
	"SET_NEO_PIXEL = 23"
	| auto command|
	auto := 0.
	
	command := ByteArray with: (self idFrom: 'SET_NEO_PIXEL') with: aNumber with: rValue with: gValue with: bValue with: auto.
	self sendCommand: command
]

{ #category : 'neopixel' }
TMXDriver >> neopixelNr: aNumber r: rValue g: gValue b: bValue autoShow: boolean [
	"set pixen number aNumber (0 - maxpixels) to rgb and enable or disable autoshow"
	"SET_NEO_PIXEL = 23"
	| auto command|
	auto := 0.
	boolean ifTrue: [ auto := 1 ].
	command := ByteArray with: 23 with: aNumber with: rValue with: gValue with: bValue with: auto.
	self sendCommand: command
]

{ #category : 'neopixel' }
TMXDriver >> neopixelShow [
	"Write the NeoPixel buffer stored on the server to the NeoPixel device."
	"SHOW_NEO_PIXELS = 22"
	self sendCommand: (ByteArray with: (self idFrom: 'SHOW_NEO_PIXELS'))
]

{ #category : 'i2c' }
TMXDriver >> openI2C: i2cAddress [
	"return a I2C Connection as expected by Pots.
	Fill i2cData with a valid timestamp"
	status i2cActivated ifFalse: [ self activateI2C ].
	i2cData at: i2cAddress put: ( TMXI2CEvent new address: i2cAddress; count: 1;
		register: 0; bytes: #[0]; timestamp: DateAndTime now; yourself ).
	^TMXI2CConnection new address: i2cAddress; driver: self; yourself
]

{ #category : 'to be done' }
TMXDriver >> openIMU [
]

{ #category : 'to be done' }
TMXDriver >> openMichrophone [
]

{ #category : 'SPI' }
TMXDriver >> openSPI [
]

{ #category : 'io protocols' }
TMXDriver >> pwmValue: aNumber intoPin: aPin [
	"note this is called analog_write in the Python version, as is often done. This is misleading becausoe
	 some MCU's have a real DAC for analog output. Value must be less than 256"
	"ANALOG_WRITE = 3"
	
	| command |
	
	command := ByteArray with: (self idFrom: 'ANALOG_WRITE') with: aPin with: aNumber .
	self sendCommand: command
]

{ #category : 'initialization' }
TMXDriver >> reset [
	| command |
	command := ByteArray with: (self idFrom: 'RESET').
	self sendCommand: command
]

{ #category : 'private' }
TMXDriver >> sendCommand: aByteArray [
	| buffer | 
	(aByteArray size > 255) ifTrue: [self error: 'packet too long'].
	buffer := (aByteArray size asByteArray) , aByteArray .
	tmxStream nextPutAll: buffer; flush
]

{ #category : 'pwm-servo' }
TMXDriver >> servoDetachFromPin: aPin [
	"evidently you can't just assign another mode to the pin
	SERVO_DETACH = 9"
	
	self sendCommand: (ByteArray with: (self idFrom: 'SERVO_DETACH') with: aPin)
]

{ #category : 'pwm-servo' }
TMXDriver >> servoValue: angle intoPin: aPin [
	"SERVO_WRITE = 8, angle between 0 and 180"

	| command |
	
	command := ByteArray with: (self idFrom: 'SERVO_WRITE') with: aPin with: angle .
	self sendCommand: command
]

{ #category : 'analog io' }
TMXDriver >> setAnalogScanInterval: aByteValue [
	"default is 19 ms. Note that with a small differential this leads to an overload of messages
	SET_ANALOG_SCANNING_INTERVAL = 16"
	| command |
	command := ByteArray with: (self idFrom: 'SET_ANALOG_SCANNING_INTERVAL') with: (aByteValue bitAnd: 16rFF).
	self sendCommand: command
]

{ #category : 'utilities' }
TMXDriver >> setupAnalogInputSubscription [
	self when: TMXAnalogInputEvent do: [ :ann |
			('analog pin: ', (ann pinNr printString), ' became ', (ann pinValue printString), 
										' at ', (ann timestamp printString )) traceCr] for: self. 
	
]

{ #category : 'utilities' }
TMXDriver >> setupDHTSubscription [
	self when: TMXDHTEvent do: [ :ann |
			('DHT on pin: ', (ann pinNr printString), ' became ', (ann humidity printString), '% and ',
										(ann temperature printString), 
										'C at ', (ann timestamp printString )) traceCr] for: self. 
	
]

{ #category : 'utilities' }
TMXDriver >> setupDigitalInputSubscription [
	self when: TMXDigitalInputEvent do: [ :ann |
			('digital pin: ', (ann pinNr printString), ' became ', (ann pinValue printString), 
										' at ', (ann timestamp printString )) traceCr] for: self. 
	
]

{ #category : 'utilities' }
TMXDriver >> setupI2CReadSubscription [
	self when: TMXI2CEvent do: [ :ann |
			('address: ', (ann address printString), ' register: ' , (ann register printString), 
										' content ', (ann bytes printString )) traceCr] for: self. 
	
]

{ #category : 'utilities' }
TMXDriver >> setupLoopbackSubscription [
	self when: TMXLoopbackEvent do: [ :ann | ('loopback: ', (ann data) traceCr) ]  for: self
]

{ #category : 'utilities' }
TMXDriver >> setupSonarSubscription [
	"setup subscription to sonar measurement, write to Tramscript"
	self when: TMXSonarEvent do: [ :ann |
			('pin  ', (ann pinNr printString), ' measured distance  ', (ann distance printString), 
										' at ', (ann timestamp printString )) traceCr] for: self. 
	
]

{ #category : 'finalization' }
TMXDriver >> shutdown [
	listener stop.
	self reset
]

{ #category : 'accessing' }
TMXDriver >> sonarData [

	^sonarData
]

{ #category : 'accessing' }
TMXDriver >> sonarData: anObject [

	sonarData := anObject
]

{ #category : 'SPI' }
TMXDriver >> spiCsControl [
]

{ #category : 'SPI' }
TMXDriver >> spiReadBlocking [
]

{ #category : 'SPI' }
TMXDriver >> spiSetFormat [
]

{ #category : 'SPI' }
TMXDriver >> spiWriteBlocking [
]

{ #category : 'initialization' }
TMXDriver >> startListener [ 
	listener ifNotNil: [^self].
	listener := (TMXListener new withStream: tmxStream for: self; yourself).
	listener start
]

{ #category : 'accessing' }
TMXDriver >> status [

	^ status
]

{ #category : 'accessing' }
TMXDriver >> status: anObject [

	status := anObject
]

{ #category : 'finalization' }
TMXDriver >> stopListener [
	listener stop
]

{ #category : 'dht' }
TMXDriver >> temperatureFromDHTPin: pinNumber [

	^(dhtData at: pinNumber) temperature
]

{ #category : 'accessing' }
TMXDriver >> tmxStream [
	^tmxStream
]

{ #category : 'accessing' }
TMXDriver >> tmxStream: anObject [

	tmxStream := anObject
]

{ #category : 'announcement handling' }
TMXDriver >> when: anEvent do: aBlock for: anObject [ 
	listener announcer when: anEvent do: aBlock for: anObject
]
