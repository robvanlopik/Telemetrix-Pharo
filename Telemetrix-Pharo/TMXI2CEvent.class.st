"
I am the event that is cnstructed when receiving an i2c message.
The channel parameter is optional, only for those boards that support more i2c channels
"
Class {
	#name : 'TMXI2CEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'address',
		'register',
		'count',
		'bytes',
		'channel'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'accessing' }
TMXI2CEvent >> address [

	^ address
]

{ #category : 'accessing' }
TMXI2CEvent >> address: anObject [

	address := anObject
]

{ #category : 'accessing' }
TMXI2CEvent >> bytes [

	^ bytes
]

{ #category : 'accessing' }
TMXI2CEvent >> bytes: anObject [

	bytes := anObject
]

{ #category : 'accessing' }
TMXI2CEvent >> channel [

	^ channel
]

{ #category : 'accessing' }
TMXI2CEvent >> channel: anObject [

	channel := anObject
]

{ #category : 'accessing' }
TMXI2CEvent >> count [

	^ count
]

{ #category : 'accessing' }
TMXI2CEvent >> count: anObject [

	count := anObject
]

{ #category : 'accessing' }
TMXI2CEvent >> register [

	^ register
]

{ #category : 'accessing' }
TMXI2CEvent >> register: anObject [

	register := anObject
]
