Class {
	#name : 'TMXDHTEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'type',
		'pinNr',
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
TMXDHTEvent >> pinNr [

	^ pinNr
]

{ #category : 'accessing' }
TMXDHTEvent >> pinNr: anObject [

	pinNr := anObject
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
