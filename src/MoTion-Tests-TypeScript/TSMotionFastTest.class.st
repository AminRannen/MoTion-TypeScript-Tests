Class {
	#name : 'TSMotionFastTest',
	#superclass : 'TestCase',
	#instVars : [
		'parser',
		'tree'
	],
	#category : 'MoTion-Tests-TypeScript',
	#package : 'MoTion-Tests-TypeScript'
}

{ #category : 'running' }
TSMotionFastTest >> setUp [
    parser := FASTTypeScriptParser new.
]

{ #category : 'tests' }
TSMotionFastTest >> testClassHasAtLeastThreeMethods2 [
    | res pattern results |
    res := parser parse: 'class MyClass {
        method1() { }
        method2() { }
        method3() { }
    }'.
    
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptMethodDefinition % {} as: #method)
    }.
    
    results := pattern collectBindings: {#method} for: (res allWithType: FASTTypeScriptClassDeclaration) first.
    
    self assert: results size >= 3.
]

{ #category : 'tests' }
TSMotionFastTest >> testClassHasConstructor [
    | res pattern results |
    res := parser parse: 'class MyClass {
        constructor() { }
    }'.
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptMethodDefinition % {
            #'children*' <=> (FASTTypeScriptPropertyIdentifier % {
                #name <=> 'constructor'
            } as: #constructor)
        })
    }.
    results := pattern collectBindings: {#constructor} for: (res allWithType: FASTTypeScriptClassDeclaration) first.
    self assert: results isEmpty not.
]

{ #category : 'tests' }
TSMotionFastTest >> testClassInheritsFromAnother [
    | res pattern results |
    res := parser parse: 'class Animal { }
    class Dog extends Animal { }'.
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptClassHeritage % {} as: #heritage)
    }.
    results := pattern collectBindings: {#heritage} for: (res allWithType: FASTTypeScriptClassDeclaration) second.
    self assert: results isEmpty not.
]

{ #category : 'tests' }
TSMotionFastTest >> testClassIsEmptyFast [
  | res pattern results classBody |
    res := parser parse: 'class MyClass {
    }'.
    
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptClassBody % {} as: #body)
    }.
    
    results := pattern collectBindings: {#body} for: (res allWithType: FASTTypeScriptClassDeclaration) first.
    classBody := results first at: #body.
    
    self assert: classBody children isEmpty.
 
]

{ #category : 'tests' }
TSMotionFastTest >> testMethodContainsSwitchCaseFast [
    | res pattern results |
    res := parser parse: 'class MyClass {
        myMethod(a: number) {
            switch(a) {
                case 1:
                    return "one";
                case 2:
                    return "two";
            }
        }
    }'.
    
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptSwitchStatement % {} as: #switch)
    }.
    
    results := pattern collectBindings: {#switch} for: (res allWithType: FASTTypeScriptClassDeclaration) first.
    
    self assert: results isEmpty not.
]

{ #category : 'tests' }
TSMotionFastTest >> testMethodHasForLoop [
    | res pattern results |
    res := parser parse: 'class MyClass {
        myMethod() {
            for (let i = 0; i < 10; i++) { }
        }
    }'.
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptForStatement % {} as: #forloop)
    }.
    results := pattern collectBindings: {#forloop} for: (res allWithType: FASTTypeScriptClassDeclaration) first.
    self assert: results isEmpty not.
]

{ #category : 'tests' }
TSMotionFastTest >> testMethodHasIfStatement [
    | res pattern results |
    res := parser parse: 'class MyClass {
        myMethod(x: number) {
            if (x > 0) { return 1; }
            else { return 0; }
        }
    }'.
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptIfStatement % {} as: #ifst)
    }.
    results := pattern collectBindings: {#ifst} for: (res allWithType: FASTTypeScriptClassDeclaration) first.
    self assert: results isEmpty not.
]

{ #category : 'tests' }
TSMotionFastTest >> testMethodHasParametersFast [
    | res pattern results formalParams hasParams |
    res := parser parse:   
    'class MyClass {
        myMethod(a: number, b: string) {
            return a;
        }
    }'.
    
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptFormalParameters % {} as: #params)
    }.
    
    results := pattern collectBindings: {#params} for: (res allWithType: FASTTypeScriptClassDeclaration) first.
    formalParams := results first at: #params.
    hasParams := formalParams children isEmpty not.
    
    self assert: hasParams.
]

{ #category : 'tests' }
TSMotionFastTest >> testMethodHasReturnStatement [
    | res pattern results |
    res := parser parse: 'class MyClass {
        myMethod() { return 42; }
    }'.
    
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptMethodDefinition % {
            #'children*' <=> (FASTTypeScriptReturnStatement % {} as: #ret)
        })
    }.
    
    results := pattern collectBindings: {#ret} for: (res allWithType: FASTTypeScriptClassDeclaration) first.
    
    self assert: results isEmpty not.
]

{ #category : 'tests' }
TSMotionFastTest >> testMethodHasReturnStatementUsingMatch [
    | res pattern results |
    res := parser parse: 'class MyClass {
        myMethod() { return 42; }
    }'.
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptReturnStatement % {} as: #ret)
    }.
    results := pattern match: (res allWithType: FASTTypeScriptClassDeclaration) first.
    self assert: results isMatch.
]

{ #category : 'tests' }
TSMotionFastTest >> testMethodHasTryCatch [
    | res pattern results |
    res := parser parse: 'class MyClass {
        myMethod() {
            try { } catch(e) { }
        }
    }'.
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptTryStatement % {} as: #tryst)
    }.
    results := pattern collectBindings: {#tryst} for: (res allWithType: FASTTypeScriptClassDeclaration) first.
    self assert: results isEmpty not.
]

{ #category : 'tests' }
TSMotionFastTest >> testMethodIsInvokedInClassBodyFast [
    | res pattern results |
    res := parser parse: 'class MyClass {
        myMethod() {
            return 1;
        }
        otherMethod() {
            this.myMethod();
        }
    }'.
    
    pattern := FASTTypeScriptClassDeclaration % {
        #'children*' <=> (FASTTypeScriptCallExpression % {} as: #invocation)
    }.
    
    results := pattern collectBindings: {#invocation} for: (res allWithType: FASTTypeScriptClassDeclaration) first.
    
    self assert: results isEmpty not.
]
