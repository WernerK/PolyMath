"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestMathPermutation,
	#superclass : #PackageManifest,
	#category : #'Math-Permutation-Manifest'
}

{ #category : #'code-critics' }
ManifestMathPermutation class >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#PMPermutation #adaptToInteger:andSend: #false)) #'2021-02-25T12:19:22.138486+01:00') #(#(#RGMethodDefinition #(#'PMPermutation class' #generator: #true)) #'2021-03-10T17:17:16.279815+01:00') )
]

{ #category : #'code-critics' }
ManifestMathPermutation class >> ruleRBCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'PMPermutation class' #generator: #true)) #'2021-03-10T17:18:09.402797+01:00') )
]

{ #category : #'code-critics' }
ManifestMathPermutation class >> ruleRBModifiesCollectionRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'PMPermutation class' #generator: #true)) #'2021-03-10T17:18:06.554363+01:00') )
]

{ #category : #'code-critics' }
ManifestMathPermutation class >> ruleRBRefersToClassRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'PMPermutation class' #generator: #true)) #'2021-03-10T17:17:09.387974+01:00') )
]
