Class {
	#name : 'TMXDHTEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'type',
		'piNr',
		'humidity',
		'temperature'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'accessing' }
TMXDHTEvent >> humidity [

	^ humidity
]

{ #category : 'accessing' }
TMXDHTEvent >> humidity: anObject [

	humidity := anObject
]

{ #category : 'accessing' }
TMXDHTEvent >> piNr [

	^ piNr
]

{ #category : 'accessing' }
TMXDHTEvent >> piNr: anObject [

	piNr := anObject
]

{ #category : 'accessing' }
TMXDHTEvent >> temperature [

	^ temperature
]

{ #category : 'accessing' }
TMXDHTEvent >> temperature: anObject [

	temperature := anObject
]

{ #category : 'accessing' }
TMXDHTEvent >> type [

	^ type
]

{ #category : 'accessing' }
TMXDHTEvent >> type: anObject [

	type := anObject
]
