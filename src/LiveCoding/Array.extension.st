Extension { #name : #Array }

{ #category : #'*LiveCoding' }
Array >> * aNumber [
"returns an Array with all the elements of self multiplicated for aNumber"

| result |
result := ( 1to: (self size)) collect: [ :i | (self at: i) * aNumber ].
^ result
]

{ #category : #'*LiveCoding' }
Array >> + aNumber [ 
" sum aNumber to each element of the array"
| result |
result := (1 to: (self size)) collect: [ :i | (self at: i ) + aNumber ].
^ result
]

{ #category : #'*LiveCoding' }
Array >> and: anArray [

^ Sequencer with: self with: anArray
]

{ #category : #'*LiveCoding' }
Array >> and: anArray and: anotherArray [

^ Sequencer with: self with: anArray with: anotherArray 
]

{ #category : #'*LiveCoding' }
Array >> asRhythm [
" convert Array into a Rhythm"
| rhythm |
rhythm := Rhythm new: (self size).
(1 to: ( self size)) do: [ :i | rhythm at: i put: (self at: i) ].
^ rhythm
]

{ #category : #'*LiveCoding' }
Array >> asSeq [
"returns Sequencer with default note 60nn and default durations 1/16th"
^ (Sequencer with: self with: #(60) with: #(0.125) )
]

{ #category : #'*LiveCoding' }
Array >> gates [ 
"return number of elements in the array that are greater than 0"
| result size |
result := self select: [ :i | i > 0 ].
size := result size.
^ size
]

{ #category : #'*LiveCoding' }
Array >> isSequencer [
((self at: 2) isArray) ifTrue: [ ^true ] ifFalse: [ ^false ]
]

{ #category : #'*LiveCoding' }
Array >> of: anotherArray [
" economic implementation of self collect: [:i | anotherArray at: i]"
| result |
result := self collect: [ :i | anotherArray  at: i ].
^ result
]

{ #category : #'*LiveCoding' }
Array >> offset: aNumber [ 
"offset the array by aNumber of 'steps' wrapping it around its size"
^ (0 to: (self size - 1)) collect: [ :i | self at: (((i + aNumber) rem: (self size)) + 1) ]
]

{ #category : #'*LiveCoding' }
Array >> times: aNumber [
"returns an Array containing aNumber repetition of self"

| newSize newArray  |
newSize := aNumber * self size.
newArray := Array new: newSize.
(1 to: newSize) do: [ :i | newArray  at: i put: (self at: ((i - 1) modulo: (self size )) ) ].
^ newArray
]

{ #category : #'*LiveCoding' }
Array >> toKyma: aString [
	"sends and array of oscmessages with the values of the array to the vcs labels with array indexes"
	
	| array pacaAddress sizeMessage|
	pacaAddress := NetNameResolver stringFromAddress: (NetNameResolver 	addressForName:'beslime-691.local'). 
	sizeMessage := OSCMessage for: { '/vcs/', aString,'Size', '/1' . (self size) asFloat}.
	array := ( 1 to: (self size)) collect: [ :i | OSCMessage for: {'/vcs/', aString, (i asString),'/1'. 	((self 		at: i) asFloat) 	} ].
	(1 to: (array size)) do: [:i | (array at: i) sendToAddressString: pacaAddress port: 8000].
	sizeMessage sendToAddressString: pacaAddress port: 8000. 

"this message alls sends an OSC message called aStringSize"
	
]

{ #category : #'*LiveCoding' }
Array >> withIts: anArray [ 
| numberOfGates result |

numberOfGates := anArray  size.
result := (1 to: numberOfGates) collect: [ :i | anArray   at: (i modulo: numberOfGates) ].
^ Sequencer with: self with: result
]
