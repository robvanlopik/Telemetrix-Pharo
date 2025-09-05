"
I am the superclass of the announcements sent by the TMXListener.
Each message has a Unix timestamp as the last 4 bytes of the message.
"
Class {
	#name : 'TMXAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'timestamp'
	],
	#category : 'Telemetrix-Pharo',
	#package : 'Telemetrix-Pharo'
}

{ #category : 'accessing' }
TMXAnnouncement >> timestamp [

	^ timestamp
]

{ #category : 'accessing' }
TMXAnnouncement >> timestamp: anObject [

	timestamp := anObject
]
