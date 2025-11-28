Class {
	#name : 'TMXESP32Driver',
	#superclass : 'TMXDriver',
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
TMXESP32Driver >> initConstantsDict [
	"device specifc data and constaints"
	constantsDict 
		at: 'DIPins' put: #(4 5 12 13 14 16 17 18 19 21 22 23 25 26 27 32 33);
		at: 'DOPins' put: #(2 4 5 12 13 14 16 17 18 19 21 22 23 25 26 27 32 33);
		at: 'TouchPins' put: #(4 12 13 14 15 27 32 33);
		at: 'AIPins' put: #(32 33 34 35 36 39);
		at: 'ServoPins' put: #(4 5 12 13 14 16 17 18 19 21 22 23 25 26 27 32 33). 
]

{ #category : 'initialization' }
TMXESP32Driver >> initialize [

	super initialize.
	self initConstantsDict.
]
