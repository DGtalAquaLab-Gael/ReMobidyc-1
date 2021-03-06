Class {
	#name : #RMDBehaviorDefinitionNode,
	#superclass : #RMDSyntaxNode,
	#instVars : [
		'subjectIdentifier',
		'actionIdentifier',
		'objectIdentifier',
		'range',
		'propertyBinds',
		'action',
		'name'
	],
	#category : #'ReMobidyc-Language-AST'
}

{ #category : #'typical instances' }
RMDBehaviorDefinitionNode class >> cell_grow_grass: amountString upto: maxString [
	<script:
		'(RMDBehaviorDefinitionNode cell_grow_grass: ''1000[kcal/day]'' upto: ''10000[kcal]'') asPresenter openWithSpec'>
	^ ('Cell grow_grass where
	here''s max_grass -> ' , maxString
		,
			'
	here''s growth_rate -> ' , amountString , '.')
		asRMDBehaviorDefinition
]

{ #category : #'typical instances' }
RMDBehaviorDefinitionNode class >> goat_eat_grass: dietString upto: maxString [
	<script:
		'(RMDBehaviorDefinitionNode goat_eat_grass: ''1000[kcal/day]'' upto: ''10000[kcal]'') asPresenter openWithSpec'>
	^ ('Goat eat_grass where
	my energy -> my blood_sugar
	my max_energy -> ' , maxString
		,
			'
	my diet -> ' , dietString , '.') asRMDBehaviorDefinition
]

{ #category : #'typical instances' }
RMDBehaviorDefinitionNode class >> goat_respire: aString [
	<script: '(RMDBehaviorDefinitionNode goat_respire: ''2000[kcal/day]'') asPresenter openWithSpec'>
	^ ('Goat respire where
	my energy -> my blood_sugar
	my respiration_rate -> ' , aString , '.') asRMDBehaviorDefinition
]

{ #category : #'typical instances' }
RMDBehaviorDefinitionNode class >> goat_walk_for_grass [
	<script:
		'RMDBehaviorDefinitionNode goat_walk_for_grass asPresenter openWithSpec'>
	^ 'Goat move where
	my heading -> direction neighbor''s grass
	my speed -> 1[km/day].' asRMDBehaviorDefinition
]

{ #category : #'instance creation' }
RMDBehaviorDefinitionNode class >> subjectIdentifier: agentString1 scriptIdentifier: scriptString1 objectIdentifier: agentString2 within: aRMDLiteralNode propertyBinds: anArrayOfRMDPropertyBindNode [
	^ self new
		subjectIdentifier: agentString1;
		actionIdentifier: scriptString1;
		objectIdentifier: agentString2;
		range: aRMDLiteralNode;
		propertyBinds: anArrayOfRMDPropertyBindNode;
		yourself
]

{ #category : #comparing }
RMDBehaviorDefinitionNode >> = anObject [
	^ self class = anObject class
		and: [ subjectIdentifier = anObject subjectIdentifier
				and: [ objectIdentifier = anObject objectIdentifier
						and: [ range = anObject range
								and: [ propertyBinds = anObject propertyBinds
										and: [ actionIdentifier = anObject actionIdentifier ] ] ] ] ]
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> actionIdentifier [
	^ actionIdentifier
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> actionIdentifier: aString [
	actionIdentifier := aString.
	name := nil
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> actionWith: aRMDInterpreter [
	^ action
		ifNil: [ action := (aRMDInterpreter
				actionDefinitionAt: actionIdentifier
				ifAbsent: [ ^ KeyNotFound signal: actionIdentifier ])
				copyReplace:
					(propertyBinds
						collect: [ :bind | 
							(RMDPropertyVariableNode
								identifier: bind actionProperty
								agent: bind actionAgent) -> bind expression ]) asDictionary ]
]

{ #category : #enumerating }
RMDBehaviorDefinitionNode >> childrenDo: aBlock [
	aBlock value: range.
	propertyBinds do: aBlock
]

{ #category : #testing }
RMDBehaviorDefinitionNode >> hasObject [
	^ objectIdentifier notNil
]

{ #category : #comparing }
RMDBehaviorDefinitionNode >> hash [
	^ (((subjectIdentifier hash bitXor: objectIdentifier hash)
		bitXor: range hash) bitXor: propertyBinds hash)
		bitXor: actionIdentifier hash
]

{ #category : #testing }
RMDBehaviorDefinitionNode >> isBehaviorDefinitionNode [
	^ true
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> name [
	^ name
		ifNil: [ name := String
				streamContents: [ :stream | 
					stream
						nextPutAll: subjectIdentifier;
						space;
						nextPutAll: actionIdentifier.
					objectIdentifier
						ifNotNil: [ stream
								space;
								nextPutAll: objectIdentifier ] ] ]
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> objectIdentifier [
	^ objectIdentifier
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> objectIdentifier: aString [
	objectIdentifier := aString.
	name := nil
]

{ #category : #copying }
RMDBehaviorDefinitionNode >> postCopy [
	range := range ifNotNil: #copy.
	propertyBinds := propertyBinds
		ifNotNil: [ propertyBinds collect: #copy ]
]

{ #category : #printing }
RMDBehaviorDefinitionNode >> printOn: aStream [
	aStream
		nextPutAll: subjectIdentifier;
		nextPutAll: ' ';
		nextPutAll: actionIdentifier.
	objectIdentifier
		ifNotNil: [ aStream
				nextPut: Character space;
				nextPutAll: objectIdentifier ].
	(propertyBinds notNil and: [ propertyBinds notEmpty ])
		ifTrue: [ aStream
				nextPutAll: ' where';
				nextPut: Character cr.
			propertyBinds
				do: [ :bind | 
					aStream nextPutAll: '    '.
					bind printOn: aStream ]
				separatedBy: [ aStream nextPut: Character cr ] ].
	aStream nextPut: $.
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> propertyBinds [
	^ propertyBinds
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> propertyBinds: anArrayOfRMDPropertyBindNode [
	propertyBinds := anArrayOfRMDPropertyBindNode
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> range [
	^ range
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> range: aRMDLiteral [
	range := aRMDLiteral
]

{ #category : #rewriting }
RMDBehaviorDefinitionNode >> replaceChildren: aDictionary [
	aDictionary
		at: subjectIdentifier
		ifPresent: [ :node | subjectIdentifier := node copy ].
	aDictionary
		at: objectIdentifier
		ifPresent: [ :node | objectIdentifier := node copy ].
	range
		ifNotNil: [ range := aDictionary
				at: range
				ifPresent: #copy
				ifAbsent: [ range copyReplace: aDictionary ] ].
	propertyBinds := propertyBinds
		collect: [ :node | node copyReplace: aDictionary ].
	aDictionary
		at: actionIdentifier
		ifPresent: [ :node | actionIdentifier := node copy ]
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> resetAction [
	action := nil
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> subjectIdentifier [
	^ subjectIdentifier
]

{ #category : #accessing }
RMDBehaviorDefinitionNode >> subjectIdentifier: aString [
	subjectIdentifier := aString.
	name := nil
]
