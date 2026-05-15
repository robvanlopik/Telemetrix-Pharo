"
I represent a single stepper motor. I am an objectification like I2CConnection.
I am created by a command to the driver #....
This returns my #id.
All further stepper methods are implemented by me and passed on to the driver.

I keep track of some parameters like speed and maxSpeed.
Other parameeteres, like position are reqested from the deevice but cached locally and can also be reqested sybchrobnously (1.e. waiting for the callback answer)
Worth noting about #speed and #maxSpeed:
speed goes with runToSpeed and does not use accelaration. It cannot exceed maxSpeed
maxSpeed is used for accelerated moves. It may not be reached if the stepper has do decelarate already.

stepper types:
1 = Stepper Driver, 2 driver pins required
2 = FULL2WIRE  2 wire stepper, 2 motor pins required
3 = FULL3WIRE 3 wire stepper, such as HDD spindle, 3 motor pins required
4 = FULL4WIRE, 4 wire full stepper, 4 motor pins required
6 = HALF3WIRE, 3 wire half stepper, such as HDD spindle,3 motor pins required
8 = HALF4WIRE, 4 wire half stepper, 4 motor pins required
"
Class {
	#name : 'TMXStepper',
	#superclass : 'Object',
	#instVars : [
		'id',
		'driver',
		'activated',
		'isRunningCB',
		'maxSpeed',
		'speed',
		'acceleration',
		'targetPositionCB',
		'currentPositionCB',
		'runCompletedCB',
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
TMXStepper >> activated [
	^activated
]

{ #category : 'accessing' }
TMXStepper >> activated: aBool [
	activated := aBool
]

{ #category : 'accessing' }
TMXStepper >> currentPosition [
	"synchronous answer"
	| timestampStart |
	timestampStart := DateAndTime now.
	self getCurrentPosition.
	10 timesRepeat: [ (currentPositionCB timestamp > timestampStart) ifTrue: [ ^currentPositionCB position].
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
	10 timesRepeat:  [ (distanceToGoCB timestamp > requestTime ) ifTrue: [  ^distanceToGoCB distance].
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

{ #category : 'as yet unclassified' }
TMXStepper >> getMaxSpeed [
	^maxSpeed
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
	
	maxSpeed := 1.
	speed := 0.
	acceleration := 0.
	"the callbacks/announcemenets"
	isRunningCB := TMXStepperRunningReport new timestamp: DateAndTime now.
	targetPositionCB := TMXStepperTargetPosition new timestamp: DateAndTime now.
	currentPositionCB := TMXStepperCurrentPosition new timestamp: DateAndTime now.
	distanceToGoCB := TMXStepperDistanceToGo new timestamp: DateAndTime now.
	
]

{ #category : 'accessing' }
TMXStepper >> isRunning [
	"synchronous answer"
	| timestampStart |
	timestampStart := DateAndTime now.
	self isRunningEnquiry.
	10 timesRepeat: [ (isRunningCB timestamp > timestampStart) ifTrue: [ ^isRunningCB isRunnning ].
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
	command := ByteArray with: (driver idFrom: 'STEPPER_IS_RUNNING') with: id.
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
TMXStepper >> moveRelative: aDistance [
	"set new target relative to current position. STEPPER_MOVE. Only sets tartget"
	| command polarity|
	polarity := 0. "means positive"
	aDistance < 0 ifTrue: [ polarity := 1 ].
	command := ByteArray new: 7.
	command at: 1 put: (driver idFrom: 'STEPPER_MOVE').
	command at: 2 put: id.
	command longAt: 3 put: aDistance abs bigEndian: true.
	command at: 7 put: polarity.
	driver sendCommand: command
	
	
]

{ #category : 'path commands' }
TMXStepper >> moveTo: aPosition [
	"mover to an absolute position. STEPPER_NOVE_TO. Only sets target; #run will actially move it"
	| command polarity |
	polarity := 0.
	aPosition < 0 ifTrue: [ polarity := 1 ].
	command := ByteArray new: 7.
	command at: 1 put: (driver idFrom: 'STEPPER_MOVE_TO').
	command at: 2 put: id.
	command longAt: 3 put: aPosition abs bigEndian: true.
	command at: 7 put: polarity.
	driver sendCommand: command
	
	
]

{ #category : 'operations' }
TMXStepper >> run [
	"This method steps the selected motor based on the current speed.
    Once called, the server will continuously attempt to step the motor.
	Completion is signalled by an announcement TMXStepperRunCompleteReport"
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

{ #category : 'operations' }
TMXStepper >> runAtSpeedToPosition [

	" Runs the motor at the currently selected speed until the target position is
        reached.         Does not implement accelerations. Generates
		generates StepperRunCompleteReport . Target position must be set first"
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_RUN_SPEED') with: id.
	driver sendCommand: command
]

{ #category : 'accessing' }
TMXStepper >> runCompleted [

	^ runCompleted
]

{ #category : 'accessing' }
TMXStepper >> runCompletedCB: anObject [

	runCompletedCB := anObject
]

{ #category : 'as yet unclassified' }
TMXStepper >> runCompletedEnquiry [
	"is the motor running - STEPPER_
	"
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_IS_RUNNING') with: id.
	driver sendCommand: command
	
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
TMXStepper >> setAcceleration: anInt [
	"sets the acceleration in the stepper and in the instance. 1-1000"
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_SET_ACCELERATION') with: id 
								with: (anInt bitAnd: 16rFF00) >> 8 with: (anInt bitAnd: 16rFF).
	driver sendCommand: command.

	acceleration := anInt
]

{ #category : 'initialization' }
TMXStepper >> setCurrentPosition: aPosition [
	"Resets the current position of the motor, so that wherever the motor
        happens to be right now is considered to be the new 0 position. Useful
        for setting a zero position on a stepper after an initial hardware
        positioning move. Has the side effect of setting the current motor speed to 0."
	| command |
	
	command := ByteArray new: 6.
	command at: 1 put: (driver idFrom: 'STEPPER_SET_CURRENT_POSITION'). 
	command at: 2 put: id.
	command longAt: 3 put: aPosition bigEndian: true.
	driver sendCommand: command
]

{ #category : 'accessing' }
TMXStepper >> setMaxSpeed: a16bitInt [
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

{ #category : 'initialization' }
TMXStepper >> setSpeed: anInt [
	"Sets the desired constant speed for use with stepperrunAtMaxSpeed()"
	
	| command |
	command := ByteArray new: 4.
	command at: 1 put: (driver idFrom: 'STEPPER_SET_SPEED').
	command at: 2 put: id.
	command at: 3 put: (anInt bitAnd: 16rFF00) >> 8.
	command at: 4 put: (anInt bitAnd: 16rFF).
	driver sendCommand: command.
	speed := anInt.
	
]

{ #category : 'accessing' }
TMXStepper >> speed [

	^ speed
]

{ #category : 'accessing' }
TMXStepper >> stop [
	"Sets a new target position that causes the stepper
        to stop as quickly as possible, using the current speed and
        acceleration parameters."
	| command |
	command := ByteArray with: (driver idFrom: 'STEPPER_STOP') with: id.
	driver sendCommand: command
]

{ #category : 'accessing' }
TMXStepper >> targetPosition [

		| timestampStart |
	timestampStart := DateAndTime now.
	self getTargetPosition.
	10 timesRepeat: [ (targetPositionCB timestamp > timestampStart) ifTrue: [ ^targetPositionCB position].
						20 milliSeconds wait].
	self notify: 'Get target position timed out'.
]

{ #category : 'accessing' }
TMXStepper >> targetPositionCB: anAnnouncement [
	targetPositionCB := anAnnouncement
]
