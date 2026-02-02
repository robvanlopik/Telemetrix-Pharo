"
I am the abstract superclass of the TMXDrivers that use the serial port
"
Class {
	#name : 'TMXSerialDriver',
	#superclass : 'TMXDriver',
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'testing' }
TMXSerialDriver class >> isAbstract [

	^ self == TMXSerialDriver
]

{ #category : 'connection' }
TMXSerialDriver >> connectOnPort: aPortName [
	"pif the port cannot be opened, store nil"
	
	self isConnected ifTrue: [ ^self ].
	tmxStream := TMXSerialStream on: 
		(SerialPort new baudRate: 115200; openPort: aPortName; yourself).
	tmxStream isConnected ifFalse: [  tmxStream := nil ].
	self startListener 
]

{ #category : 'connection' }
TMXSerialDriver >> connectOnPort: aPortName baudRate: anInteger [
	"pif the port cannot be opened, store nil"
	
	self isConnected ifTrue: [ ^self ].
	tmxStream := TMXSerialStream on: 
		(SerialPort new baudRate: 115200; openPort: aPortName; yourself).
	tmxStream isConnected ifFalse: [  tmxStream := nil ].
	self startListener 
]
