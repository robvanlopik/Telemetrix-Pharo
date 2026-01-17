"
I am the superclass of the announcements sent by the TMXListener.
Each message has a timestamp attributed at the time of reception
"
Class {
	#name : 'TMXAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'timestamp'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'accessing' }
TMXAnnouncement >> timestamp [

	^ timestamp
]

{ #category : 'accessing' }
TMXAnnouncement >> timestamp: anObject [

	timestamp := anObject
]
