Class {
	#name : 'TMXStepperTargetPosition',
	#superclass : 'TMXStepperEvent',
	#instVars : [
		'targetPosition'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXStepperTargetPosition >> targetPosition [

	^ targetPosition
]

{ #category : 'accessing' }
TMXStepperTargetPosition >> targetPosition: anObject [

	targetPosition := anObject
]
