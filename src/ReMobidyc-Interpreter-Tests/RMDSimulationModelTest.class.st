Class {
	#name : #RMDSimulationModelTest,
	#superclass : #TestCase,
	#instVars : [
		'parser',
		'model'
	],
	#category : #'ReMobidyc-Interpreter-Tests'
}

{ #category : #running }
RMDSimulationModelTest >> setUp [
	parser := RMDGrammar new.
	model := RMDSimulationModel new
]

{ #category : #running }
RMDSimulationModelTest >> testActionDefinitionAtIfAbsent [
	| action |
	action := parser actionDefinition end
		parse:
			'to walk is
	my d/dt x'' = cos(heading) * my speed
	my d/dt y'' = sin(heading) * my speed.'.
	model addActionDefinition: action.
	self
		assert: (model actionDefinitionAt: 'walk' ifAbsent: [ nil ])
		equals: action.
	self
		assert: (model actionDefinitionAt: 'run' ifAbsent: [ nil ])
		equals: nil
]

{ #category : #running }
RMDSimulationModelTest >> testAddActionDefinition [
	| action |
	action := parser actionDefinition end
		parse:
			'to walk is
	my d/dt x'' = cos(heading) * my speed
	my d/dt y'' = sin(heading) * my speed.'.
	self
		assert: (model actionDefinitionAt: 'walk' ifAbsent: [ nil ])
		equals: nil.
	model addActionDefinition: action.
	self
		assert: (model actionDefinitionAt: 'walk' ifAbsent: [ nil ])
		equals: action.
	action := parser actionDefinition end
		parse:
			'to walk is
	my d/dt x'' = cos(heading) * my speed
	my d/dt y'' = sin(heading) * my speed.'.
	model addActionDefinition: action.
	self
		assert: (model actionDefinitionAt: 'walk' ifAbsent: [ nil ])
		equals: action
]

{ #category : #running }
RMDSimulationModelTest >> testAddAnimatDefinition [
	| animat |
	animat := parser animatDefinition end
		parse:
			'Goat is Animat with
	speed [km/h].'.
	self
		assert: (model animatDefinitionAt: 'Goat' ifAbsent: [ nil ])
		equals: nil.
	model addAnimatDefinition: animat.
	self
		assert: (model animatDefinitionAt: 'Goat' ifAbsent: [ nil ])
		equals: animat.
	animat := parser animatDefinition end
		parse:
			'Goat is Animat with
	walking_speed [km/h]
	running_speed [km/h].'.
	model addAnimatDefinition: animat.
	self
		assert: (model animatDefinitionAt: 'Goat' ifAbsent: [ nil ])
		equals: animat
]

{ #category : #running }
RMDSimulationModelTest >> testAddBehaviorDefinition [
	| behavior |
	behavior := parser behaviorDefinition end
		parse:
			'Goat walk with
	my speed -> my walking_speed.'.
	model addBehaviorDefinition: behavior.
	self
		assert:
			(Array
				streamContents: [ :stream | model behaviorsDo: [ :b | stream nextPut: b ] ])
		equals: {behavior}
]

{ #category : #running }
RMDSimulationModelTest >> testAnimatDefinitionAtIfAbsent [
	| animat |
	animat := parser animatDefinition end
		parse:
			'Goat is Animat with
	speed [km/h].'.
	model addAnimatDefinition: animat.
	self
		assert: (model animatDefinitionAt: 'Goat' ifAbsent: [ nil ])
		equals: animat.
	self
		assert: (model animatDefinitionAt: 'Wolf' ifAbsent: [ nil ])
		equals: nil
]

{ #category : #running }
RMDSimulationModelTest >> testAnimatDefinitionsDo [
	| animat1 animat2 animat3 |
	animat1 := parser animatDefinition end
		parse:
			'Goat is Animat with
	speed [km/h].'.
	animat2 := parser animatDefinition end
		parse:
			'Sheep is Animat with
	speed [km/h].'.
	animat3 := parser animatDefinition end
		parse:
			'Wolf is Animat with
	speed [km/h].'.
	model
		addAnimatDefinition: animat1;
		addAnimatDefinition: animat2;
		addAnimatDefinition: animat3.
	self
		assert:
			(Array
				streamContents: [ :stream | model animatDefinitionsDo: [ :a | stream nextPut: a ] ])
				asSet
		equals:
			{animat1.
			animat2.
			animat3} asSet
]

{ #category : #running }
RMDSimulationModelTest >> testAnimatInitializersDo [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self
		assert:
			(Array
				streamContents: [ :stream | model animatInitializersDo: [ :i | stream nextPut: i ] ])
				asSet
		equals: sim animatInitializers asSet
]

{ #category : #running }
RMDSimulationModelTest >> testBehaviorsDo [
	| behavior1 behavior2 behavior3 |
	behavior1 := parser behaviorDefinition end parse: 'Goat walk.'.
	model addBehaviorDefinition: behavior1.
	behavior2 := parser behaviorDefinition end
		parse:
			'Goat eat where
	my energy -> my blood_sugar
	here''s energy -> here''s grass.'.
	model addBehaviorDefinition: behavior2.
	behavior3 := parser behaviorDefinition end
		parse:
			'Wolf walk where
	my speed -> my walking_speed.'.
	model addBehaviorDefinition: behavior3.
	self
		assert:
			(Array
				streamContents: [ :stream | model behaviorsDo: [ :b | stream nextPut: b ] ])
				asSet
		equals:
			{behavior1.
			behavior2.
			behavior3} asSet
]

{ #category : #running }
RMDSimulationModelTest >> testCellDefinition [
	| cell |
	cell := parser cellDefinition end
		parse:
			'Cell with
	grass [kcal].'.
	model cellDefinition: cell.
	self assert: model cellDefinition equals: cell
]

{ #category : #running }
RMDSimulationModelTest >> testCellInitializer [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self
		assert: model cellInitializer
		equals:
			(parser cellInitializer end
				parse:
					'5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]')
]

{ #category : #running }
RMDSimulationModelTest >> testCellLength [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model cellLength closeTo: 10.0.
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 400 [m^2] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model cellLength closeTo: 20.0.

]

{ #category : #running }
RMDSimulationModelTest >> testCellXDivisions [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model cellXDivisions equals: 5
]

{ #category : #running }
RMDSimulationModelTest >> testCellYDivisions [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model cellYDivisions equals: 6
]

{ #category : #running }
RMDSimulationModelTest >> testDeltaTime [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model deltaTime closeTo: 12 * 60 * 60
]

{ #category : #running }
RMDSimulationModelTest >> testDuration [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model duration closeTo: 300 * 24 * 60 * 60
]

{ #category : #running }
RMDSimulationModelTest >> testEast [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model east closeTo: 50
]

{ #category : #running }
RMDSimulationModelTest >> testLoadAnimatDefinition [
	| animat |
	animat := parser animatDefinition end
		parse:
			'Goat is Animat with
	speed [km/h].'.
	self
		assert: (model animatDefinitionAt: 'Goat' ifAbsent: [ nil ])
		equals: nil.
	model addAnimatDefinition: animat.
	self
		assert: (model animatDefinitionAt: 'Goat' ifAbsent: [ nil ])
		equals: animat.
	animat := parser animatDefinition end
		parse:
			'Goat is Animat with
	walking_speed [km/h]
	running_speed [km/h].'.
	model addAnimatDefinition: animat.
	self
		assert: (model animatDefinitionAt: 'Goat' ifAbsent: [ nil ])
		equals: animat
]

{ #category : #running }
RMDSimulationModelTest >> testNorth [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model north closeTo: 60
]

{ #category : #running }
RMDSimulationModelTest >> testSimulationDefinition [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model simulationDefinition equals: sim
]

{ #category : #running }
RMDSimulationModelTest >> testSouth [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model south closeTo: 0
]

{ #category : #running }
RMDSimulationModelTest >> testWest [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self assert: model west closeTo: 0
]

{ #category : #running }
RMDSimulationModelTest >> testWorldDefinition [
	| world |
	world := parser worldDefinition end
		parse:
			'World with
	temperature [C].' trim.
	self assert: world isWorldDefinitionNode.
	model worldDefinition: world.
	self assert: model worldDefinition equals: world
]

{ #category : #running }
RMDSimulationModelTest >> testWorldInitializer [
	| sim |
	sim := parser simulationDefinition end
		parse:
			'
Simulation with
	during 300[day] by 0.5[day]
World with
	temperature = 30 [C]
5 x 6 of 10 [m] Cell with
    grass = uniform 1000[kcal] to 5000[kcal]
10 Goat with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day]
2 Wolf with
    x = uniform 0[m] to 50[m]
    y = uniform 0[m] to 50[m]
    blood_sugar = 1000[kcal]
    age = 0[day].' trim.
	self assert: sim isSimulationDefinitionNode.
	model simulationDefinition: sim.
	self
		assert: model worldInitializer
		equals:
			(parser worldInitializer end
				parse:
					'World with
	temperature = 30 [C]')
]