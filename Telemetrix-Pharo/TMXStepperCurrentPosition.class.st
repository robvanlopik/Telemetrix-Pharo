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
