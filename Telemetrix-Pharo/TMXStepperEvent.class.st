"
I am the superclass of all stepper events
"
Class {
	#name : 'TMXStepperEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'id'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'accessing' }
TMXStepperEvent >> id [

	^ id
]

{ #category : 'accessing' }
TMXStepperEvent >> id: anObject [

	id := anObject
]
