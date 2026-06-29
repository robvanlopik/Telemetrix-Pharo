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

		spec package: 'Telemetrix-Pharo' with: [  spec requires: #('SerialPort') ].
		spec package: 'Telemetrix-Pharo-Tests' with: [  spec requires: #('Telemetrix-Pharo') ]]
]

{ #category : 'external projects' }
BaselineOfTMX >> declareSerialPortOn: spec [

	spec
		baseline: 'SerialPort'
		with: [ spec repository: 'github://robvanlopik/SerialPort:main' ]
]
