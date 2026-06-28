"
I am the response to TMXStepper>>getDistanceToGo
The ivar #distanceToGo is 32 bits
"
Class {
	#name : 'TMXStepperDistanceToGo',
	#superclass : 'TMXStepperEvent',
	#instVars : [
		'distanceToGo'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'accessing' }
TMXStepperDistanceToGo >> distanceToGo [

	^ distanceToGo
]

{ #category : 'accessing' }
TMXStepperDistanceToGo >> distanceToGo: anObject [

	distanceToGo := anObject
]
