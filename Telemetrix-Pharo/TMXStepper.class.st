"
I represent a single stepper motor. I am an ojectification like I2CConnection.
I am created by a command to the driver #....
This returns my #id.
All further stepper methods are implemented by me.

"
Class {
	#name : 'TMXStepper',
	#superclass : 'Object',
	#instVars : [
		'id',
		'driver',
		'isRunning',
		'maxSpeed',
		'speed',
		'acceleration',
		'targetPosition',
		'currentPosition',
		'runCompleted',
		'running',
		'distanceToGo'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXStepper >> acceleration [

	^ acceleration
]

{ #category : 'accessing' }
TMXStepper >> acceleration1: anObject [

	acceleration := anObject
]

{ #category : 'accessing' }
TMXStepper >> acceleration: anInt [
	"sets the acceleration in the stepper and in the instance. 1-1000"
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_SET_ACCELERATION') with: id 
								with: (anInt bitAnd: 16rFF00) >> 8 with: (anInt bitAnd: 16rFF).
	driver sendCommand: command.

	acceleration := anInt
]

{ #category : 'accessing' }
TMXStepper >> currentPosition [

	^ currentPosition
]

{ #category : 'accessing' }
TMXStepper >> currentPosition: anObject [

	currentPosition := anObject
]

{ #category : 'operations' }
TMXStepper >> disableOutputs [
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_DISABLE_OUTPUTS') with: id.
	driver sendCommand: command
]

{ #category : 'accessing' }
TMXStepper >> distanceToGo [
	"synchronous getter"
	
	| requestTime retries|
	requestTime := DateAndTime now.
	self getDistanceToGo.
	retries := 10.
	[ retries > 10] whileTrue: [  | event |
			event := driver steppers at: id.
			(event timestamp > requestTime) ifTrue: [ ^event  distanceToGo ].
			 retries := retries - 1.].
	"no response?"
	Error signal: 'Timeout waiting for distancetoGo'	
	
]

{ #category : 'accessing' }
TMXStepper >> distanceToGo: anObject [

	distanceToGo := anObject
]

{ #category : 'accessing' }
TMXStepper >> driver [

	^ driver
]

{ #category : 'accessing' }
TMXStepper >> driver: anObject [

	driver := anObject
]

{ #category : 'operations' }
TMXStepper >> enableOutputs [
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_ENABLE_OUTPUTS') with: id.
	driver sendCommand: command
]

{ #category : 'enquiries' }
TMXStepper >> getCurrentPosition [

	" generates announcement "
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_GET_CURRENT_POSITION') with: id.
	driver sendCommand: command
]

{ #category : 'enquiries' }
TMXStepper >> getDistanceToGo [

	" generates announcement "
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_GET_DISTANCE_TO_GO') with: id.
	driver sendCommand: command
]

{ #category : 'enquiries' }
TMXStepper >> getTargetPosition [
	"Request the most recently set target position from the server."
	"callback/announcement: TMXStepperTargetPosition"

	| command |
	command := ByteArray with: (driver idFrom: 'STEPER_GET_TARGET_POSITION') with: id.
	driver sendCommand: command
]

{ #category : 'accessing' }
TMXStepper >> id [

	^ id
]

{ #category : 'accessing' }
TMXStepper >> id: anObject [

	id := anObject
]

{ #category : 'initialization' }
TMXStepper >> initialize [

	super initialize.
	isRunning := false.
	maxSpeed := 1.
	speed := 0.
	acceleration := 0.
	
	
]

{ #category : 'accessing' }
TMXStepper >> isRunning [

	^ isRunning
]

{ #category : 'accessing' }
TMXStepper >> isRunning: anObject [

	isRunning := anObject
]

{ #category : 'accessing' }
TMXStepper >> maxSpeed [

	^ maxSpeed
]

{ #category : 'accessing' }
TMXStepper >> maxSpeed1: anObject [

	maxSpeed := anObject
]

{ #category : 'accessing' }
TMXStepper >> maxSpeed: a16bitInt [
	"Sets the maximum permitted speed. The stepper_run() function will accelerate
        up to the speed set by this function. Caution: the maximum speed achievable depends on your processor and clock speed.The default maxSpeed is 1 step per second. speed = 1-1000.
         Caution: Speeds that exceed the maximum speed supported by the processor may
                  result in non-linear accelerations and decelerations."
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_RUN') with: id 
								with: (a16bitInt bitAnd: 16rFF00) >> 8 with: (a16bitInt bitAnd: 16rFF).
	driver sendCommand: command.
	"and register in the instance"
	maxSpeed:= a16bitInt
]

{ #category : 'operations' }
TMXStepper >> run [
	"This method steps the selected motor based on the current speed.
        Once called, the server will continuously attempt to step the motor."
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_RUN') with: id.
	driver sendCommand: command
]

{ #category : 'operations' }
TMXStepper >> runAtMaxSpeed [
	"This method steps the selected motor based on the max  speed set by #maxSpeed:.
        Once called, the server will continuously attempt to step the motor."
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_RUN_SPEED') with: id.
	driver sendCommand: command
]

{ #category : 'accessing' }
TMXStepper >> runCompleted [

	^ runCompleted
]

{ #category : 'accessing' }
TMXStepper >> runCompleted: anObject [

	runCompleted := anObject
]

{ #category : 'accessing' }
TMXStepper >> running [

	^ running
]

{ #category : 'accessing' }
TMXStepper >> running: anObject [

	running := anObject
]

{ #category : 'accessing' }
TMXStepper >> speed [

	^ speed
]

{ #category : 'accessing' }
TMXStepper >> speed: anObject [

	speed := anObject
]

{ #category : 'accessing' }
TMXStepper >> targetPosition [

	^ targetPosition
]

{ #category : 'accessing' }
TMXStepper >> targetPosition: anObject [

	targetPosition := anObject
]
