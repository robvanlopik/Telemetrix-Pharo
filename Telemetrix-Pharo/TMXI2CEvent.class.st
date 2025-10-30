Class {
	#name : 'TMXI2CEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'address',
		'register',
		'count',
		'bytes'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
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
