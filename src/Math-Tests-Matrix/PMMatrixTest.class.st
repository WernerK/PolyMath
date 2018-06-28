Class {
	#name : #PMMatrixTest,
	#superclass : #TestCase,
	#category : 'Math-Tests-Matrix'
}

{ #category : #'linear algebra' }
PMMatrixTest >> testAtRowPutAtColumnPut [
	| a |
	a := PMMatrix rows: #(#(11 12 13) #(21 22 23)).
	a atRow: 1 put: (a rowAt: 2).
	self assert: a equals: (PMMatrix rows: #(#(21 22 23) #(21 22 23))).
	a atColumn: 3 put: (a columnAt: 2).
	self assert: a equals: (PMMatrix rows: #(#(21 22 22) #(21 22 22))).
	a := PMSymmetricMatrix rows: #(#(11 12) #(21 22)).
	self should: [ a atRow: 1 put: (a rowAt: 2) ] raise: Error.
	self should: [ a atColumn: 1 put: (a rowAt: 2) ] raise: Error
]

{ #category : #collection }
PMMatrixTest >> testCollect [
	self assert: ((PMMatrix rows: #((1 2) (3 4))) collect: [ :x | 2 * x ]) equals: (PMMatrix rows: #((2 4) ( 6 8)))
]

{ #category : #'linear algebra' }
PMMatrixTest >> testDeterminant [
	| m |
	m := PMMatrix rows: #(#(3 2 4) #(2 -5 -1) #(1 -2 2)).
	self assert: m determinant equals: -42
]

{ #category : #'linear algebra' }
PMMatrixTest >> testDimension [
	| a | 
	a := PMMatrix rows: #( ( 1 0 1) (-1 -2 3)).	
	self assert: a dimension equals: 2@3.
	
]

{ #category : #'linear algebra' }
PMMatrixTest >> testEigenvalues [
	"Code Example 8.15"

	| m charPol roots eigenvalues finder |
	m := PMMatrix rows: #(#(3 -2 0) #(-2 7 1) #(0 1 5)).
	charPol := PMPolynomial coefficients: #(82 -66 15 -1).
	roots := charPol roots asSortedCollection asArray reverse.
	finder := PMJacobiTransformation matrix: m.
	finder desiredPrecision: 1.0e-09.
	eigenvalues := finder evaluate.
	self assert: eigenvalues size equals: 3.
	self assert: ((roots at: 1) - (eigenvalues at: 1)) abs < 1.0e-09.
	self assert: ((roots at: 2) - (eigenvalues at: 2)) abs < 1.0e-09.
	self assert: ((roots at: 3) - (eigenvalues at: 3)) abs < 1.0e-09
]

{ #category : #'linear algebra' }
PMMatrixTest >> testEigenvaluesLargest [
	"Code Example 8.13"

	| m charPol roots eigenvalue finder |
	m := PMMatrix rows: #(#(3 -2 0) #(-2 7 1) #(0 1 5)).
	charPol := PMPolynomial coefficients: #(82 -66 15 -1).
	roots := charPol roots asSortedCollection asArray reverse.
	finder := PMLargestEigenValueFinder matrix: m.
	finder desiredPrecision: 1.0e-08.
	eigenvalue := finder evaluate.
	self assert: ((roots at: 1) - eigenvalue) abs < 1.0e-08.
	finder := finder nextLargestEigenValueFinder.
	eigenvalue := finder evaluate.
	self assert: ((roots at: 2) - eigenvalue) abs < 1.0e-08
]

{ #category : #'linear algebra' }
PMMatrixTest >> testLUPDecomposition [
	"Code Example 8.10"

	| s sol1 sol2 |
	s := PMLUPDecomposition equations: #(#(3 2 4) #(2 -5 -1) #(1 -2 2)).
	sol1 := s solve: #(16 6 10).
	sol2 := s solve: #(7 10 9).
	self assert: sol1 size equals: 3.
	self assert: (sol1 at: 1) equals: 2.
	self assert: (sol1 at: 2) equals: -1.
	self assert: (sol1 at: 3) equals: 3.
	self assert: sol2 size equals: 3.
	self assert: (sol2 at: 1) equals: 1.
	self assert: (sol2 at: 2) equals: -2.
	self assert: (sol2 at: 3) equals: 2
]

{ #category : #'linear algebra' }
PMMatrixTest >> testLinearEquations [
	"Code Example 8.6"

	| s sol1 sol2 |
	s := PMLinearEquationSystem
		equations: #(#(3 2 4) #(2 -5 -1) #(1 -2 2))
		constants: #(#(16 6 10) #(7 10 9)).
	sol1 := s solutionAt: 1.
	sol2 := s solutionAt: 2.
	self assert: sol1 size equals: 3.
	self assert: (sol1 at: 1) equals: 2.
	self assert: (sol1 at: 2) equals: -1.
	self assert: (sol1 at: 3) equals: 3.
	self assert: sol2 size equals: 3.
	self assert: (sol2 at: 1) equals: 1.
	self assert: (sol2 at: 2) equals: -2.
	self assert: (sol2 at: 3) equals: 2
]

{ #category : #'linear algebra' }
PMMatrixTest >> testLinearEquationsSingle [
	| s sol |
	s := PMLinearEquationSystem
		equations: #(#(1 2 0) #(3 5 4) #(5 6 3))
		constant: #(0.1 12.5 10.3).
	sol := s solution.
	self assert: sol size equals: 3.
	self assert: ((sol at: 1) equalsTo: 0.5).
	self assert: ((sol at: 2) equalsTo: -0.2).
	self assert: ((sol at: 3) equalsTo: 3.0)
]

{ #category : #'linear algebra' }
PMMatrixTest >> testLinearEquationsSingular [
	| s sol |
	s := PMLinearEquationSystem
		equations: #(#(1 2 0) #(10 12 6) #(5 6 3))
		constant: #(0.1 12.5 10.3).
	sol := s solution.
	self assert: sol isNil
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixAdd [
	| a b c |
	a := PMMatrix rows: #(#(1 0 1) #(-1 -2 3)).
	b := PMMatrix rows: #(#(1 2 3) #(-2 1 7)).
	c := a + b.
	self assert: c numberOfRows equals: 2.
	self assert: c numberOfColumns equals: 3.
	self assert: ((c rowAt: 1) at: 1) equals: 2.
	self assert: ((c rowAt: 1) at: 2) equals: 2.
	self assert: ((c rowAt: 1) at: 3) equals: 4.
	self assert: ((c rowAt: 2) at: 1) equals: -3.
	self assert: ((c rowAt: 2) at: 2) equals: -1.
	self assert: ((c rowAt: 2) at: 3) equals: 10
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixAddSizeMismatch [
	| a b |
	"Matrices of different dimensions should signal SizeMismatch on #+."
	a := PMMatrix rows: #(#(1 2) #(3 4)).
	b := PMMatrix rows: #(#(1 2)).
	self should: [ a + b ] raise: SizeMismatch.
	self should: [ b + a ] raise: SizeMismatch.
	self should: [ a + b transpose ] raise: SizeMismatch.
	self should: [ b transpose + a ] raise: SizeMismatch
]

{ #category : #comparing }
PMMatrixTest >> testMatrixCloseTo [
	self assert: ((PMMatrix rows: #(#(1.00001 2.00002) #(3.00001 4.00002))) closeTo: (PMMatrix rows: #(#(1.00002 2.00001) #(3.00002 4.00001)))).
	self assert: (PMMatrix rows: #(#(1.00001 2.00002) #(3.00001 4.00002))) closeTo: (PMMatrix rows: #(#(1.00002 2.00001) #(3.00002 4.00001))).	"Double check that the TestAsserter >> #assert:closeTo: functions properly here."
		self deny: ((PMMatrix rows: #(#(1.00001 2.00004) #(3.00001 4.00004))) closeTo: (PMMatrix rows: #(#(1.00004 2.00001) #(3.00004 4.00001)))).
]

{ #category : #comparing }
PMMatrixTest >> testMatrixCloseToPrecision [
	| a b |
	a := PMMatrix rows: #(#(1.2 2.4) #(1.2 2.4)).
	b := PMMatrix rows: #(#(1.4 2.2) #(1.4 2.2)).
	self assert: (a closeTo: b precision: 1.0).
	self deny: (a closeTo: b precision: 0.6).
	self deny: (a closeTo: b precision: 0.2)
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixCumulativeSum [
	| a b |
	a := PMMatrix rows: #(#(1 0 1) #(-1 -2 3)).
	b := a cumsum.
	self assert: b numberOfRows equals: 2.
	self assert: b numberOfColumns equals: 3.
	self assert: ((b rowAt: 1) at: 1) equals: 1.
	self assert: ((b rowAt: 1) at: 2) equals: 1.
	self assert: ((b rowAt: 1) at: 3) equals: 2.
	self assert: ((b rowAt: 2) at: 1) equals: -1.
	self assert: ((b rowAt: 2) at: 2) equals: -3.
	self assert: ((b rowAt: 2) at: 3) equals: 0
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixDo [
	| a |
	a := PMMatrix rows: #(#(1 2 3) #(1 2 3) #(1 2 3)).
	a rowsDo: [ :row | row at: 1 put: 0 ].
	self assert: (a rowAt: 1 columnAt: 1) equals: 0.
	a columnsDo: [ :col | a atRow: 1 put: col ].
	self assert: (a rowAt: 1) equals: #(2 3 3) asPMVector
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixElementwiseAdd [
	| a b |
	a := PMMatrix rows: #(#(1 2) #(3 4)).
	b := PMMatrix rows: #(#(2 3) #(4 5)).
	self assert: a + 0 equals: a.
	self assert: 0 + a equals: a.
	self assert: a + 1 equals: b.
	self assert: 1 + a equals: b.
	self assert: -1 + b equals: a.
	self assert: b + -1 equals: a.
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixEquality [
	| a c |
	a := PMMatrix rows: #(#(1 0 1) #(-1 -2 3)).
	c := a.
	self assert: c numberOfRows equals: a numberOfRows.
	self assert: c numberOfColumns equals: a numberOfColumns.
	self assert: (c = a and: [ a = c ])
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixExtensions [
	"testing at:at: and at:at:put:"

	| a c |
	a := PMMatrix rows: #(#(1 0 1) #(-1 -2 3)).
	c := a deepCopy.
	self assert: (c at: 1 at: 1) equals: (a at: 1 at: 1).
	a at: 1 at: 1 put: 42.
	self shouldnt: [ (c at: 1 at: 1) = (a at: 1 at: 1) ]
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixExtensionsAtColumn [
	"testing at:at: and at:at:put:"

	| a c |
	a := PMMatrix rows: #(#(11 12 13) #(21 22 23)).
	c := a deepCopy.
	self assert: (c at: 1 at: 1) equals: (a at: 1 at: 1).
	c atColumn: 1 put: (a atColumn: 2).
	self shouldnt: [ (c at: 1 at: 1) = (a at: 1 at: 1) ].
	self assert: (c at: 1 at: 1) equals: (a at: 1 at: 2).
	c := a deepCopy.
	c at: 1 at: 1 put: (a at: 1 at: 2).
	c atColumn: 1 put: (a atColumn: 2) startingAt: 1.
	self assert: (c at: 2 at: 1) equals: (a at: 1 at: 2).
	self shouldnt: [ (c at: 1 at: 1) = (a at: 1 at: 1) ]
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixExtensionsAtRow [
	"testing at:at: and at:at:put:"

	| a c |
	a := PMMatrix rows: #(#(11 12 13) #(21 22 23)).
	c := a deepCopy.
	self assert: (c at: 1 at: 1) equals: (a at: 1 at: 1).
	c atRow: 1 put: (a rowAt: 2).
	self shouldnt: [ (c at: 1 at: 1) = (a at: 1 at: 1) ].
	self assert: (c at: 1 at: 1) equals: (a at: 2 at: 1).
	c := a deepCopy.
	c atRow: 1 put: (a rowAt: 2) startingAt: 1.
	self assert: (c at: 1 at: 2) equals: (a at: 2 at: 1).
	self shouldnt: [ (c at: 1 at: 2) = (a at: 1 at: 2) ]
]

{ #category : #comparing }
PMMatrixTest >> testMatrixGreater [
	| a b |
	a := PMMatrix rows: #(#(1 -1 2) #(-4 0 1)).
	b := a > 0.
	self assert: b numberOfRows equals: 2.
	self assert: b numberOfColumns equals: 3.
	self assert: ((b rowAt: 1) at: 1) equals: true.
	self assert: ((b rowAt: 1) at: 2) equals: false.
	self assert: ((b rowAt: 1) at: 3) equals: true.
	self assert: ((b rowAt: 2) at: 1) equals: false.
	self assert: ((b rowAt: 2) at: 2) equals: false.
	self assert: ((b rowAt: 2) at: 3) equals: true
]

{ #category : #comparing }
PMMatrixTest >> testMatrixHash [
	| a b c |
	a := PMMatrix rows: #(#(1 0) #(0 1)).
	b := a deepCopy.
	self assert: a hash equals: b hash.
	c := a + b.
	self shouldnt: [ a hash = c hash ]
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixInitialize [
	| a |
	a := PMMatrix new initialize: 2.
	self assert: a numberOfRows equals: 2.
	self assert: a numberOfColumns equals: 2
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixInversionSmall [
	| m c |
	m := PMMatrix rows: #(#(3 2 4) #(2 -5 -1) #(1 -2 2)).
	c := m inverse * m.
	self assert: c numberOfRows equals: 3.
	self assert: c numberOfColumns equals: 3.
	self assert: ((c rowAt: 1) at: 1) equals: 1.
	self assert: ((c rowAt: 1) at: 2) equals: 0.
	self assert: ((c rowAt: 1) at: 3) equals: 0.
	self assert: ((c rowAt: 2) at: 1) equals: 0.
	self assert: ((c rowAt: 2) at: 2) equals: 1.
	self assert: ((c rowAt: 2) at: 3) equals: 0.
	self assert: ((c rowAt: 3) at: 1) equals: 0.
	self assert: ((c rowAt: 3) at: 2) equals: 0.
	self assert: ((c rowAt: 3) at: 3) equals: 1
]

{ #category : #comparing }
PMMatrixTest >> testMatrixLess [
	| a b |
	a := PMMatrix rows: #(#(1 -1 2) #(-4 0 1)).
	b := a < 0.
	self assert: b numberOfRows equals: 2.
	self assert: b numberOfColumns equals: 3.
	self assert: ((b rowAt: 1) at: 1) equals: false.
	self assert: ((b rowAt: 1) at: 2) equals: true.
	self assert: ((b rowAt: 1) at: 3) equals: false.
	self assert: ((b rowAt: 2) at: 1) equals: true.
	self assert: ((b rowAt: 2) at: 2) equals: false.
	self assert: ((b rowAt: 2) at: 3) equals: false
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixMultiply [
	"Code Example 8.1"

	| a b c |
	a := PMMatrix rows: #(#(1 0 1) #(-1 -2 3)).
	b := PMMatrix rows: #(#(1 2 3) #(-2 1 7) #(5 6 7)).
	c := a * b.
	self assert: c numberOfRows equals: 2.
	self assert: c numberOfColumns equals: 3.
	self assert: ((c rowAt: 1) at: 1) equals: 6.
	self assert: ((c rowAt: 1) at: 2) equals: 8.
	self assert: ((c rowAt: 1) at: 3) equals: 10.
	self assert: ((c rowAt: 2) at: 1) equals: 18.
	self assert: ((c rowAt: 2) at: 2) equals: 14.
	self assert: ((c rowAt: 2) at: 3) equals: 4
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixMultiplyElementwise [
	"Code Example 8.1"

	| a b c |
	a := PMMatrix rows: #(#(1 0 1) #(-1 -2 3)).
	b := PMMatrix rows: #(#(1 2 3) #(-2 1 7)).
	c := a dot:b.
	self assert: c numberOfRows equals: 2.
	self assert: c numberOfColumns equals: 3.
	self assert: ((c rowAt: 1) at: 1) equals: 1.
	self assert: ((c rowAt: 1) at: 2) equals: 0.
	self assert: ((c rowAt: 1) at: 3) equals: 3.
	self assert: ((c rowAt: 2) at: 1) equals: 2.
	self assert: ((c rowAt: 2) at: 2) equals: -2.
	self assert: ((c rowAt: 2) at: 3) equals: 21
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixSubtract [
	| a b c |
	a := PMMatrix rows: #(#(1 0 1) #(-1 -2 3)).
	b := PMMatrix rows: #(#(1 2 3) #(-2 1 7)).
	c := a - b.
	self assert: c numberOfRows equals: 2.
	self assert: c numberOfColumns equals: 3.
	self assert: ((c rowAt: 1) at: 1) equals: 0.
	self assert: ((c rowAt: 1) at: 2) equals: -2.
	self assert: ((c rowAt: 1) at: 3) equals: -2.
	self assert: ((c rowAt: 2) at: 1) equals: 1.
	self assert: ((c rowAt: 2) at: 2) equals: -3.
	self assert: ((c rowAt: 2) at: 3) equals: -4
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixSum [
	"Code Example 8.1"

	| a v |
	a := PMMatrix rows: #(#(1 0 1) #(-1 -2 3)).
	v := a sum.
	self assert: v size equals: 2.
	self assert: (v at: 1) equals: 2.
	self assert: (v at: 2) equals: 0
]

{ #category : #'linear algebra' }
PMMatrixTest >> testMatrixTrace [
	| a |
	a := PMMatrix rows: #(#(1 2 3) #(4 5 6) #(7 8 9)).
	self assert: a tr equals: 15
]

{ #category : #tests }
PMMatrixTest >> testOnesMatrix [
	| a |
	a := PMMatrix onesRows: 2 cols: 3.
	self assert: a numberOfRows equals: 2.
	self assert: a numberOfColumns equals: 3.
	self assert: ((a rowAt: 1) at: 1) equals: 1.
	self assert: ((a rowAt: 1) at: 2) equals: 1.
	self assert: ((a rowAt: 1) at: 3) equals: 1.
	self assert: ((a rowAt: 2) at: 1) equals: 1.
	self assert: ((a rowAt: 2) at: 2) equals: 1.
	self assert: ((a rowAt: 2) at: 3) equals: 1
]

{ #category : #tests }
PMMatrixTest >> testPrintOn [
	| m stream |
	stream := String new writeStream.
	m := PMMatrix new.
	"this raised an error:"
	self shouldnt: [m printOn: stream] raise: Error 
]

{ #category : #tests }
PMMatrixTest >> testSimpleMatrixOperations [
	| s m s2 r r2 |
	"a mix of unsymmetric and symmetric matrices"
	m := PMMatrix rows: #(#(1 2 3) #(-1 -2 7) #(5 6 7)).
	s := PMSymmetricMatrix rows: #(#(1 2 3) #(2 1 4) #(3 4 0)).
	s2 := PMSymmetricMatrix rows: #(#(1 2 0) #(2 1 4) #(0 4 0)).
	"just to be sure that s and s2 are indeed symmetric:"
	self assert: s equals: s transpose.
	self assert: s2 equals: s2 transpose.
	r := m * s.
	self
		assert: r
		equals: (PMMatrix rows: #(#(14 16 11) #(16 24 -11) #(38 44 39))).
	self assert: r class equals: PMMatrix.
	r := s * m.
	self
		assert: r
		equals: (PMMatrix rows: #(#(14 16 38) #(21 26 41) #(-1 -2 37))).
	self assert: r class equals: PMMatrix.
	r := s * s2.
	self deny: r = r transpose.	"hence this (here is the bug) must be true:"
	self assert: r class equals: PMMatrix.
	self
		assert: r
		equals: (PMMatrix rows: #(#(5 16 8) #(4 21 4) #(11 10 16))).
	r := s transposeProductWithMatrix: s2.
	self deny: r = r transpose.	"hence this must be true:"
	self assert: r class equals: PMMatrix.
	r := s productWithTransposeMatrix: s2.
	self deny: r = r transpose.	"hence this must be true:"
	self assert: r class equals: PMMatrix.
	self assert: s * s equals: s squared.
	self assert: m transpose * m equals: m squared.
	self assert: (r := m + s) equals: (r2 := s + m).
	self assert: r class equals: PMMatrix.
	self assert: r2 class equals: PMMatrix.
	r2 := PMMatrix rows: #(#(0 0 0) #(-3 -3 3) #(2 2 7)).
	self assert: (r := m - s) equals: r2.
	self assert: r class equals: PMMatrix.
	r := (s - m) negate.
	self assert: r equals: r2.
	self assert: r class equals: PMMatrix.
	self assert: (r := s2 + s) equals: s + s2.
	self assert: r class equals: PMSymmetricMatrix.
	self assert: (r := s2 - s) equals: (s - s2) negate.
	self assert: r class equals: PMSymmetricMatrix.
	m := PMMatrix rows: #(#(-1 -2 7) #(5 6 7)).
	self assert: m * s equals: (s * m transpose) transpose.
	self assert: m transpose * m equals: m squared
]

{ #category : #'linear algebra' }
PMMatrixTest >> testSingularMatrixError [
|h f|
h:=PMHistogram new.
h freeExtent: true.
1 to: 3 do:  [:i| h accumulate: i ].
f:=PMLeastSquareFit histogram: h distributionClass: PMTriangularDistribution.
self should: [ f evaluate ] raise: PMSingularMatrixError .
"and not something completely incomprehensible"
"also here:"
self should: [ f errorMatrix ] raise: PMSingularMatrixError .
self should: [(PMMatrix rows: #((1 2 3)(3 4 6)))inverse] raise: PMSingularMatrixError .
self should: [(PMSymmetricMatrix rows: #((1 2 3)(2 2 2)(3 2 1)))inversePureLUP] raise: PMSingularMatrixError.
self should: [(PMSymmetricMatrix rows: #((1 2 3)(2 2 2)(3 2 1)))inversePureCRL] raise: PMSingularMatrixError.
]

{ #category : #tests }
PMMatrixTest >> testSkalarMultiplication [
	| a r |
	a := PMMatrix rows: #(#(1 2) #(3 3)).
	"this was intended by the author to be possible; it can be seen by the code and the book:"
	r := a * 2.
	self assert: r class equals: PMMatrix.
	self assert: r equals: (PMMatrix rows: #(#(2 4) #(6 6))).
	self assert: 2 * a equals: r.
	a := PMSymmetricMatrix rows: #(#(1 2) #(2 1)).
	r := a * 2.
	self assert: r equals: (PMMatrix rows: #(#(2 4) #(4 2))).
	self assert: r class equals: PMSymmetricMatrix.
	r := 2.0 * a.
	self assert: r equals: (PMMatrix rows: #(#(2.0 4.0) #(4.0 2.0))).
	self assert: r class equals: PMSymmetricMatrix
]

{ #category : #tests }
PMMatrixTest >> testSymmetric [
|a m|
a:=#(1 2 3)asPMVector.
m:=PMMatrix rows: #((1 2)(3 3)).
self deny: (m isSymmetric ).
"but a PMMatrix can of course also be symmetric, 
and it is occasionally interesting to know, 
hence the result should be correct"
m:=PMMatrix rows: (a tensorProduct: a)rows.
self assert: (m isSymmetric ).


]

{ #category : #'linear algebra' }
PMMatrixTest >> testSymmetricMatrixAdd [
	| a b c |
	a := (PMMatrix rows: #(#(11 12 13) #(12 22 23) #(13 23 33)))
		asSymmetricMatrix.
	b := PMMatrix rows: #(#(1 2 3) #(-2 1 7) #(0 0 0)).
	c := a + b.
	self assert: c numberOfRows equals: 3.
	self assert: c numberOfColumns equals: 3.
	self assert: ((c rowAt: 1) at: 1) equals: 12.
	self assert: ((c rowAt: 1) at: 2) equals: 14.
	self assert: ((c rowAt: 1) at: 3) equals: 16
]

{ #category : #'linear algebra' }
PMMatrixTest >> testSymmetricMatrixAdd2 [
	| a b c |
	a := PMSymmetricMatrix rows: #(#(11 12 13) #(12 22 23) #(13 23 33)).
	b := PMSymmetricMatrix rows: #(#(1 2 3) #(2 1 7) #(3 7 0)).
	c := a + b.
	self assert: c numberOfRows equals: 3.
	self assert: c numberOfColumns equals: 3.
	self assert: ((c rowAt: 1) at: 1) equals: 12.
	self assert: ((c rowAt: 1) at: 2) equals: 14.
	self assert: ((c rowAt: 1) at: 3) equals: 16
]

{ #category : #'linear algebra' }
PMMatrixTest >> testSymmetricMatrixAdd3 [
	| a b c |
	a := PMMatrix rows: #(#(11 12 13) #(21 22 23) #(31 32 33)).
	b := PMSymmetricMatrix rows: #(#(1 2 3) #(-2 1 7) #(0 0 0)).
	c := a + b.
	self assert: c numberOfRows equals: 3.
	self assert: c numberOfColumns equals: 3.
	self assert: ((c rowAt: 1) at: 1) equals: 12.
	self assert: ((c rowAt: 1) at: 2) equals: 14.
	self assert: ((c rowAt: 1) at: 3) equals: 16.
	self assert: ((c rowAt: 2) at: 1) equals: 19.
	self assert: ((c rowAt: 2) at: 2) equals: 23.
	self assert: ((c rowAt: 2) at: 3) equals: 30.
	self assert: ((c rowAt: 3) at: 1) equals: 31
]

{ #category : #'linear algebra' }
PMMatrixTest >> testVectorMatrixOperation [
	"Code Example 8.1"

	| a u v |
	a := PMMatrix rows: #(#(1 0 1) #(-1 -2 3)).
	u := #(1 2 3) asPMVector.
	v := a * u.
	self assert: v size equals: 2.
	self assert: (v at: 1) equals: 4.
	self assert: (v at: 2) equals: 4
]

{ #category : #'linear algebra' }
PMMatrixTest >> testVectorTransposeMatrixOperation [
	"Code Example 8.1"

	| c v w |
	c := PMMatrix rows: #(#(6 8 10) #(18 14 4)).
	v := #(4 4) asPMVector.
	w := c transpose * v.
	self assert: w size equals: 3.
	self assert: (w at: 1) equals: 96.
	self assert: (w at: 2) equals: 88.
	self assert: (w at: 3) equals: 56
]

{ #category : #tests }
PMMatrixTest >> testZerosMatrix [
|a|
	a:=PMMatrix zerosRows: 2 cols: 3.
	self assert: a numberOfRows equals: 2.
	self assert: a numberOfColumns equals: 3.
	self assert: ((a rowAt: 1) at: 1) equals: 0.
	self assert: ((a rowAt: 1) at: 2) equals: 0.
	self assert: ((a rowAt: 1) at: 3) equals: 0.
	self assert: ((a rowAt: 2) at: 1) equals: 0.
	self assert: ((a rowAt: 2) at: 2) equals: 0.
	self assert: ((a rowAt: 2) at: 3) equals: 0




]