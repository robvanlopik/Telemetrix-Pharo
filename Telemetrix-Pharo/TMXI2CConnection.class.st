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
TMXI2CConnection >> address: anAddress [
	self i2cAddress: anAddress
]

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
TMXI2CConnection >> read8BitsAt: anInteger [ 
	^self readByteAt: anInteger
]

{ #category : 'accessing' }
TMXI2CConnection >> readByteAt: register [

	| requestTime |
	requestTime := DateAndTime now.
	driver i2cReadFromAdress: i2cAddress register: register count: 1. 
	1 to: 50 do: [  :ann | | event |
		event := driver i2cData at: i2cAddress.
		(event timestamp > requestTime) & (event register = register ) ifTrue: [ ^(event bytes) at: 1  ].
		100 milliSeconds wait. ]
]

{ #category : 'accessing' }
TMXI2CConnection >> write8BitsAt: reg data: aByteArray [

	self writeByteAt: reg data: aByteArray 
]

{ #category : 'accessing' }
TMXI2CConnection >> writeByteAt: register data: aByte [

	driver i2cWrite: (ByteArray with: register with: aByte) toAddress: i2cAddress 
]

{ #category : 'accessing' }
TMXI2CConnection >> writeWordAt: register data: aWord [
	"BackEndian is false"
	| payload |
	
	payload := ByteArray with: register with: (aWord \\ 256) with: (aWord // 256).
	driver i2cWrite: ((ByteArray with: register) , payload) toAddress: i2cAddress
]
