Extension { #name : #RMDWorldInitializerNodeTest }

{ #category : #'*ReMobidyc-Interpreter-Tests' }
RMDWorldInitializerNodeTest >> testEvalIn [
	| worldDef worldInitializer count |
	worldDef := parser worldDefinition end
		parse:
			'World with
	temperature [C]
	humidity [].'.
	worldInitializer := parser worldInitializer
		parse:
			'World with
			temperature = -10 [C]
			humidity = 0.4 []'.
	interpreter allocateWorld: worldDef.
	interpreter
		individualsOf: worldDef
		do: [ :world | 
			interpreter
				withInitializerContextWithSubject: world
				species: worldDef
				do: [ worldInitializer evalIn: interpreter ] ].
	count := 0.
	interpreter
		individualsOf: worldDef
		do: [ :world | 
			interpreter
				withActionContextWithIndividual: world
				species: worldDef
				do: [ self
						assert: (interpreter readVariable: 'temperature' agent: nil ifAbsent: [ nil ])
						closeTo: (RMDUnit celsius toSI: -10).
					self
						assert: (interpreter readVariable: 'humidity' agent: nil ifAbsent: [ nil ])
						closeTo: 0.4.
					self assert: interpreter time closeTo: 0.0.
					count := count + 1 ] ].
	self assert: count equals: 1
]
