Class {
	#name : 'TMXDriver',
	#superclass : 'Object',
	#instVars : [
		'ip',
		'port'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXDriver >> ip [

	^ ip
]

{ #category : 'accessing' }
TMXDriver >> ip: anObject [

	ip := anObject
]

{ #category : 'accessing' }
TMXDriver >> port [

	^ port
]

{ #category : 'accessing' }
TMXDriver >> port: anObject [

	port := anObject
]
