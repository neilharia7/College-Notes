# Artificial Intelligence Part II

## Propositional Logic
*	**Symbols:**
	*	Logical Contants: TRUE, FALSE
	*	Propositional Symbols: P, Q, R, etc.
	*	Logical Connectives: &and;, &or;, &not;, &rArr;, &hArr;
	*	Parentheses: ( )

*	**Sentences:**
	*	Atomic sentences combined with connections or wrapped in parantheses.
	
### Logical Connectives
*	Conjunction: &and;
*	Disjunction: &or;
*	Implication: &rArr;
*	Equivalence: &hArr;
*	Negation: &not;

**Precedence (from highest to lowest):** &not;, &and;, &or;, &rArr;, &hArr;


## First Order Logic (FOL)
*	In first-order logic, the world is seen as object with properties (about each object) and relations (betweeen objects).
*	**Sentences** are built from quantifiers, predicate symbols and terms.
*	**Constant Symbols** refer to the *name* of particular objects e.g. `John`.
*	**Predicate Symbols** refer to particular relations on objects. e.g. `Brother(John, Richard)` → T or F.
*	**Function Symbols** refer to functional relations on objects. e.g. `BrotherOf(John)` → a person.
*	**Variables** refer to any object of the world and can be substituted by a constant symbol. e.g. x, y.
*	**Terms** are logical expressions referring to objects that may include function symbols, constant symbols and variables. e.g. `LeftLegOf(John)` to refer to the leg without naming it.

### Sentences in FOL

*	**Atomic Sentences**
	*	state facts using terms and predicate symbols 
		*	e.g. `Brother(Richard, John)`
	*	can have complex terms as agruments
		*	e.g. `Married(FatherOf(John), MotherOf(Richard))`
	*	have a truth value
*	**Complex Sentences** combine sentences with connectives identical to propositional logic.

### Conversion to CNF (Conjunctional Normalized Form)
*	Eliminate biconditionals &hArr; and implications &rArr;
*	**Eliminate &hArr; replacing &alpha; &hArr; &beta; with (&alpha; &rArr; &beta;) &and; (&beta; &rArr; &alpha;)**
*	**Eliminate &rArr; replacing &alpha; &rArr; &beta; with &not; &alpha; &or; &beta;**



