"
Permutation is an Array, that - if it's reduced - consists of the numbers from (1 to: self size) in the original order.
example:
Permutation ordering: #(5 4 1). -> a Permutation(3 2 1)

you can think of a permutation as a positioning specification for a SequentialCollection.
another example:
a:=Permutation randomPermutation: 4. -> a Permutation(1 4 2 3)
a permute: #(a b cd e). -> #(#a #e #b #cd)
yet another one: 
Permutation ordering: #(a e b cd). ""a Permutation(1 4 2 3)""
 

"
Class {
	#name : #PMPermutation,
	#superclass : #Array,
	#type : #variable,
	#classVars : [
		'PrintAsCycles',
		'RandomGenerator',
		'ShowOneCycles'
	],
	#category : #'Math-Permutation'
}

{ #category : #accessing }
PMPermutation class >> allOfSize: anInteger [
"generates all permutations of the given size, in other words it produces the symmetric group of degree anInteger.
Heap's algorithm, used here, seems to be just a tiny bit faster than using #permutationsDo:"
	| result perm c i ci|
	anInteger = 0 ifTrue:[^#()].
	perm := self identity: anInteger.
	(result := WriteStream on:(Array new: anInteger factorial)) nextPut: perm copy.
	c := Array new: anInteger withAll: 1.
	i := 1.
	[ i <= anInteger ]
		whileTrue: [ 
			(ci :=(c at: i)) < i
				ifTrue: [ 
					i odd
						ifTrue: [ perm swap: 1 with: i ]
						ifFalse: [ perm swap: ci with: i ].
					result nextPut: perm copy.
					c at: i put: ci + 1.
					i := 1 ]
				ifFalse: [ c at: i put: 1. i := i + 1 ] ].
	^ result contents
]

{ #category : #'instance creation' }
PMPermutation class >> fromCycles: aCollectionofCollections [
	| length |
	length := self testCycles: aCollectionofCollections.
	length := length isEmpty 
		ifTrue: [ 0 ]
		ifFalse: [ length max ].
	^ self privateSize: length fromCycles: aCollectionofCollections
]

{ #category : #accessing }
PMPermutation class >> generator: arrayOfPermutations [
	| f max generators |
	arrayOfPermutations isCollection
		ifFalse: [ self error: 'argument of generator has to be a Collection of Permutations' ].
	max := (arrayOfPermutations
		collect: [ :g | 
			(g isKindOf: PMPermutation)
				ifFalse: [ self error: 'argument of generator has to be a Collection of Permutations' ].
			g size ]) max.
	generators := arrayOfPermutations collect: [ :g | g extendTo: max ].
	f := PMFixpoint
		block: [ :s | 
			| aSet |
			aSet := Set newFrom: s.
			s do: [ :p | s do: [ :q | aSet add: (p permute: q) ] ].
			aSet ]
		value: generators.
	f verbose: false.
	^ f evaluate asArray
]

{ #category : #'instance creation' }
PMPermutation class >> identity: size [
^ super withAll: (1 to: size) 
]

{ #category : #'instance creation' }
PMPermutation class >> newFrom: aCollection [
"returns the unreduced form, for a reduced form use #ordering:.
uses super withAll: since this way a primitive can be used, which is generally much faster than super newFrom:"
self testCycles: aCollection .
^( super withAll:  aCollection )
]

{ #category : #'instance creation' }
PMPermutation class >> ordering: aCollection [
"use #newFrom: for an unreduced Permutation! but then most things won't work before you call #reduce.
aCollection must consist of elements that can be sorted via #<="
^( super withAll:  aCollection ) reduce
]

{ #category : #setting }
PMPermutation class >> permutationSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #PMPermutation)
		label: #PMPermutation translated;
		description: 'essentially PrintIt settings';
		noOrdering.
	(aBuilder setting: #printAsCycles)
		target: self;
		parent: #PMPermutation;
		label: 'printAsCycles';
		description: 'decides whether printing should happen in cycle form'.
	(aBuilder setting: #showOneCycles)
		target: self;
		parent: #PMPermutation;
		label: 'showOneCycles';
		description: 'decides whether 1-cycles should be shown'
]

{ #category : #setting }
PMPermutation class >> printAsCycles [
^PrintAsCycles ifNil: [ PrintAsCycles :=false ]
]

{ #category : #setting }
PMPermutation class >> printAsCycles:aBoolean [
^PrintAsCycles := aBoolean 
]

{ #category : #private }
PMPermutation class >> privateSize: anInteger fromCycles: aCollectionofCollections [
	| result |
	result := self identity: anInteger.
	aCollectionofCollections do: [ :cycle | 
		1 to: cycle size do: [ :i | 
			result at: (cycle at: i) put: (cycle atWrap: i + 1) ] ].
	^ result
]

{ #category : #accessing }
PMPermutation class >> randomGenerator [
^RandomGenerator ifNil: [ RandomGenerator := Random new ]
]

{ #category : #'instance creation' }
PMPermutation class >> randomPermutation: size [
^self ordering: (self randomGenerator next:size)
]

{ #category : #setting }
PMPermutation class >> showOneCycles [
^ShowOneCycles ifNil: [ ShowOneCycles :=true ]
]

{ #category : #setting }
PMPermutation class >> showOneCycles:aBoolean [
^ShowOneCycles := aBoolean 
]

{ #category : #'instance creation' }
PMPermutation class >> size: anInteger fromCycles: aCollectionofCollections [

	self testCycles: aCollectionofCollections .
	^self privateSize: anInteger fromCycles:aCollectionofCollections  
]

{ #category : #'instance creation' }
PMPermutation class >> size: size shift: aNumber [
"number positive -> leftshift, negative -> rightshift"
^ (super withAll: (1 to: size) )shift: aNumber
]

{ #category : #accessing }
PMPermutation class >> stirling1:anInteger over:anotherInteger [
"unsigned Stirling number of the first kind: the number of permutations of size anInteger with anotherInteger number of cycles"
|block|
block:=[:nandk||n k|
	n:=nandk first.
	k:=nandk second.
	(n=k and:[n isZero])
		ifTrue:[1]
		ifFalse:[	(n * k) isZero 
				ifTrue:[0]
				ifFalse:[ (block value:{n-1.k-1})+((n-1)*(block value:{n-1.k}))]]]memoized .
^block value:{anInteger . anotherInteger }
]

{ #category : #tests }
PMPermutation class >> testCycles:aCollectionOfCollections [
|result|
result:=aCollectionOfCollections flattened.
result asSet size==result size ifFalse: [  ^ self error: 'Permutation has doubles' ].
^result
]

{ #category : #arithmetic }
PMPermutation >> + anInteger [
anInteger isInteger ifFalse:[^self nonIntegerCalc ].
^self adaptToInteger: anInteger andSend: #+.

]

{ #category : #arithmetic }
PMPermutation >> - anInteger [
|s|
anInteger isInteger ifFalse:[^self nonIntegerCalc ].
s:=self size.
^self collect: [:element|(element - anInteger) nonZeroMod: s].

]

{ #category : #comparing }
PMPermutation >> = anObject [ 
^anObject class == self class 
	and: [ self shortForm = anObject shortForm ]
]

{ #category : #adapting }
PMPermutation >> adaptToInteger: rcvr andSend: selector [
|s|
"works with #+ and #-"
s:=self size.
^ self collect: [:element | (rcvr perform: selector with: element)nonZeroMod: s]

]

{ #category : #adapting }
PMPermutation >> adaptToNumber: rcvr andSend: selector [
self nonIntegerCalc 
]

{ #category : #converting }
PMPermutation >> asArray [
"returns a basic Array, not self, because it is occasionally very pactical to have an array, which eg has a more common #= method"
^Array withAll: self
]

{ #category : #converting }
PMPermutation >> asCycles [
	| unused start next result cycle |
	self reduce.
	unused := (1 to: self size) asOrderedCollection.
	result := OrderedCollection new.
	[ unused isEmpty ]
		whileFalse: [ 
			next := start := unused first.
			cycle := OrderedCollection new.
			[ cycle add: (unused remove: next).
			next := self at: next ] doWhileFalse: [ next = start ].
			(cycle size > 1 or:[self class showOneCycles ])ifTrue: [result add: cycle asArray] ].
	^ result asArray
]

{ #category : #converting }
PMPermutation >> asMatrix [
	^ PMMatrix
		rows:
		  (self asPMVector
				collect: [ :n | 
					(PMVector new: self size)
						atAllPut: 0;
						at: n put: 1;
						yourself ])
]

{ #category : #applying }
PMPermutation >> commutate: aPermutation [
^((self inverse permute: aPermutation inverse) permute:self)permute: aPermutation 
]

{ #category : #applying }
PMPermutation >> conjugate: aPermutation [
^(self permute: aPermutation) permute:self  inverse
]

{ #category : #applying }
PMPermutation >> discriminant [
|r s|
s:=self class showOneCycles .
self class showOneCycles:true.
r:=self size - self asCycles size.
self class showOneCycles:s.
^r
]

{ #category : #testing }
PMPermutation >> even [ 
^self odd not
]

{ #category : #applying }
PMPermutation >> extendTo: size [
	| c |
	size=self size ifTrue: [ ^self copy ].
	c := self class identity: size.
	c
		replaceFrom: 1
		to: self size
		with: self
		startingAt: 1.
	^ c
]

{ #category : #comparing }
PMPermutation >> hash [
^self shortForm hash bitXor: self class hash.

]

{ #category : #applying }
PMPermutation >> inverse [
|c|
c:=self class new:self size.
1 to: self size do: [:i | c at: i put: (self indexOf: i)].
^c
]

{ #category : #testing }
PMPermutation >> isCollection [
"pffh, i found this useful, but i dont remember anymore why."
	^ false
]

{ #category : #arithmetic }
PMPermutation >> negated [
^0-self
]

{ #category : #private }
PMPermutation >> nonIntegerCalc [
^DomainError signal:'Only calculations with Integers work for Permutations'
]

{ #category : #testing }
PMPermutation >> odd [
"using the number of transpositions is faster than using the number of inversions"
^self discriminant odd.
]

{ #category : #applying }
PMPermutation >> order [
|c |
c:=self asCycles .
c isEmpty ifTrue: [ ^1 ].
c:=c collect: [ :a|a size ].
^c reduce: [ :a :b|a lcm:b ]

]

{ #category : #applying }
PMPermutation >> permute: aSequentialCollection [
	| c |
	aSequentialCollection size < self size
		ifTrue: [ aSequentialCollection class==self class 
			ifTrue: [ ^ self permute: (aSequentialCollection extendTo: self size) ] 
			ifFalse: [ ^ SizeMismatch signal ] ].
	c := aSequentialCollection copy.
	1 to: self size do: [ :i | c at: i put: (aSequentialCollection at: (self at: i)) ].
	^ c
]

{ #category : #printing }
PMPermutation >> printElementsOn: aStream [
	self class printAsCycles ifFalse: [ ^super printElementsOn: aStream  ].
	aStream nextPut: $(.
	self asCycles do: [:element | element printElementsOn: aStream] separatedBy: [aStream space].
	aStream nextPut: $)
]

{ #category : #private }
PMPermutation >> reduce [
"automatically used only in #withAll: & #shortForm so far. you have to use it by hand in some other cases."
	| sorted range |
	(sorted := self asArray sorted) = (range := 1 to: self size)
		ifTrue: [ ^ self ].
	self size == self asSet size
		ifFalse: [ ^ self error: 'Permutation has doubles' ].
	range do: [ :n | self at: n put: (sorted indexOf: (self at: n)) ]
]

{ #category : #applying }
PMPermutation >> reversed [
	"copy of SequenceableCollection>>reversed, but uses class instead of species."
	| n result src |
	n := self size.
	result := self class new: n.
	src := n + 1.
	1 to: n do: [:i | result at: i put: (self at: (src := src - 1))].
	^ result
]

{ #category : #applying }
PMPermutation >> shift: anInteger [
"number positive -> leftshift, negative -> rightshift"
	| n c |
	self ifEmpty: [ ^ self ].
	n := anInteger \\ self size.
	c := self copy.
	self
		replaceFrom: 1 to: self size - n with: c startingAt: n + 1;
		replaceFrom: self size - n + 1 to: self size with: c startingAt: 1
]

{ #category : #private }
PMPermutation >> shortForm [
	| each |
	self reduce.
	^ Array new: self size streamContents: [ :stream|
		1 to: self size do: [ :index |
			((each:=self at: index)==index)
				ifFalse: [ stream nextPut: each ]]]

]
