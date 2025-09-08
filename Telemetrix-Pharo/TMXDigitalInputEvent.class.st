Class {
	#name : 'TMXDigitalInputEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'pinNr',
		'pinValue'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXDigitalInputEvent >> pinNr [

	^ pinNr
]

{ #category : 'accessing' }
TMXDigitalInputEvent >> pinNr: anObject [

	pinNr := anObject
]

{ #category : 'accessing' }
TMXDigitalInputEvent >> pinValue [

	^ pinValue
]

{ #category : 'accessing' }
TMXDigitalInputEvent >> pinValue: anObject [

	pinValue := anObject
]
