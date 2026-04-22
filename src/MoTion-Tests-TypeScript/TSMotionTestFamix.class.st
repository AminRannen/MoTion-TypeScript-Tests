Class {
	#name : 'TSMotionTestFamix',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'MoTion-Tests-TypeScript',
	#package : 'MoTion-Tests-TypeScript'
}

{ #category : 'running' }
TSMotionTestFamix >> setUp [
    model := MooseModel root first.
]

{ #category : 'tests' }
TSMotionTestFamix >> testClassHasAtLeastThreeMethodsFamix [
    | cls pattern results |
    cls := model allModelClasses first.
    pattern := FamixTypeScriptClass % {
        #methods <=> (FamixTypeScriptMethod % {} as: #method)
    }.
    results := pattern collectBindings: {#method} for: cls.
    self assert: results size >= 3.
]

{ #category : 'tests' }
TSMotionTestFamix >> testClassIsEmptyFamix [
    | cls |
    cls := model allModelClasses first.
    self assert: cls methods isEmpty not.
]

{ #category : 'tests' }
TSMotionTestFamix >> testMethodHasParametersFamix [
    | cls pattern results |
    cls := model allModelClasses first.
    pattern := FamixTypeScriptClass % {
        #methods <=> (FamixTypeScriptMethod % {
            #parameters <=> (FamixTypeScriptParameter % {} as: #param)
        })
    }.
    results := pattern collectBindings: {#param} for: cls.
    self assert: results isEmpty not.
]

{ #category : 'tests' }
TSMotionTestFamix >> testMethodIsInvokedFamix [
    | cls pattern results |
    cls := model allModelClasses first.
    pattern := FamixTypeScriptClass % {
        #receivingInvocations <=> (FamixTypeScriptInvocation % {} as: #invocation)
    }.
    results := pattern collectBindings: {#invocation} for: cls.
    self assert: results isEmpty not.
]
