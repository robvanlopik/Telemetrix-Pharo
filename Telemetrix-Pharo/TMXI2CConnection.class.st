Class {
	#name : 'TMXI2CConnection',
	#superclass : 'Object',
	#instVars : [
		'i2cAddress',
		'driver'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXI2CConnection >> driver [

	^ driver
]

{ #category : 'accessing' }
TMXI2CConnection >> driver: anObject [

	driver := anObject
]

{ #category : 'accessing' }
TMXI2CConnection >> i2cAddress [

	^ i2cAddress
]

{ #category : 'accessing' }
TMXI2CConnection >> i2cAddress: anObject [

	i2cAddress := anObject
]

{ #category : 'accessing' }
TMXI2CConnection >> readByteAt: register [

	| requestTime |
	requestTime := DateAndTime now.
	driver i2cReadFromAdress: i2cAddress register: register count: 1.
	1 to: 5 do: [  :ann | | event |
		event := driver i2cData at: i2cAddress.
		(event timestamp > requestTime) & (event register = register ) ifTrue: [ ^event bytes  ] ]
]

{ #category : 'accessing' }
TMXI2CConnection >> writeByteAt: register data: aByte [

	driver i2cReadFromAdress: i2cAddress register: register count: 1
]
