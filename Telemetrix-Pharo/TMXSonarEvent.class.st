"
I am created when a message with id SONAR_REPORT arrives. I calculated the distance (in cm) from the high en low oatder bytes in the message.
"
Class {
	#name : 'TMXSonarEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'pinNr',
		'distance'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'accessing' }
TMXSonarEvent >> distance [

	^ distance
]

{ #category : 'accessing' }
TMXSonarEvent >> distance: anObject [

	distance := anObject
]

{ #category : 'accessing' }
TMXSonarEvent >> pinNr [

	^ pinNr
]

{ #category : 'accessing' }
TMXSonarEvent >> pinNr: anObject [

	pinNr := anObject
]
