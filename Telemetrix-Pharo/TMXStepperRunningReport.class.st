"
I am emitted as a response to #isRunningEnquiry
Also synchronous: #isRunning
"
Class {
	#name : 'TMXStepperRunningReport',
	#superclass : 'TMXStepperEvent',
	#instVars : [
		'isRunning'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'accessing' }
TMXStepperRunningReport >> isRunning [

	^ isRunning
]

{ #category : 'accessing' }
TMXStepperRunningReport >> isRunning: anObject [

	isRunning := anObject
]
