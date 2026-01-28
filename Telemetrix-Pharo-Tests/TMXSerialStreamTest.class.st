Class {
	#name : 'TMXSerialStreamTest',
	#superclass : 'TestCase',
	#instVars : [
		'ss'
	],
	#category : 'Telemetrix-Pharo-Tests',
	#package : 'Telemetrix-Pharo-Tests'
}

{ #category : 'running' }
TMXSerialStreamTest >> setUp [
	super setUp.

	ss := TMXSerialStream on: TMXEchoPort new
]

{ #category : 'tests' }
TMXSerialStreamTest >> testIsDataAvailable [

	self assert: [ss isDataAvailable = false].
	ss nextPutAll: #[1].
	self assert: [ss isDataAvailable = true]
]

{ #category : 'tests' }
TMXSerialStreamTest >> testReadInto [
	"test readinto:startingAt:count:	"
	| buffer |
	ss nextPutAll: #[1 2 3 4].
	buffer := ByteArray new: 5.
	ss readInto: buffer startingAt: 1 count: 3.
	self assert: [ buffer = #[1 2 3 0 0 ]].
]

{ #category : 'tests' }
TMXSerialStreamTest >> testTimeout [ 
	| buffer |
	
	ss timeout: 100. "100 milliseconds!"
	buffer := ByteArray new: 5.
	ss nextPutAll: #[1 2 3].
	self assert: [ ss isDataAvailable = true ].
	self should: [ ss readInto: buffer startingAt: 1 count: 4] raise: Error
	
	
]
