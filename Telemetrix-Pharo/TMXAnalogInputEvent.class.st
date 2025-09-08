Class {
	#name : 'TMXAnalogInputEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'pinNr',
		'pinValue'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXAnalogInputEvent >> pinNr [

	^ pinNr
]

{ #category : 'accessing' }
TMXAnalogInputEvent >> pinNr: anObject [

	pinNr := anObject
]

{ #category : 'accessing' }
TMXAnalogInputEvent >> pinValue [

	^ pinValue
]

{ #category : 'accessing' }
TMXAnalogInputEvent >> pinValue: anObject [

	pinValue := anObject
]
