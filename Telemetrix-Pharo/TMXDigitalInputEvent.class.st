"
I represent the result of an digital input event.
my message code is DIGITAL_?REPORT
I contain the pin number pinNr and the value read: pinValue
"
Class {
	#name : 'TMXDigitalInputEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'pinNr',
		'pinValue'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
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
