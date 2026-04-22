Class {
	#name : 'TSMotionTestFamixSnake',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'MoTion-Tests-TypeScript',
	#package : 'MoTion-Tests-TypeScript'
}

{ #category : 'running' }
TSMotionTestFamixSnake >> setUp [
    model := MooseModel root third.
]

{ #category : 'as yet unclassified' }
TSMotionTestFamixSnake >> testClassHasAtLeast4Methods [
    | cls pattern results |
    cls := model allModelClasses at: 7.
    pattern := FamixTypeScriptClass % { 
        #methods <=> (FamixTypeScriptMethod % {} as: #method)         
    }.
    results := pattern collectBindings: { #method } for: cls. 
    self assert: results size >= 4.
]

{ #category : 'tests' }
TSMotionTestFamixSnake >> testSnakeClassHasAtLeast3Attributes [
   | cls pattern results |
    cls := model allModelClasses second.
    pattern := FamixTypeScriptClass % {
        #attributes <=> (FamixTypeScriptProperty  % {} as: #attribute)
    }.
    results := pattern collectBindings: {#attribute} for: cls.
    self assert: results size >= 3.
]

{ #category : 'tests' }
TSMotionTestFamixSnake >> testSnakeInheritsFromDrawable [
    | cls pattern results |
    cls := model allModelClasses detect: [:c | c name = 'Snake'].

    pattern := FamixTypeScriptClass % {
        #superInheritances <=> (FamixTypeScriptInheritance % {} as: #inheritance)
    }.

    results := pattern collectBindings: {#inheritance} for: cls.
    self assert: results isNotEmpty.
]
