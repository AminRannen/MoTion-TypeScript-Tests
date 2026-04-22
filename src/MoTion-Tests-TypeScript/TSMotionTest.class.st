Class {
	#name : 'TSMotionTest',
	#superclass : 'TestCase',
	#instVars : [
		'parser',
		'tree'
	],
	#category : 'MoTion-Tests-TypeScript',
	#package : 'MoTion-Tests-TypeScript'
}

{ #category : 'running' }
TSMotionTest >> setUp [
    parser := TSParser new.
    parser language: TSLanguage typescript.
]

{ #category : 'tests' }
TSMotionTest >> testClassHasAtLeastThreeMethods [
    | pattern results |
    tree := parser parseString: 
    'class MyClass {
        method1() { }
        method2() { }
        method3() { }
    }'.
    pattern := TSNode % {
        #'namedChildren*' <=> (TSNode % {
            #type <=> 'method_definition'
        } as: #method)
    }.
    results := pattern collectBindings: {#method} for: tree rootNode.
    self assert: results size >= 3.
]

{ #category : 'tests' }
TSMotionTest >> testClassIsEmpty [
    | pattern results classBody |
    tree := parser parseString: 
    'class MyClass {
    }'.
    pattern := TSNode % {
        #'namedChildren*' <=> (TSNode % {
            #type <=> 'class_body'
        } as: #body)
    }.
    results := pattern collectBindings: {#body} for: tree rootNode.
    classBody := results first at: #body.
    self assert: classBody namedChildren isEmpty.
]

{ #category : 'tests' }
TSMotionTest >> testMethodContainsSwitchCase [
    | pattern results |
    tree := parser parseString: 
    'class MyClass {
        myMethod(a: number) {
            switch(a) {
                case 1:
                    return "one";
                case 2:
                    return "two";
            }
        }
    }'.
    pattern := TSNode % {
        #'namedChildren*' <=> (TSNode % {
            #type <=> 'switch_statement'
        } as: #switch)
    }.
    results := pattern collectBindings: {#switch} for: tree rootNode.
    self assert: results isEmpty not.
]

{ #category : 'tests' }
TSMotionTest >> testMethodHasParameters [
    | pattern results method formalParams hasParams |
    tree := parser parseString: 
    'class MyClass {
        myMethod(a: number, b: string) {
            return a;
        }
    }'.
    pattern := TSNode % {
        #'namedChildren*' <=> (TSNode % {
            #type <=> 'method_definition'
        } as: #method)
    }.
    results := pattern collectBindings: {#method} for: tree rootNode.
    method := results first at: #method.
    formalParams := method namedChildren detect: [:child | child type = 'formal_parameters'].
    hasParams := formalParams namedChildren isEmpty not.
    self assert: hasParams.
]

{ #category : 'tests' }
TSMotionTest >> testMethodIsInvokedInClassBody [
    | pattern results |
    tree := parser parseString: 
    'class MyClass {
        myMethod() {
            return 1;
        }
        
        otherMethod() {
            this.myMethod();
        }
    }'.
    
    pattern := TSNode % {
        #'namedChildren*' <=> (TSNode % {
            #type <=> 'call_expression'
        } as: #invocation)
    }.
    
    results := pattern collectBindings: {#invocation} for: tree rootNode.
    
    self assert: results isEmpty not.
]
