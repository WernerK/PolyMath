Extension { #name : #Number }

{ #category : #'*Math-Permutation' }
Number >> nonZeroMod:aPositiveInteger [
"like \\, but returns aPositiveInteger instead of 0"
 ^self - ((self - 1 // aPositiveInteger) * aPositiveInteger)
]
