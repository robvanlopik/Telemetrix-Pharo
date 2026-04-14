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
		'acceleration'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXStepper >> acceleration [

	^ acceleration
]

{ #category : 'accessing' }
TMXStepper >> acceleration: anObject [

	acceleration := anObject
]

{ #category : 'accessing' }
TMXStepper >> driver [

	^ driver
]

{ #category : 'accessing' }
TMXStepper >> driver: anObject [

	driver := anObject
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
TMXStepper >> maxSpeed: anObject [

	maxSpeed := anObject
]

{ #category : 'accessing' }
TMXStepper >> speed [

	^ speed
]

{ #category : 'accessing' }
TMXStepper >> speed: anObject [

	speed := anObject
]
