"
I am emitted following #getTargetPosition.
Also synchronous with #targetPosition
"
Class {
	#name : 'TMXStepperTargetPosition',
	#superclass : 'TMXStepperEvent',
	#instVars : [
		'targetPosition'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'accessing' }
TMXStepperTargetPosition >> targetPosition [

	^ targetPosition
]

{ #category : 'accessing' }
TMXStepperTargetPosition >> targetPosition: anObject [

	targetPosition := anObject
]
