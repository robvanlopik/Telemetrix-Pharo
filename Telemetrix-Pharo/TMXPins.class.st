"
My instance vars contain lists of the various allowed  pins per function
"
Class {
	#name : 'TMXPins',
	#superclass : 'Object',
	#instVars : [
		'di',
		'do',
		'ai',
		'ao',
		'dht',
		'sonar',
		'pwm',
		'servo',
		'cs'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXPins >> ai [

	^ ai
]

{ #category : 'accessing' }
TMXPins >> ai: anObject [

	ai := anObject
]

{ #category : 'accessing' }
TMXPins >> ao [

	^ ao
]

{ #category : 'accessing' }
TMXPins >> ao: anObject [

	ao := anObject
]

{ #category : 'accessing' }
TMXPins >> cs [

	^ cs
]

{ #category : 'accessing' }
TMXPins >> cs: anObject [

	cs := anObject
]

{ #category : 'accessing' }
TMXPins >> dht [

	^ dht
]

{ #category : 'accessing' }
TMXPins >> dht: anObject [

	dht := anObject
]

{ #category : 'accessing' }
TMXPins >> di [

	^ di
]

{ #category : 'accessing' }
TMXPins >> di: anObject [

	di := anObject
]

{ #category : 'accessing' }
TMXPins >> do [

	^ do
]

{ #category : 'accessing' }
TMXPins >> do: anObject [

	do := anObject
]

{ #category : 'accessing' }
TMXPins >> pwm [

	^ pwm
]

{ #category : 'accessing' }
TMXPins >> pwm: anObject [

	pwm := anObject
]

{ #category : 'accessing' }
TMXPins >> servo [

	^ servo
]

{ #category : 'accessing' }
TMXPins >> servo: anObject [

	servo := anObject
]

{ #category : 'accessing' }
TMXPins >> sonar [

	^ sonar
]

{ #category : 'accessing' }
TMXPins >> sonar: anObject [

	sonar := anObject
]
