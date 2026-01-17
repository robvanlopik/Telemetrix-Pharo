"
I represent the result of an analog input event.
my message code is ANALOG_?REPORT
I contain the pin number pinNr and the value read: pinValue
"
Class {
	#name : 'TMXAnalogInputEvent',
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
