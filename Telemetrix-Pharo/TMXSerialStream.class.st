"
I present a stream view of a SerialPort, (almost) exactly like SocketStram on a Socket.
I aim to have the same APÏ as SocketStream, but for the time being this is limited to the methods used in the Telemetrix-Pharo project
Only supports ByteArrays.
As a starter, output is NOT buffered

Note: #adjustInBuffer uses absolute buffer sizes, making it impracical to change the buffer size in #initialize
"
Class {
	#name : 'TMXSerialStream',
	#superclass : 'TMXStream',
	#instVars : [
		'recentlyRead',
		'serialPort',
		'inBuffer',
		'outBuffer',
		'inNextToWrite',
		'outNextToWrite',
		'lastRead',
		'timeout',
		'autoFlush',
		'bufferSize',
		'binary',
		'shouldSignal'
	],
	#category : 'Telemetrix-Pharo-Core',
	#package : 'Telemetrix-Pharo',
	#tag : 'Core'
}

{ #category : 'instance creation' }
TMXSerialStream class >> on: aSerialPort [

	^self basicNew initialize serialPort: aSerialPort
]

{ #category : 'private' }
TMXSerialStream >> adjustInBuffer: bytesRead [
	"Adjust markers and possibly grow inBuffer or move data down.
	Currently grows through doubling when less than 1024 bytes are left.
	Never shrinks. Returns the position in the buffer where any new
	data can be found."

	| old |
	bytesRead = 0 ifTrue: [^inNextToWrite].
	old := inNextToWrite.
	inNextToWrite := inNextToWrite + bytesRead.
	(inBuffer size - inNextToWrite) < 1024
		ifTrue: [
			"Hit the roof, move data down (if enough has been read) or do we grow?"
			(lastRead > 512)
				ifTrue: [^old - self moveInBufferDown]
				ifFalse: [self growInBuffer]].
	^old
]

{ #category : 'accessing' }
TMXSerialStream >> atEnd [
	"There is nothing more to read when
	there is no more data in our inBuffer, the socket
	is disconnected and there is none available on the socket.
	Note that we need to check isConnected before isDataAvailable,
	otherwise data may sneak in in the meantime. But we check the
	buffer first, because it is faster."

	self isInBufferEmpty ifFalse: [^false].
	^self isConnected not
		and: [self isDataAvailable not]
]

{ #category : 'accessing' }
TMXSerialStream >> binary [
	"do nothing no choice"
]

{ #category : 'accessing' }
TMXSerialStream >> flush [
 "as the outputstream is nog buffered, essentially a NOP"
]

{ #category : 'private' }
TMXSerialStream >> growInBuffer [
	"Grows through doubling."

	self resizeInBuffer: inBuffer size * 2
]

{ #category : 'configuration' }
TMXSerialStream >> inBufferSize [
	"Answers the current size of data in the inBuffer."

	^inNextToWrite - lastRead - 1
	
]

{ #category : 'initialization' }
TMXSerialStream >> initialize [
	super initialize.
	autoFlush := true.
	shouldSignal := true.
	recentlyRead := 0.
	bufferSize := 4096.
	timeout := 30.
	self resetBuffers
]

{ #category : 'testing' }
TMXSerialStream >> isConnected [

	^serialPort notNil
]

{ #category : 'accessing' }
TMXSerialStream >> isDataAvailable [
	"It the inbuffer is empty, we check the socket for data.
	If it claims to have data available to read, we try to read
	some once and recursively call this method again.
	If something really was available it is now in the inBuffer.
	This is because there has been spurious
	dataAvailable when there really is no data to get."

	self isInBufferEmpty ifFalse: [^true].
	self receiveDataIfAvailable.
	^self isInBufferEmpty not
]

{ #category : 'testing' }
TMXSerialStream >> isInBufferEmpty [ 
	^lastRead + 1 = inNextToWrite
]

{ #category : 'private' }
TMXSerialStream >> moveInBufferDown [
	"Move down contents of inBuffer to the start.
	Return distance moved."

	| sz distanceMoved |
	sz := inNextToWrite - lastRead - 1.
	inBuffer replaceFrom: 1 to: sz with: inBuffer startingAt: lastRead + 1.
	distanceMoved := lastRead.
	lastRead := 0.
	inNextToWrite := sz + 1.
	^distanceMoved
]

{ #category : 'accessing' }
TMXSerialStream >> next [
	"Return next byte, if inBuffer is empty
	we recieve some more data and try again."

	self atEnd ifTrue: [^nil].
	self isInBufferEmpty ifTrue:
		[self receiveData.
		self atEnd ifTrue: [^nil]].
	lastRead := lastRead + 1.
	^inBuffer at: lastRead
]

{ #category : 'accessing' }
TMXSerialStream >> next: n into: aCollection [
	"Read n objects into the given collection.
	Return aCollection or a partial copy if less than
	n elements have been read."
	^self next: n into: aCollection startingAt: 1
]

{ #category : 'accessing' }
TMXSerialStream >> next: requestedCount into: collection startingAt: startIndex [
	"Read requestedCount objects into the given collection.
	Return collection or a partial copy if less elements have been read."

	| readCount |
	readCount := self readInto: collection startingAt: startIndex count: requestedCount.
	^ readCount = requestedCount
		ifTrue: [ collection ]
		ifFalse: [ collection copyFrom: 1 to: startIndex + readCount - 1 ]
]

{ #category : 'accessing' }
TMXSerialStream >> nextPutAll: aByteArray [
	^self writeByteArray: aByteArray
]

{ #category : 'accessing' }
TMXSerialStream >> readInto: aByteArray startingAt: startIndex count: anInteger [
	"This is the only method in SocketStream that either delivers the correct number of bytetes orr times out. It must use SerialPort>>readBytearray:"
	
	| start amount |

	self receiveData: anInteger.
	"Inlined version of nextInBuffer: to avoid copying the contents"
	amount := anInteger min: (inNextToWrite - lastRead - 1).
	start := lastRead + 1.
	lastRead := lastRead + amount.
	aByteArray
		replaceFrom: startIndex
		to: startIndex + amount-1
		with: inBuffer
		startingAt: start.
	^amount
]

{ #category : 'receiving' }
TMXSerialStream >> receiveData [
	"receive at least one byte or time out
	repeat logic of serialPort>> readByteArray:timeout"
	| maxCount count timeRemaining |
	
	maxCount := bufferSize - inNextToWrite - 1.
	timeRemaining := timeout.
	count := serialPort readInto: inBuffer startingAt: inNextToWrite count: maxCount.
	[ count = 0 and: [ timeRemaining > 0 ] ]
		whileTrue: [ 
			20 milliSeconds wait.
			timeRemaining := timeRemaining - 20.
			count := serialPort readInto: inBuffer startingAt: inNextToWrite count: maxCount]. 
	(count = 0) ifTrue: [ self error: 'timeout reading from port' ].
	^self adjustInBuffer: count
]

{ #category : 'control' }
TMXSerialStream >> receiveData: nBytes [
	"Keep reading the socket until we have nBytes
	in the inBuffer or we reach the end. This method
	does not return data, but can be used to make sure
	data has been read into the buffer from the Socket
	before actually reading it from the FastSocketStream.
	Mainly used internally. We could also adjust the buffer
	to the expected amount of data and avoiding several
	incremental grow operations.

	NOTE: This method doesn't honor timeouts if shouldSignal
	is false! And frankly, I am not sure how to handle that
	case or if I care - I think we should always signal."

	[self isConnected and: [nBytes > self inBufferSize]]
		whileTrue: [self receiveData]
]

{ #category : 'private - socket' }
TMXSerialStream >> receiveDataIfAvailable [
	"Only used to check that there really is data to read
	from the socket after it signals dataAvailable.
	It has been known to signal true and then still
	not have anything to read. See also isDataAvailable.
	Return the position in the buffer where the
	new data starts, regardless if anything
	was read, see #adjustInBuffer."

	recentlyRead := serialPort readInto: inBuffer startingAt: inNextToWrite count: (inBuffer size - inNextToWrite - 1).
	^self adjustInBuffer: recentlyRead
]

{ #category : 'initialization' }
TMXSerialStream >> resetBuffers [ 

	inBuffer := ByteArray new: bufferSize.
	lastRead := 0.
	inNextToWrite := 1.
	outBuffer := ByteArray new: bufferSize.
	outNextToWrite := 1
]

{ #category : 'private' }
TMXSerialStream >> resizeInBuffer: newSize [
	"Resize the inBuffer by recreating it.
	This also has the effect of getting rid of
	dead data above inNextToWrite.
	<newSize> must >= inBuffer size!"

	inBuffer := (ByteArray new: newSize)
					replaceFrom: 1 to: inNextToWrite - 1 with: inBuffer startingAt: 1
]

{ #category : 'accessing' }
TMXSerialStream >> serialPort [

	^serialPort
]

{ #category : 'accessing' }
TMXSerialStream >> serialPort: aSerialPort [

	serialPort := aSerialPort
]

{ #category : 'accessing' }
TMXSerialStream >> timeout [
	^timeout 
]

{ #category : 'accessing' }
TMXSerialStream >> timeout: milliseconds [
	timeout := milliseconds
]

{ #category : 'writing' }
TMXSerialStream >> writeByteArray: aBytearray [
	"for the time being we don't buffer output"
	
	serialPort writeByteArray: aBytearray
	
]
