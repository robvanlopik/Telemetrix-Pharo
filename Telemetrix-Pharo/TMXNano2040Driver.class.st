"
I am a driver for the Telemetrix Arduino Nao 2040 Connect firmware
"
Class {
	#name : 'TMXNano2040Driver',
	#superclass : 'TMXIPDriver',
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'initialization' }
TMXNano2040Driver >> initConstantsDict [

		"device specifc data and constants Nano2040"
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
		at: 'SERVO_ATTACH' put: 7;
		at: 'SERVO_WRITE' put: 8;
		at: 'SERVO_DETACH' put: 9;
		at: 'I2C_BEGIN' put: 10;
		at: 'I2C_READ' put: 11;
		at: 'I2C_WRITE' put: 12;
		at: 'SONAR_NEW' put: 13;
		at: 'DHT_NEW' put: 31;
		at: 'RGB_WRITE' put: 14;
		at: 'STOP_ALL_REPORTS' put: 15;
		at: 'SET_ANALOG_SCANNING_INTERVAL' put: 16;
		at: 'ENABLE_ALL_REPORTS' put: 17;	
		"at: 'ANALOG_OUT_ATTACH' put: 17;
		at: 'ANALOG_OUT_DETACH' put: 18;
		at: 'DAC_WRITE' put: 19;"
		at: 'RESET' put: 18;
		"at: 'DAC_DISABLE' put: 21;"
		at: 'IMU_ENABLE' put: 19;
		at: 'MICROPHONE_ENABLE' put: 20;
		at: 'INITIALIZE_NEO_PIXELS' put: 24;
		at: 'SHOW_NEO_PIXELS' put: 22;
		at: 'SET_NEO_PIXEL' put: 23;
		at: 'CLEAR_ALL_NEO_PIXELS' put: 24;
		at: 'FILL_ALL_NEO_PIXELS' put: 25;
		at: 'SPI_INIT' put: 26;
		at: 'SPI_WRITE_BLOCKING' put: 27;
		at: 'SPI_READ_BLOCKING' put: 28;
		at: 'SPI_SET_FORMAT' put: 29;
		at: 'SPI_CS_CONTROL' put: 26;
		at: 'ONE_WIRE_INIT' put: 30;
		"at: 'ONE_WIRE_RESET' put: 28;
		at: 'ONE_WIRE_SELECT' put: 29;
		at: 'ONE_WIRE_SKIP' put: 30;
		at: 'ONE_WIRE_WRITE' put: 31;
		at: 'ONE_WIRE_READ' put: 32;
		at: 'ONE_WIRE_RESET_SEARCH' put: 33;
		at: 'ONE_WIRE_SEARCH' put: 34;
		at: 'ONE_WIRE_CRC8' put: 35;"
		"at: 'SET_PIN_MODE_STEPPER' put: 36;
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
		at: 'STEPPER_GET_TARGET_POSITION' put: 56;"
	"	at: 'GET_FEATURES' put: 54;
		at: 'SONAR_DISABLE' put: 55;
		at: 'SONAR_ENABLE' put: 56;  "
	"reports"
		at: 'DIGITAL_REPORT' put: 2;
		at: 'ANALOG_REPORT' put: 3;
		at: 'FIRMWARE_REPORT' put: 5;
"		at: 'I_AM_HERE_REPORT' put: 6; "
		at: 'SERVO_UNAVAILABLE' put: 7;
		at: 'I2C_TOO_FEW_BYTES_RCVD' put: 8;
		at: 'I2C_TOO_MANY_BYTES_RCVD' put: 9;
		at: 'I2C_READ_REPORT' put: 10;
		at: 'SONAR_DISTANCE' put: 11;
		at: 'IMU_REPORT' put: 12;
		at: 'MICROPHONE_REPORT' put: 13;
		at: 'DHT_REPORT' put: 14;
		"at: 'TOUCH_Report' put: 12;"
		at: 'SPI_REPORT' put: 15;
		at: 'ONE_WIRE_REPORT' put: 14;
		at: 'STEPPER_DISTANCE_TO_GO' put: 15;
		at: 'STEPPER_TARGET_POSITION' put: 16;
		at: 'STEPPER_CURRENT_POSITION' put: 17;
		at: 'STEPPER_RUNNING_REPORT' put: 18;
		at: 'STEPPER_RUN_COMPLETE_REPORT' put: 19;
		at: 'FEATURES' put: 20;
		at: 'DEBUG_PRINT' put: 99;
		at: 'TELEMETRIX_ESP#@_VERSION' put: '12.0.0';
	"reporting control"
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
		at: 'AT_RGB' put: 6;
		at: 'AT_MICROPHONE_MONO' put: 7;
		at: 'AT_MICROPHONE_STEREO' put: 8;
		at: 'AT_IMU' put: 9;
		at: 'AT_NEO_PIXEL' put: 10;
		at: 'AT_MODE_NOT_SET' put: 255;

		at: 'MAX_SONARS' put: 6;
		at: 'MAX_DHTS' put: 2;
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
