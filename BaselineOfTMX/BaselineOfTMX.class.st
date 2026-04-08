Class {
	#name : 'BaselineOfTMX',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTMX',
	#package : 'BaselineOfTMX'
}

{ #category : 'baselines' }
BaselineOfTMX >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self declareSerialPortOn: spec.

		spec package: 'Telenetrix-Pharo' with: [  spec requires: #('SerialPort') ] ]
]

{ #category : 'external projects' }
BaselineOfTMX >> declareSerialPortOn: spec [

	spec
		baseline: 'SerialPort'
		with: [ spec repository: 'github://robvanlopik/SerialPort:main' ]
]
