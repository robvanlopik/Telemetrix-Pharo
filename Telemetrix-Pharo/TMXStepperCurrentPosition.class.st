"
I represent the response to TMXStepper>>getCurrentPosition
The ivar #position is a 32 bits value
"
Class {
	#name : 'TMXStepperCurrentPosition',
	#superclass : 'TMXStepperEvent',
	#instVars : [
		'position'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXStepperCurrentPosition >> position [

	^ position
]

{ #category : 'accessing' }
TMXStepperCurrentPosition >> position: anObject [

	position := anObject
]
