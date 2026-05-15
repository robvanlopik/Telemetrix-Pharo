"
I am the superclass of all stepper events
"
Class {
	#name : 'TMXStepperEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'id'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXStepperEvent >> id [

	^ id
]

{ #category : 'accessing' }
TMXStepperEvent >> id: anObject [

	id := anObject
]
