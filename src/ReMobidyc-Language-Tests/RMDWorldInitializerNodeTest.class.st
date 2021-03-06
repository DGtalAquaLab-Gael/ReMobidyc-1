Class {
	#name : #RMDWorldInitializerNodeTest,
	#superclass : #RMDSyntaxNodeTest,
	#category : #'ReMobidyc-Language-Tests'
}

{ #category : #tests }
RMDWorldInitializerNodeTest >> testCopyReplace [
	| node replacement |
	node := parser worldInitializer end
		parse:
			'World with
	temperature = 30 [C]'.
	replacement := Dictionary new
		at: 'temperature' put: 'temp';
		at: (parser expression end parse: '30 [C]')
			put: (parser expression end parse: '100 [F]');
		yourself.
	self
		assert: (node copyReplace: replacement)
		equals:
			(parser worldInitializer end
				parse:
					'World with
	temp = 100 [F]')
]
