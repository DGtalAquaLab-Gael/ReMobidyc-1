Class {
	#name : #RMDSimulationModel,
	#superclass : #Object,
	#instVars : [
		'simulationDefinition',
		'animatDefinitions',
		'cellDefinition',
		'worldDefinition',
		'actionDefinitions',
		'behaviorDefinitions'
	],
	#category : #'ReMobidyc-Interpreter'
}

{ #category : #'accessing - definitions' }
RMDSimulationModel >> actionDefinitionAt: aString ifAbsent: errorBlock [
	^ actionDefinitions at: aString ifAbsent: errorBlock
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> actionNames [
	^ actionDefinitions keys asSortedCollection
]

{ #category : #adding }
RMDSimulationModel >> addActionDefinition: aRMDActionDefinitionNode [
	actionDefinitions
		at: aRMDActionDefinitionNode identifier
		put: aRMDActionDefinitionNode.
	behaviorDefinitions
		do: [ :behavior | 
			behavior actionIdentifier = aRMDActionDefinitionNode identifier
				ifTrue: [ behavior resetAction ] ].
	^ aRMDActionDefinitionNode
]

{ #category : #adding }
RMDSimulationModel >> addAnimatDefinition: aRMDAnimatDefinitionNode [
	^ animatDefinitions
		at: aRMDAnimatDefinitionNode identifier
		put: aRMDAnimatDefinitionNode
]

{ #category : #adding }
RMDSimulationModel >> addBehaviorDefinition: aRMDBehaviorDefinitionNode [
	^ behaviorDefinitions add: aRMDBehaviorDefinitionNode
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> animatDefinitionAt: aString ifAbsent: errorBlock [
	^ animatDefinitions at: aString ifAbsent: errorBlock
]

{ #category : #enumerating }
RMDSimulationModel >> animatDefinitionsDo: aBlock [
	animatDefinitions valuesDo: aBlock
]

{ #category : #enumerating }
RMDSimulationModel >> animatInitializersDo: aBlock [
	simulationDefinition animatInitializers do: aBlock
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> animatNames [
	^ animatDefinitions keys asSortedCollection
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> behaviorDefinitions [
	^ Array withAll: behaviorDefinitions
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> behaviorNames [
	^ (behaviorDefinitions collect: #name) asSortedCollection
]

{ #category : #enumerating }
RMDSimulationModel >> behaviorsDo: aBlock [
	behaviorDefinitions do: aBlock
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> cellDefinition [
	^ cellDefinition
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> cellDefinition: aRMDCellDefinitionNode [
	cellDefinition := aRMDCellDefinitionNode
]

{ #category : #'accessing - initializers' }
RMDSimulationModel >> cellInitializer [
	^ simulationDefinition cellInitializer
]

{ #category : #'accessing-cells' }
RMDSimulationModel >> cellLength [
	^ simulationDefinition cellInitializer length
]

{ #category : #'accessing-cells' }
RMDSimulationModel >> cellXDivisions [
	^ simulationDefinition cellInitializer xDivisions
]

{ #category : #'accessing-cells' }
RMDSimulationModel >> cellYDivisions [
	^ simulationDefinition cellInitializer yDivisions
]

{ #category : #'accessing - time' }
RMDSimulationModel >> deltaTime [
	^ simulationDefinition timeDefinition step numeric
]

{ #category : #'accessing - time' }
RMDSimulationModel >> duration [
	^ simulationDefinition timeDefinition duration numeric
]

{ #category : #'accessing-cells' }
RMDSimulationModel >> east [
	^ self cellLength * self cellXDivisions
]

{ #category : #initialization }
RMDSimulationModel >> initialize [
	super initialize.
	simulationDefinition := RMDSimulationDefinitionNode empty.
	cellDefinition := RMDCellDefinitionNode empty.
	worldDefinition := RMDWorldDefinitionNode empty.
	animatDefinitions := Dictionary new.
	actionDefinitions := Dictionary new.
	behaviorDefinitions := OrderedCollection new
]

{ #category : #accessing }
RMDSimulationModel >> load: aRMDSyntaxNode [
	aRMDSyntaxNode isWorldDefinitionNode
		ifTrue: [ ^ self worldDefinition: aRMDSyntaxNode ].
	aRMDSyntaxNode isCellDefinitionNode
		ifTrue: [ ^ self cellDefinition: aRMDSyntaxNode ].
	aRMDSyntaxNode isAnimatDefinitionNode
		ifTrue: [ ^ self addAnimatDefinition: aRMDSyntaxNode ].
	aRMDSyntaxNode isActionDefinitionNode
		ifTrue: [ ^ self addActionDefinition: aRMDSyntaxNode ].
	aRMDSyntaxNode isBehaviorDefinitionNode
		ifTrue: [ ^ self addBehaviorDefinition: aRMDSyntaxNode ].
	aRMDSyntaxNode isSimulationDefinitionNode
		ifTrue: [ ^self simulationDefinition: aRMDSyntaxNode ].
	^ self error: 'Unknown load'
]

{ #category : #'accessing-cells' }
RMDSimulationModel >> north [
	^ self cellLength * self cellYDivisions
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> replaceBehavior: aRMDBehaviorDefinitionNode with: anotherRMDBehaviorDefinitionNode [
	| index |
	index := behaviorDefinitions indexOf: aRMDBehaviorDefinitionNode.
	index = 0
		ifTrue: [ behaviorDefinitions add: anotherRMDBehaviorDefinitionNode ]
		ifFalse:
			[ behaviorDefinitions at: index put: anotherRMDBehaviorDefinitionNode ].
	^ anotherRMDBehaviorDefinitionNode
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> simulationDefinition [
	^ simulationDefinition
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> simulationDefinition: aRMDSimulationDefinition [
	simulationDefinition := aRMDSimulationDefinition
]

{ #category : #'accessing-cells' }
RMDSimulationModel >> south [
	^ 0.0
]

{ #category : #'accessing-cells' }
RMDSimulationModel >> west [
	^ 0.0
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> worldDefinition [
	^ worldDefinition
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> worldDefinition: aRMDWorldDefinitionNode [
	worldDefinition := aRMDWorldDefinitionNode
]

{ #category : #'accessing - initializers' }
RMDSimulationModel >> worldInitializer [
	^ simulationDefinition worldInitializer
]
