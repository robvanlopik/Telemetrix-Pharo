"
I am the superclass for the IP-based Telemetrix drivers. I facilitate their initialisation by connecting to the quested IP address and port (default 31335)
"
Class {
	#name : 'TMXIPDriver',
	#superclass : 'TMXDriver',
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'testing' }
TMXIPDriver class >> isAbstract [

	^ self == TMXIPDriver
]

{ #category : 'as yet unclassified' }
TMXIPDriver class >> onIP: anIPString [
	^self new
		connectOnIP: anIPString;
		startListener;
		yourself
]

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
