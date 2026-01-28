Class {
	#name : 'TMXEchoPort',
	#superclass : 'Object',
	#instVars : [
		'fifo'
	],
	#category : 'Telemetrix-Pharo-Tests',
	#package : 'Telemetrix-Pharo-Tests'
}

{ #category : 'initialization' }
TMXEchoPort >> initialize [

	fifo := SharedQueue new
]

{ #category : 'accessing' }
TMXEchoPort >> nextPutAll: aByteArray [

	self writeByteArray: aByteArray 
]

{ #category : 'reading' }
TMXEchoPort >> readByteArray [ 
	| result |
	fifo isEmpty ifTrue: [ ^ByteArray new ].
	result := ByteArray new: (fifo size).
	1 to: result size do: [  :i | result at: i put: fifo next ].
	^result
]

{ #category : 'accessing' }
TMXEchoPort >> readInto: aByteArray startingAt: index count: aNumber [
	| bytesToRead |
	(fifo isEmpty) ifTrue: [ ^0 ].
	bytesToRead := fifo size min: aNumber.
	1 to: bytesToRead do: [ :i | aByteArray at: (index + i - 1) put: fifo next].
	^bytesToRead
]

{ #category : 'writing' }
TMXEchoPort >> writeByteArray: aByteArray [

	aByteArray do: [ :byte | fifo nextPut: byte ]
]
