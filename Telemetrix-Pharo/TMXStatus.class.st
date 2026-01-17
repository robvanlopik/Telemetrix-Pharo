"
I hold status information of a specific driver instance
An instance of myself belongs in the driver instance.
Main purpose: declutter list of instance varfs of TMXDriver
"
Class {
	#name : 'TMXStatus',
	#superclass : 'Object',
	#instVars : [
		'i2cActive',
		'spiEnabled',
		'csPins'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'initialization' }
TMXStatus >> initialize [
	
	super initialize.
	i2cActive := false.
	spiEnabled := false.
	
]
