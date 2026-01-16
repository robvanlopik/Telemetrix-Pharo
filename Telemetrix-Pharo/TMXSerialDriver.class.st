Class {
	#name : 'TMXSerialDriver',
	#superclass : 'TMXDriver',
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'connection' }
TMXSerialDriver >> connectOnPort: aPortName baudRate: anInteger [
	"pif the port cannot be opened, store nil"
	
	self isConnected ifTrue: [ ^self ].
	tmxStream := TMXSerialStream on: 
		(SerialPort new baudRate: 115200; openPort: aPortName; yourself).
	tmxStream isConnected ifFalse: [  tmxStream := nil ].
	self startListener 
]
