"
I drive the TMX demon on a Ardiono Uno. Actually there are lost of different Uno's , that will only differ in the =ir constantsDict. All use the SerialPort
"
Class {
	#name : 'TMXUnoFamiliyDriver',
	#superclass : 'TMXSerialDriver',
	#instVars : [
		'i2cActive1'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'i2c' }
TMXUnoFamiliyDriver >> activateI2C [

	self activateI2CChannel: 0
]

{ #category : 'i2c' }
TMXUnoFamiliyDriver >> activateI2CChannel: zeroone [
	"special for the UNO family: i2c channel (port) 0 or 1"
	
	self sendCommand: (ByteArray with: (self idFrom: 'I2C_BEGIN') with: zeroone).
	(zeroone = 0) ifTrue: [ self i2cActivated: true ] ifFalse: [ self i2cActivated1: true].
]

{ #category : 'as yet unclassified' }
TMXUnoFamiliyDriver >> beDHT11OnPin: aPin [
	"unop distinguishes the DHT11 and DHT22"
		| command |
	
	command := ByteArray with: (self idFrom: 'DHT_NEW') with: aPin with: 11.
	self sendCommand: command
]

{ #category : 'as yet unclassified' }
TMXUnoFamiliyDriver >> beDHT22OnPin: aPin [
	"unop distinguishes the DHT11 and DHT22"
		| command |
	
	command := ByteArray with: (self idFrom: 'DHT_NEW') with: aPin with: 22.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXUnoFamiliyDriver >> beDHTOnPin: aPin [
	"take DHT11 as default, arbitrarily"
	
	self beDHT11OnPin: aPin
]

{ #category : 'pin modes' }
TMXUnoFamiliyDriver >> beDigitalInputPullupOnPin: aPin [
	"(mode = 2). The 1 at the end enables reporting"
		| command |
		
	command := ByteArray with: (self idFrom: 'SET_PIN_MODE') 
		with: aPin with: (self idFrom: 'AT_INPUT_PULLUP') with: 1.
	self sendCommand: command
]

{ #category : 'as yet unclassified' }
TMXUnoFamiliyDriver >> i2cActivated1 [
	^self status i2cActivated1
]

{ #category : 'as yet unclassified' }
TMXUnoFamiliyDriver >> i2cReadFromAdress: anAddress register: aRegister count: byteCount [
	self i2cReadFromAdress: anAddress register: aRegister count: byteCount channel: 0
]

{ #category : 'as yet unclassified' }
TMXUnoFamiliyDriver >> i2cReadFromAdress: anAddress register: aRegister count: byteCount channel: number [
	"read and stop transmission, ie stop_transmission = true
	I2C_READ = 11; last ! makes stop-transmission true
	for Uno etc add channel,
	"
	
	"(self i2cActivated) ifTrue: [ "
		self sendCommand: (ByteArray with: (self idFrom: 'I2C_READ') 
			with: anAddress) , (ByteArray with: aRegister with: byteCount with: 1 with: number with: 1)
]

{ #category : 'as yet unclassified' }
TMXUnoFamiliyDriver >> i2cReadRestartTransmissionFromAdress: anAddress register: aRegister count: byteCount [
	self i2cReadRestartTransmissionFromAdress: anAddress register: aRegister count: byteCount channel: 0
]

{ #category : 'as yet unclassified' }
TMXUnoFamiliyDriver >> i2cReadRestartTransmissionFromAdress: anAddress register: aRegister count: byteCount channel: number [
	"read and restart transmission, ie stop_transmission = false
	I2C_READ = 11; last ! makes stop-transmission true
	for Uno etc add channel and add last 1 for wrtie register,
	"
	
	"(self i2cActivated) ifTrue: [ "
		self sendCommand: (ByteArray with: (self idFrom: 'I2C_READ') 
			with: anAddress) , (ByteArray with: aRegister with: byteCount with: 0 with: number with: 1)
]

{ #category : 'i2c' }
TMXUnoFamiliyDriver >> i2cWrite: aDataArray toAddress: address [

	self i2cWrite: aDataArray toAddress: address channel: 0 
]

{ #category : 'i2c' }
TMXUnoFamiliyDriver >> i2cWrite: aDataArray toAddress: address channel: number [ 

	"	self i2cActivated ifTrue:	"
	self sendCommand: ((ByteArray with: (self idFrom: 'I2C_WRITE') 
		with: aDataArray size with: address with: number ) , aDataArray)
]

{ #category : 'initialization' }
TMXUnoFamiliyDriver >> initDispatchDict [

	dispatchDict := {
		((self idFrom: 'LOOP_COMMAND') -> #announceLoopbackReport:).
		((self idFrom: 'DEBUG_PRINT') -> #x).
		((self idFrom: 'DIGITAL_REPORT')-> #announceDigitalInput:). 
		((self idFrom: 'ANALOG_REPORT') -> #announceAnalogInput:).
		((self idFrom: 'FIRMWARE_REPORT') -> #announceFirmwareReport:).
		((self idFrom: 'I_AM_HERE_REPORT') -> #announceIAMHere:).
		((self idFrom: 'SERVO_UNAVAILABLE') -> #announceServoUnavailable:).
		((self idFrom: 'I2C_TOO_FEW_BYTES_RCVD') -> #announceI2CTooFewBytesRcvd: ).
		((self idFrom: 'I2C_TOO_MANY_BYTES_RCVD') -> #announceI2CTooManyBytesRcvd:).
		((self idFrom: 'I2C_READ_REPORT') -> #announceI2CReadReportChannel:).
		((self idFrom: 'SONAR_DISTANCE') -> #announceSonarDistance:).
		"(12 -> #announceIMUReport)."
		"(13 -> #announceMicrophoneReport:)."
		((self idFrom: 'DHT_REPORT') -> #announceDHTUnoReport:).
		((self idFrom: 'SPI_REPORT') -> #announceSPIReport:)	.
		(99 -> #announceDebugPrint:).
		"ONE_WIRE_REPORT"
		"STEPPERS..."
		} asDictionary.

]

{ #category : 'i2c' }
TMXUnoFamiliyDriver >> openI2C: address [
	^self openI2C: address channel: 0
]

{ #category : 'as yet unclassified' }
TMXUnoFamiliyDriver >> openI2C: address channel: number [
		"return a I2C Connection as expected by Pots.
	Fill i2cData with a valid timestamp"
	(number = 0) ifTrue: [  
		status i2cActivated ifFalse: [ self activateI2C ]]
	ifFalse: [
		status i2cActivated1 ifFalse: [  self activateI2CChannel: 1 ]].
			
	i2cData at: address put: ( TMXI2CEvent new address: address; count: 1;
		register: 0; bytes: #[0]; channel: number; timestamp: DateAndTime now; yourself ).
	^TMXI2CConnection new address: address; driver: self; channel: number; yourself
]
