Class {
	#name : 'TMXStepperRunningReport',
	#superclass : 'TMXStepperEvent',
	#instVars : [
		'isRunning'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXStepperRunningReport >> isRunning [

	^ isRunning
]

{ #category : 'accessing' }
TMXStepperRunningReport >> isRunning: anObject [

	isRunning := anObject
]
