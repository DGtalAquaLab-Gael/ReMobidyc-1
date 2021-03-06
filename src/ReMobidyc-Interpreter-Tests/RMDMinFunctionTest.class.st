Class {
	#name : #RMDMinFunctionTest,
	#superclass : #TestCase,
	#instVars : [
		'min'
	],
	#category : #'ReMobidyc-Interpreter-Tests'
}

{ #category : #running }
RMDMinFunctionTest >> setUp [
	min := RMDMinFunction new
]

{ #category : #tests }
RMDMinFunctionTest >> testValue [
	self assert: (min value: 10) equals: 10
]

{ #category : #tests }
RMDMinFunctionTest >> testValueValue [
	self assert: (min value: 10 value: 20) equals: 10
]

{ #category : #tests }
RMDMinFunctionTest >> testValueValueValue [
	self assert: (min value: 10 value: 20 value: 15) equals: 10
]

{ #category : #tests }
RMDMinFunctionTest >> testValueValueValueValue [
	self assert: (min value: 10 value: 20 value: 15 value: -10) equals: -10
]

{ #category : #tests }
RMDMinFunctionTest >> testValueWithArguments [
	self assert: (min valueWithArguments: #(10 20 15 -10)) equals: -10
]
