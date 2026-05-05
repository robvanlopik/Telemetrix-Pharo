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
		'isRunningCB',
		'maxSpeed',
		'speed',
		'acceleration',
		'targetPositionCB',
		'currentPositionCB',
		'runCompleted',
		'running',
		'distanceToGoCB'
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
	"synchronous answer"
	| timestampStart |
	timestampStart := DateAndTime now.
	self getCurrentPosition.
	1 to: 10 do: [ (currentPositionCB timestamp > timestampStart) ifTrue: [ ^currentPositionCB position].
						20 milliSeconds wait].
	self notify: 'Get current position timed out'.
]

{ #category : 'accessing' }
TMXStepper >> currentPositionCB: aValue [
	currentPositionCB := aValue
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
	
	| requestTime|
	requestTime := DateAndTime now.
	self getDistanceToGo.
	1 to: 10 do:  [ (distanceToGoCB timestamp > requestTime ) ifTrue: [  ^distanceToGoCB distance].
							20 milliSeconds wait ].
			
	Error signal: 'Timeout waiting for distancetoGo'	
	
]

{ #category : 'accessing' }
TMXStepper >> distanceToGoCB: anAnnouncement [

	distanceToGoCB := anAnnouncement 

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
	"synchronous answer"
	| timestampStart |
	timestampStart := DateAndTime now.
	self isRunningEnquiry.
	1 to: 10 do: [ (isRunningCB timestamp > timestampStart) ifTrue: [ ^isRunningCB isRunnning ].
						20 milliSeconds wait].
	self notify: 'Get running report timed out'.
]

{ #category : 'accessing' }
TMXStepper >> isRunningCB: anObject [

	isRunningCB := anObject
]

{ #category : 'enquiries' }
TMXStepper >> isRunningEnquiry [
	"is the motor running - STEPPER_IS_RUNNING
	"
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_GIS_RUNNING') with: id.
	driver sendCommand: command
	
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

		| timestampStart |
	timestampStart := DateAndTime now.
	self getTargetPosition.
	1 to: 10 do: [ (targetPositionCB timestamp > timestampStart) ifTrue: [ ^targetPositionCB position].
						20 milliSeconds wait].
	self notify: 'Get target position timed out'.
]

{ #category : 'accessing' }
TMXStepper >> targetPositionCB: anAnnouncement [
	targetPositionCB := anAnnouncement
]
