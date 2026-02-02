"
I am the TMXDriver for the ESP32. I use WiFi

"
Class {
	#name : 'TMXESP32Driver',
	#superclass : 'TMXIPDriver',
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'analog io' }
TMXESP32Driver >> analogValue: aValue intoPin: aPin [

	self beAnalogOutputOnPin: aPin withValue: aValue
]

{ #category : 'pin modes' }
TMXESP32Driver >> beAnalogOutputOnPin: aPin withValue: anInteger [
" this applies to the DAC of the EP32, not PWM.
this same method also functions to output a analog value (0 - 255 (255= 3.3V 128=1.65V())"
	| command |
	command := ByteArray with: (self idFrom: 'DAC_WRITE') with: aPin with: anInteger.
	self sendCommand: command
]

{ #category : 'pin modes' }
TMXESP32Driver >> bePWMOutputOnPin: aPin [
	"a bit more complicated on the ESP32, as you have to choose the channel and frequency as well"
	^self bePWMOutputOnPin: aPin channel: 0 frequency: 5000.0 resolution: 8
]

{ #category : 'pin modes' }
TMXESP32Driver >> bePWMOutputOnPin: pinNr channel: chanNr frequency: freq resolution: res [
	"pwm on pin pinNr. Channel is 0-15 , frequency 10-300k (float), resolution 8-16) "
	| command bytes|
	"tests"
	
bytes := ByteArray new: 8.
bytes doubleAt: 1 put: freq asFloat bigEndian: false.
command := (ByteArray with: (self idFrom: 'SET_PIN_MODE') with: pinNr 
		with: (self idFrom: 'AT_PWM_OUT') with: chanNr with: res) , bytes.
	self sendCommand: command
]

{ #category : 'as yet unclassified' }
TMXESP32Driver >> disableDacOnPin: aPin [

	| command |
	command := ByteArray new with: (self idFrom: 'DAC_DISABLE') with: aPin.
	self sendCommand: command
	
]

{ #category : 'initialization' }
TMXESP32Driver >> initConstantsDict [
	"device specifc data and constants"
	constantsDict 
		at: 'DIPins' put: #(4 5 12 13 14 16 17 18 19 21 22 23 25 26 27 32 33);
		at: 'DOPins' put: #(2 4 5 12 13 14 16 17 18 19 21 22 23 25 26 27 32 33);
		at: 'TouchPins' put: #(4 12 13 14 15 27 32 33);
		at: 'AIPins' put: #(32 33 34 35 36 39);
		at: 'ServoPins' put: #(4 5 12 13 14 16 17 18 19 21 22 23 25 26 27 32 33). 
	constantsDict		
		at: 'LOOP_COMMAND' put: 0;
		at: 'SET_PIN_MODE' put: 1;
		at: 'DIGITAL_WRITE' put: 2;
		at: 'ANALOG_WRITE' put: 3;
		at: 'MODIFY_REPORTING' put: 4;
		at: 'GET_FIRMWARE_VERSION' put: 5;
	"	at: 'ARE_U_THERE' put: 6; "
		at: 'SERVO_ATTACH' put: 6;
		at: 'SERVO_WRITE' put: 7;
		at: 'SERVO_DETACH' put: 8;
		at: 'I2C_BEGIN' put: 9;
		at: 'I2C_READ' put: 10;
		at: 'I2C_WRITE' put: 11;
		at: 'SONAR_NEW' put: 12;
		at: 'DHT_NEW' put: 13;
		at: 'STOP_ALL_REPORTS' put: 14;
		at: 'SET_ANALOG_SCANNING_INTERVAL' put: 15;
		at: 'ENABLE_ALL_REPORTS' put: 16;
		at: 'ANALOG_OUT_ATTACH' put: 17;
		at: 'ANALOG_OUT_DETACH' put: 18;
		at: 'DAC_WRITE' put: 19;
		at: 'RESET' put: 20;
		at: 'DAC_DISABLE' put: 21;
		at: 'SPI_INIT' put: 22;
		at: 'SPI_WRITE_BLOCKING' put: 23;
		at: 'SPI_READ_BLOCKING' put: 24;
		at: 'SPI_SET_FORMAT' put: 25;
		at: 'SPI_CS_CONTROL' put: 26;
		at: 'ONE_WIRE_INIT' put: 27;
		at: 'ONE_WIRE_RESET' put: 28;
		at: 'ONE_WIRE_SELECT' put: 29;
		at: 'ONE_WIRE_SKIP' put: 30;
		at: 'ONE_WIRE_WRITE' put: 31;
		at: 'ONE_WIRE_READ' put: 32;
		at: 'ONE_WIRE_RESET_SEARCH' put: 33;
		at: 'ONE_WIRE_SEARCH' put: 34;
		at: 'ONE_WIRE_CRC8' put: 35;
		at: 'SET_PIN_MODE_STEPPER' put: 36;
		at: 'STEPPER_MOVE_TO' put: 37;
		at: 'STEPPER_MOVE' put: 38;
		at: 'STEPPER_RUN' put: 39;
		at: 'STEPPER_RUN_SPEED' put: 40;
		at: 'STEPPER_SET_MAX_SPEED' put: 41;
		at: 'STEPPER_SET_ACCELERATION' put: 42;
		at: 'STEPPER_SET_SPEED' put: 43;
		at: 'STEPPER_SET_CURRENT_POSITION' put: 44;
		at: 'STEPPER_RUN_SPEED_TO_POSITION' put: 45;
		at: 'STEPPER_STOP' put: 46;
		at: 'STEPPER_DISABLE_OUTPUTS' put: 47;
		at: 'STEPPER_ENABLE_OUTPUTS' put: 48;
		at: 'STEPPER_SET_MINIMUM_PULSE_WIDTH' put: 49;
		at: 'STEPPER_SET_ENABLE_PIN' put: 50;
		at: 'STEPPER_SET_3_PINS_INVERTED' put: 51;
		at: 'STEPPER_SET_4_PINS_INVERTED' put: 52;
		at: 'STEPPER_IS_RUNNING' put: 53;
		at: 'STEPPER_GET_CURRENT_POSITION' put: 54;
		at: 'STEPPER_GET_DISTANCE_TO_GO' put: 55;
		at: 'STEPPER_GET_TARGET_POSITION' put: 56;
	"	at: 'GET_FEATURES' put: 54;
		at: 'SONAR_DISABLE' put: 55;
		at: 'SONAR_ENABLE' put: 56;  "
		at: 'DIGITAL_REPORT' put: 2;
		at: 'ANALOG_REPORT' put: 3;
		at: 'FIRMWARE_REPORT' put: 5;
"		at: 'I_AM_HERE_REPORT' put: 6; "
		at: 'SERVO_UNAVAILABLE' put: 6;
		at: 'I2C_TOO_FEW_BYTES_RCVD' put: 7;
		at: 'I2C_TOO_MANY_BYTES_RCVD' put: 8;
		at: 'I2C_READ_REPORT' put: 9;
		at: 'SONAR_DISTANCE' put: 10;
		at: 'DHT_REPORT' put: 11;
		at: 'TOUCH_Report' put: 12;
		at: 'SPI_REPORT' put: 13;
		at: 'ONE_WIRE_REPORT' put: 14;
		at: 'STEPPER_DISTANCE_TO_GO' put: 15;
		at: 'STEPPER_TARGET_POSITION' put: 16;
		at: 'STEPPER_CURRENT_POSITION' put: 17;
		at: 'STEPPER_RUNNING_REPORT' put: 18;
		at: 'STEPPER_RUN_COMPLETE_REPORT' put: 19;
		at: 'FEATURES' put: 20;
		at: 'DEBUG_PRINT' put: 99;
		at: 'TELEMETRIX_ESP#@_VERSION' put: '12.0.0';
		at: 'REPORTING_DISABLE_ALL' put: 0;
		at: 'REPORTING_ANALOG_ENABLE' put: 1;
		at: 'REPORTING_DIGITAL_ENABLE' put: 2;
		at: 'REPORTING_ANALOG_DISABLE' put: 3;
		at: 'REPORTING_DIGITAL_DISABLE' put: 4;
"pin mode definitions"
		at: 'AT_INPUT' put: 0;
		at: 'AT_OUTPUT' put: 1;
		at: 'AT_INPUT_PULLUP' put: 2;
		at: 'AT_ANALOG' put: 3;
		at: 'AT_SERVO' put: 4;
		at: 'AT_SONAR' put: 5;
		at: 'AT_DHT' put: 6;
		at: 'AT_TOUCH' put: 7;
		at: 'AT_PWM_OUT' put: 8;
		at: 'AT_INPUT_PULL_DOWN' put: 9;
		at: 'AT_MODE_NOT_SET' put: 255;

		at: 'MAX_SONARS' put: 6;
		at: 'MAX_DHTS' put: 6;
		at: 'DHT_DATA' put: 0;
		at: 'DHT_ERROR' put: 1;
"not used in esp32
		at: 'ONEWIRE_FEATURE' put: 16r01;
		at: 'DHT_FEATURE' put: 16r02;
		at: 'STEPPERS_FEATURE' put: 16r04;
		at: 'SPI_FEATURE' put: 16r08;
		at: 'SERVO_FEATURE' put: 16r10;
		at: 'SONAR_FEATURE' put: 16r20. "
"added"
		at: 'I2C_SDA' put: 21;
		at: 'I2C_SLK' put: 22;
		at: 'DAC_1' put: 25;
		at: 'DAC_2' put: 26.
]

{ #category : 'initialization' }
TMXESP32Driver >> initDispatchDict [
	"for "
	dispatchDict := {
		((self idFrom: 'LOOP_COMMAND') -> #announceLoopbackReport:).
		((self idFrom: 'DEBUG_PRINT') -> #x).
		((self idFrom: 'DIGITAL_REPORT') -> #announceDigitalInput:). 
		((self idFrom: 'ANALOG_REPORT') -> #announceAnalogInput:).
		((self idFrom: 'FIRMWARE_REPORT') -> #announceFirmwareReport:).
		"(self idFrom: 'I_AM_HERE_REPORT' -> #announceIAMHere:)."
		((self idFrom: 'SERVO_UNAVAILABLE') -> #announceServoUnavailable:).
		((self idFrom: 'I2C_TOO_FEW_BYTES_RCVD') -> #announceI2CTooFewBytesRcvd: ).
		((self idFrom: 'I2C_TOO_MANY_BYTES_RCVD') -> #announceI2CTooManyBytesRcvd:).
		((self idFrom: 'I2C_READ_REPORT') -> #announceI2CReadReport:).
		((self idFrom: 'SONAR_DISTANCE') -> #announceSonarDistance:).
		"(12 -> #announceIMUReport)."
		"(13 -> #announceMicrophoneReport:)."
		((self idFrom: 'DHT_REPORT') -> #announceDHTReport:).
		((self idFrom: 'SPI_REPORT') -> #announceSPIReport:)	.
		((self idFrom: 'TOUCH_Report') -> #announceTouchReport).
		"one wire"
		(99 -> #announceDebugPrint:).
		} asDictionary.
]

{ #category : 'initialization' }
TMXESP32Driver >> initPins [

	pins pwm: #(2 4 5 12 13 14 16 17 18 19 21
           22 23 25 26 27 32 33) asSet.
	pins servo: #(4 5 12 13 14 16 17 18 19 21 22 23 25 26 27 32 33) asSet.
	pins ai: #(32 33 34 35 36 39) asSet.
	pins di: #(4 5 12 13 14 16 17 18 19 21 22 23 25 26 27 32 33) asSet.
	pins do: (pins di).	
	pins ao: #(25 26) asSet.
	pins dht: (pins di).
	pins sonar: (pins di).
]

{ #category : 'initialization' }
TMXESP32Driver >> initialize [

	super initialize.
	self initConstantsDict.
	self initDispatchDict.
]

{ #category : 'io protocols' }
TMXESP32Driver >> pwmValue: aNumber intoPin: aPin [
	"note this is called analog_write in the Python version, as is often done. This is misleading becausoe
	 some MCU's have a real DAC for analog output. On the ESP32 the value can be up to 15 bits (to be set in bePWMOutputOmPin..)."
	"ANALOG_WRITE = 3"
	
	| command |
	
	command := ByteArray with: (self idFrom: 'ANALOG_WRITE')
			with: aPin with: (aNumber >> 8) with: (aNumber bitAnd: 16rFF) .
	self sendCommand: command
]
