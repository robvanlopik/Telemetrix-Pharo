Class {
	#name : 'TMXUnoDriver',
	#superclass : 'TMXUnoFamiliyDriver',
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
TMXUnoDriver >> initConstantsDict [ 
constantsDict
at: 'LOOP_COMMAND' put: 0;
at: 'SET_PIN_MODE' put: 1;
at: 'DIGITAL_WRITE' put: 2;
at: 'ANALOG_WRITE' put: 3;
at: 'MODIFY_REPORTING' put: 4;
at: 'GET_FIRMWARE_VERSION' put: 5;
at: 'ARE_U_THERE' put: 6;
at: 'SERVO_ATTACH' put: 7;
at: 'SERVO_WRITE' put: 8;
at: 'SERVO_DETACH' put: 9;
at: 'I2C_BEGIN' put: 10;
at: 'I2C_READ' put: 11;
at: 'I2C_WRITE' put: 12;
at: 'SONAR_NEW' put: 13;
at: 'DHT_NEW' put: 14;
at: 'STOP_ALL_REPORTS' put: 15;
at: 'SET_ANALOG_SCANNING_INTERVAL' put: 16;
at: 'ENABLE_ALL_REPORTS' put: 17;
at: 'RESET' put: 18;
at: 'SPI_INIT' put: 19;
at: 'SPI_WRITE_BLOCKING' put: 20;
at: 'SPI_READ_BLOCKING' put: 21;
at: 'SPI_SET_FORMAT' put: 22;
at: 'SPI_CS_CONTROL' put: 23;
at: 'ONE_WIRE_INIT' put: 24;
at: 'ONE_WIRE_RESET' put: 25;
at: 'ONE_WIRE_SELECT' put: 26;
at: 'ONE_WIRE_SKIP' put: 27;
at: 'ONE_WIRE_WRITE' put: 28;
at: 'ONE_WIRE_READ' put: 29;
at: 'ONE_WIRE_RESET_SEARCH' put: 30;
at: 'ONE_WIRE_SEARCH' put: 31;
at: 'ONE_WIRE_CRC8' put: 32;
at: 'SET_PIN_MODE_STEPPER' put: 33;
at: 'STEPPER_MOVE_TO' put: 34;
at: 'STEPPER_MOVE' put: 35;
at: 'STEPPER_RUN' put: 36;
at: 'STEPPER_RUN_SPEED' put: 37;
at: 'STEPPER_SET_MAX_SPEED' put: 38;
at: 'STEPPER_SET_ACCELERATION' put: 39;
at: 'STEPPER_SET_SPEED' put: 40;
at: 'STEPPER_SET_CURRENT_POSITION' put: 41;
at: 'STEPPER_RUN_SPEED_TO_POSITION' put: 42;
at: 'STEPPER_STOP' put: 43;
at: 'STEPPER_DISABLE_OUTPUTS' put: 44;
at: 'STEPPER_ENABLE_OUTPUTS' put: 45;
at: 'STEPPER_SET_MINIMUM_PULSE_WIDTH' put: 46;
at: 'STEPPER_SET_ENABLE_PIN' put: 47;
at: 'STEPPER_SET_3_PINS_INVERTED' put: 48;
at: 'STEPPER_SET_4_PINS_INVERTED' put: 49;
at: 'STEPPER_IS_RUNNING' put: 50;
at: 'STEPPER_GET_CURRENT_POSITION' put: 51;
at: 'STEPPER_GET_DISTANCE_TO_GO' put: 52;
at: 'STEPPER_GET_TARGET_POSITION' put: 53;
at: 'GET_FEATURES' put: 54;
at: 'SONAR_DISABLE' put: 55;
at: 'SONAR_ENABLE' put: 56;
at: 'DIGITAL_REPORT' put: 2;
at: 'ANALOG_REPORT' put: 3;
at: 'FIRMWARE_REPORT' put: 5;
at: 'I_AM_HERE_REPORT' put: 6;
at: 'SERVO_UNAVAILABLE' put: 7;
at: 'I2C_TOO_FEW_BYTES_RCVD' put: 8;
at: 'I2C_TOO_MANY_BYTES_RCVD' put: 9;
at: 'I2C_READ_REPORT' put: 10;
at: 'SONAR_DISTANCE' put: 11;
at: 'DHT_REPORT' put: 12;
at: 'SPI_REPORT' put: 13;
at: 'ONE_WIRE_REPORT' put: 14;
at: 'STEPPER_DISTANCE_TO_GO' put: 15;
at: 'STEPPER_TARGET_POSITION' put: 16;
at: 'STEPPER_CURRENT_POSITION' put: 17;
at: 'STEPPER_RUNNING_REPORT' put: 18;
at: 'STEPPER_RUN_COMPLETE_REPORT' put: 19;
at: 'FEATURES' put: 20;
at: 'DEBUG_PRINT' put: 99;
at: 'TELEMETRIX_VERSION' put: '1.46';
at: 'REPORTING_DISABLE_ALL' put: 0;
at: 'REPORTING_ANALOG_ENABLE' put: 1;
at: 'REPORTING_DIGITAL_ENABLE' put: 2;
at: 'REPORTING_ANALOG_DISABLE' put: 3;
at: 'REPORTING_DIGITAL_DISABLE' put: 4;
at: 'AT_INPUT' put: 0;
at: 'AT_OUTPUT' put: 1;
at: 'AT_INPUT_PULLUP' put: 2;
at: 'AT_ANALOG' put: 3;
at: 'AT_SERVO' put: 4;
at: 'AT_SONAR' put: 5;
at: 'AT_DHT' put: 6;
at: 'AT_MODE_NOT_SET' put: 255;
at: 'MAX_SONARS' put: 6;
at: 'MAX_DHTS' put: 6;
at: 'DHT_ERROR' put: 1;
at: 'ONEWIRE_FEATURE' put: 016r01;
at: 'DHT_FEATURE' put: 16r02;
at: 'STEPPERS_FEATURE' put: 16r04;
at: 'SPI_FEATURE' put: 16r08;
at: 'SERVO_FEATURE' put: 1610;
at: 'SONAR_FEATURE' put: 16r20.

]

{ #category : 'initialization' }
TMXUnoDriver >> initialize [ 
	super initialize.
	self initConstantsDict 
]
