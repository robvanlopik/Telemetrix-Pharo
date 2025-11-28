"
I represent the I2C connection to a single device, identified by its address on the I2C bus.

I am created by TMXDriver>>oipenI2C

Implementation:
as reactions to I2C requests are asynchronous, we have to buffer those answers. This is done in the instance variable i2cData of the TMSdriver. This is a dictionary with the i2c address as key and the generated announcement, an nstance of TMXI2CEvent, as value. An I2C reaad request loops until the timetsamp of the  announcement is greater than the timestamp off the request. We wait for a maximum of 2000 milliseconds. My first test with the DS1307 RTC device poits to a response time that can amount to 1 second
"
Class {
	#name : 'TMXI2CConnection',
	#superclass : 'Object',
	#instVars : [
		'i2cAddress',
		'driver'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
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

{ #category : 'i2c' }
TMXI2CConnection >> i2cAddress [

	^ i2cAddress
]

{ #category : 'i2c' }
TMXI2CConnection >> i2cAddress: anObject [

	i2cAddress := anObject
]

{ #category : 'i2c' }
TMXI2CConnection >> read8BitsAt: anInteger [ 
	^self readByteAt: anInteger
]

{ #category : 'i2c' }
TMXI2CConnection >> readByteAt: register [

	| requestTime |
	requestTime := DateAndTime now.
	driver i2cReadFromAdress: i2cAddress register: register count: 1. 
	40 timesRepeat: [  :ann | | event |
		event := driver i2cData at: i2cAddress.
		(event timestamp > requestTime) & (event register = register ) ifTrue: [ ^(event bytes) at: 1  ].
		50 milliSeconds wait. ]
]

{ #category : 'i2c' }
TMXI2CConnection >> write8BitsAt: reg data: aByteArray [

	self writeByteAt: reg data: aByteArray 
]

{ #category : 'i2c' }
TMXI2CConnection >> writeByteAt: register data: aByte [

	driver i2cWrite: (ByteArray with: register with: aByte) toAddress: i2cAddress 
]

{ #category : 'i2c' }
TMXI2CConnection >> writeWordAt: register data: aWord [
	"BackEndian is false"
	| payload |
	
	payload := ByteArray with: register with: (aWord \\ 256) with: (aWord // 256).
	driver i2cWrite: ((ByteArray with: register) , payload) toAddress: i2cAddress
]
