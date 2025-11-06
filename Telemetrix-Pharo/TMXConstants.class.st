"
I am a helper class that contains useful constants and tests for the TMX driver
"
Class {
	#name : 'TMXConstants',
	#superclass : 'Object',
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'as yet unclassified' }
TMXConstants class >> gpioFromPinNr: pinNr [
	"get the GPIO nuber from the digital pin nr"
	| array result |
	
	array := {2 . 25 . 3 . 15 . 4 . 16 . 5 . 17 . 6 . 18 . 7 . 19 . 8 . 20 . 9 . 21 . 10 . 5 . 11 . 7 . 12 . 4 . 13 . 6 . 14 . 26 . 15 . 27 . 16 . 28 . 17 . 29}.
	result := -1.
	array withIndexDo: [ :x :i | (i odd) & (x = pinNr) ifTrue: [ result := array at: (i + 1 )]].
	^result
]

{ #category : 'as yet unclassified' }
TMXConstants class >> i2cSCL [
	^19
]

{ #category : 'as yet unclassified' }
TMXConstants class >> i2cSDA [
	^18
]

{ #category : 'testing' }
TMXConstants class >> isAnalogInput: pinNr [
	^(0 to: 4) includes: pinNr
]

{ #category : 'testing' }
TMXConstants class >> isDigitalInput: pinNr [
	"0-17, 20 and 21"
	
	^((0 to: 17) includes: pinNr) | ((#(20 21) includes: pinNr))
]

{ #category : 'testing' }
TMXConstants class >> isDigitalOutput: pinNr [
	"0-17 and rgbRed=27,rgbGreen=25, rgbBlue=26 "
	
	^((0 to: 17) includes: pinNr) | ((#(25 26 27) includes: pinNr))
]

{ #category : 'accessing' }
TMXConstants class >> maxDHTs [
	^2
]

{ #category : 'accessing' }
TMXConstants class >> maxSonars [
	^6
]

{ #category : 'as yet unclassified' }
TMXConstants class >> pinFromGpio: gpioNr [
	"get the GPIO nuber from the digital pin nr"
	| array result |
	
	array := {2 . 25 . 3 . 15 . 4 . 16 . 5 . 17 . 6 . 18 . 7 . 19 . 8 . 20 . 9 . 21 . 10 . 5 . 11 . 7 . 12 . 4 . 13 . 6 . 14 . 26 . 15 . 27 . 16 . 28 . 17 . 29}.
	result := -1.
	array withIndexDo: [ :x :i | (i even) & (x = gpioNr) ifTrue: [ result := array at: (i - 1 )]].
	^result
]

{ #category : 'as yet unclassified' }
TMXConstants class >> rgbBlue [
	"pseudo pin RGB Blue"
	^26
]

{ #category : 'as yet unclassified' }
TMXConstants class >> rgbGreen [
	"pseudo pin RGB Green"
	^25
]

{ #category : 'as yet unclassified' }
TMXConstants class >> rgbRed [
	"pseudo pin RGB Red"
	^27
]
