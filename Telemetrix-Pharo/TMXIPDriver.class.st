Class {
	#name : 'TMXIPDriver',
	#superclass : 'TMXDriver',
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'initialize-release' }
TMXIPDriver >> connectOnIP: anAddress [
	"connect with default port 31335"

	self connectOnIP: anAddress port: 31335
]

{ #category : 'initialize-release' }
TMXIPDriver >> connectOnIP: anIPString port: aPortNumber [
	"if the socket cannot be opened, store nil"	
			
	self isConnected ifTrue: [ ^self ].
	
	tmxStream := SocketStream openConnectionToHostNamed: anIPString port: aPortNumber.
	tmxStream isConnected ifFalse: [ tmxStream := nil ].
	tmxStream binary.
	self startListener 
	
		
]
