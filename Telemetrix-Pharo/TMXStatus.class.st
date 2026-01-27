"
I hold status information of a specific driver instance
An instance of myself belongs in the driver instance.
Main purpose: declutter list of instance varfs of TMXDriver
"
Class {
	#name : 'TMXStatus',
	#superclass : 'Object',
	#instVars : [
		'i2cActivated',
		'spiEnabled',
		'csPins',
		'onewireEnabled',
		'sonarCount',
		'dhtCount',
		'nextStepperAssigned',
		'stepperCount'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'accessing' }
TMXStatus >> csPins [

	^ csPins
]

{ #category : 'accessing' }
TMXStatus >> csPins: anObject [

	csPins := anObject
]

{ #category : 'accessing' }
TMXStatus >> dhtCount [

	^ dhtCount
]

{ #category : 'accessing' }
TMXStatus >> dhtCount: anObject [

	dhtCount := anObject
]

{ #category : 'accessing' }
TMXStatus >> i2cActivated [

	^ i2cActivated
]

{ #category : 'accessing' }
TMXStatus >> i2cActivated: anObject [

	i2cActivated := anObject
]

{ #category : 'initialization' }
TMXStatus >> initialize [
	
	super initialize.
	i2cActivated := false.
	spiEnabled := false.
	csPins := OrderedCollection new.
	onewireEnabled := false.
	sonarCount := 0.
	dhtCount := 0.
	nextStepperAssigned := 0.
	stepperCount := 0
]

{ #category : 'accessing' }
TMXStatus >> nextStepperAssigned [

	^ nextStepperAssigned
]

{ #category : 'accessing' }
TMXStatus >> nextStepperAssigned: anObject [

	nextStepperAssigned := anObject
]

{ #category : 'accessing' }
TMXStatus >> onewireEnabled [

	^ onewireEnabled
]

{ #category : 'accessing' }
TMXStatus >> onewireEnabled: anObject [

	onewireEnabled := anObject
]

{ #category : 'accessing' }
TMXStatus >> sonarCount [

	^ sonarCount
]

{ #category : 'accessing' }
TMXStatus >> sonarCount: anObject [

	sonarCount := anObject
]

{ #category : 'accessing' }
TMXStatus >> spiEnabled [

	^ spiEnabled
]

{ #category : 'accessing' }
TMXStatus >> spiEnabled: anObject [

	spiEnabled := anObject
]

{ #category : 'accessing' }
TMXStatus >> stepperCount [

	^ stepperCount
]

{ #category : 'accessing' }
TMXStatus >> stepperCount: anObject [

	stepperCount := anObject
]
