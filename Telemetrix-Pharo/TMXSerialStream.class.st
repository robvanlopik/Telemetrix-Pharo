"
I present a stream view of a SerialPort, (almost) exactly like SocketStram on a Socket.
I aim to have the same APÏ as SocketStream, but for the time being this is limited to the methods used in the Telemetrix-Pharo project
Only supports ByteArrays.
As a starter, output is NOT buffered
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

{ #category : 'private' }
TMXSerialStream >> growInBuffer [
	"Grows through doubling."

	self resizeInBuffer: inBuffer size * 2
]

{ #category : 'initialization' }
TMXSerialStream >> initialize [
	super initialize.
	autoFlush := true.
	shouldSignal := true.
	recentlyRead := 0.
	bufferSize := 4096.
	self resetBuffers
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
	serialPort dataAvailable
		ifFalse: [false]
		ifTrue: [self receiveDataIfAvailable; isDataAvailable]
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
TMXSerialStream >> nextPutAll: aByteArray [
	^self writeByteArray: aByteArray
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
TMXSerialStream >> serialPort: aSerialPort [

	serialPort := aSerialPort
]

{ #category : 'writing' }
TMXSerialStream >> writeByteArray: aBytearray [
	"for the time being we don't buffer output"
	
	serialPort writeByteArray: aBytearray
	
]
