"
I rpoduce the loopback announcement when receiving code 0
"
Class {
	#name : 'TMXLoopbackEvent',
	#superclass : 'TMXAnnouncement',
	#instVars : [
		'data'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXLoopbackEvent >> data [
	^data
]

{ #category : 'accessing' }
TMXLoopbackEvent >> data: anObject [

	data := anObject
]
