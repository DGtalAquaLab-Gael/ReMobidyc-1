Class {
	#name : #RMDAnimatInitializerNode,
	#superclass : #RMDSpeciesInitializerNode,
	#instVars : [
		'population',
		'animat'
	],
	#category : #'ReMobidyc-Language-AST'
}

{ #category : #'typical instances' }
RMDAnimatInitializerNode class >> goatInitializer [
	<script: 'RMDAnimatInitializerNode goatInitializer inspect'>
	^ RMDGrammar new animatInitializer end
		parse:
			'100 Goat with
	blood_sugar = uniform 10000 [kcal] to 100000 [kcal]'
]

{ #category : #'typical instances' }
RMDAnimatInitializerNode class >> goatInitializer: anInteger [
	<script: 'RMDAnimatInitializerNode goatInitializer inspect'>
	^ RMDGrammar new animatInitializer end
		parse:
			anInteger printString
				,
					' Goat with
	blood_sugar = uniform 10000 [kcal] to 100000 [kcal]'
]

{ #category : #'typical instances' }
RMDAnimatInitializerNode class >> goatInitializer: anInteger bloodSugar: aString1 to: aString2 [
	<script:
		'(RMDAnimatInitializerNode goatInitializer: 100 bloodSugar: ''10000[kcal]'' to: ''100000[kcal]'') inspect'>
	^ RMDGrammar new animatInitializer end
		parse:
			(String
				streamContents: [ :stream | 
					anInteger printOn: stream.
					stream
						nextPutAll: ' Goat with';
						cr;
						nextPutAll: '	blood_sugar = uniform ';
						nextPutAll: aString1;
						nextPutAll: ' to ';
						nextPutAll: aString2 ])
]

{ #category : #'instance creation' }
RMDAnimatInitializerNode class >> population: anInteger animat: aString propertyInitializers: anArrayOfRMDSimulationPropertyInitializerNode [
	^ self new
		population: anInteger;
		animat: aString;
		propertyInitializers: anArrayOfRMDSimulationPropertyInitializerNode;
		yourself
]

{ #category : #comparing }
RMDAnimatInitializerNode >> = anObject [
	^ super = anObject
		and: [ population = anObject population and: [ animat = anObject animat ] ]
]

{ #category : #accessing }
RMDAnimatInitializerNode >> animat [
	^ animat
]

{ #category : #accessing }
RMDAnimatInitializerNode >> animat: aString [
	animat := aString
]

{ #category : #comparing }
RMDAnimatInitializerNode >> hash [
	^ (super hash bitXor: population hash) bitXor: animat hash
]

{ #category : #testing }
RMDAnimatInitializerNode >> isAnimatInitializerNode [
	^ true
]

{ #category : #accessing }
RMDAnimatInitializerNode >> population [
	^ population
]

{ #category : #accessing }
RMDAnimatInitializerNode >> population: anInteger [
	population := anInteger
]

{ #category : #printing }
RMDAnimatInitializerNode >> printOn: aStream [
	population printOn: aStream.
	aStream
		nextPut: Character space;
		nextPutAll: animat.
	propertyInitializers
		ifNotEmpty: [ aStream
				nextPutAll: ' with';
				nextPut: Character cr.
			propertyInitializers
				do: [ :def | 
					def printOn: aStream.
					aStream nextPut: Character cr ] ]
]

{ #category : #rewriting }
RMDAnimatInitializerNode >> replaceChildren: aDictionary [
	super replaceChildren: aDictionary.
	aDictionary at: animat ifPresent: [ :node | animat := node copy ]
]
