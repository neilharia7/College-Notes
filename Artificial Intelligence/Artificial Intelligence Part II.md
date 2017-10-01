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

### Validity & Inference
*	A sentence can be tested for validation using truth tables and checking all possible configurations.

### Inference Rules
**Implication-Elimination or** ***Modus Ponens:***
>	&alpha; &rArr; &beta;,&nbsp; &alpha; &nbsp;&nbsp; &#8872; &nbsp;&nbsp; &beta;

**And-Elimination:**
>	&alpha;<sub>1</sub> &and; &alpha;<sub>2</sub> &and; &alpha;<sub>3</sub> &and; ... &alpha;<sub>n</sub> &nbsp;&nbsp; &#8872; &nbsp;&nbsp; &alpha;<sub>i</sub>

**And-Introduction:**
> 	&alpha;<sub>1</sub>, &alpha;<sub>2</sub>, &alpha;<sub>3</sub>, ... &alpha;<sub>n</sub> &nbsp;&nbsp; &#8872; &nbsp;&nbsp; &alpha;<sub>1</sub> &and; &alpha;<sub>2</sub> &and; &alpha;<sub>3</sub> &and; ... &alpha;<sub>n</sub>

**Or-Introduction:**
>	&alpha;<sub>i</sub> &nbsp;&nbsp; &#8872; &nbsp;&nbsp; &alpha;<sub>1</sub> &or; &alpha;<sub>2</sub> &or; &alpha;<sub>3</sub> &or; ... &alpha;<sub>n</sub>

**Double-Negation-Elimination:**
> 	&not;&not;&alpha; &nbsp;&nbsp; &#8872; &nbsp;&nbsp; &alpha;

**Unit Resolution:**
> 	&alpha; &or; &beta;,&nbsp; &not;&beta; &nbsp;&nbsp; &#8872; &nbsp;&nbsp; &alpha;

**Disjunctive Resolution:**
> 	&alpha; &or; &beta;,&nbsp; &not;&beta; &or; &gamma; &nbsp;&nbsp; &#8872; &nbsp;&nbsp; &alpha; &or; &gamma;

**Implicative Resolution:**
> 	&not;&alpha; &rArr; &beta;,&nbsp; &beta; &rArr; &gamma; &nbsp;&nbsp; &#8872; &nbsp;&nbsp; &not;&alpha; &rArr; &gamma;

### Equivalence Rules
**Associativity:**
> 	&alpha; &and; (&beta; &and; &gamma;) &nbsp;&nbsp; &hArr; &nbsp;&nbsp; (&alpha; &and; &beta;) &and; &gamma;

> 	&alpha; &or; (&beta; &or; &gamma;) &nbsp;&nbsp; &hArr; &nbsp;&nbsp; (&alpha; &or; &beta;) &or; &gamma;

**Distributivity:**
> 	&alpha; &and; (&beta; &or; &gamma;) &nbsp;&nbsp; &hArr; &nbsp;&nbsp; (&alpha; &and; &beta;) &or; (&alpha; &and; &gamma;)

> 	&alpha; &or; (&beta; &and; &gamma;) &nbsp;&nbsp; &hArr; &nbsp;&nbsp; (&alpha; &or; &beta;) &and; (&alpha; &or; &gamma;)

**De Morgan's Law:**
> 	&not;(&alpha; &or; &beta;) &nbsp;&nbsp; &hArr; &nbsp;&nbsp; &not;&alpha; &and; &not;&beta;

> 	&not;(&alpha; &and; &beta;) &nbsp;&nbsp; &hArr; &nbsp;&nbsp; &not;&alpha; &or; &not;&beta;

**Conjunctive Normal Form:**
> 	A &rArr; B &nbsp;&nbsp; &hArr; &nbsp;&nbsp; &not;A &or; B

>	A &hArr; B &nbsp;&nbsp; &hArr; &nbsp;&nbsp; (&not;A &or; B) &and; (A &or; &not;B)

### Complexity of Inference
*	Proof by truth-table is complete but has exponential time complexity.
*	Inferring new sentences using various inference rules and proving thus is more efficient.
*	Using a logic programming language like Prolog, which uses horn clauses and *Modus Ponens*, inference can be achieved in polynomial time complexity.
	*	**Horn Clauses:** A disjunction of literals with at most one unnegated literal.
		*	Definite Clause:
			*	&not;P &or; &not;Q &or; ... &or; &not;T &or; U
			*	P &and; Q &and; ... &and; T &rArr; U
		- Fact: U


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

### Quantifiers 

#### Universal Quantifier &forall;
*	Express properties about a collection of objects.
*	Applies to every object in the collection.
*	e.g. &forall;x, King(x) &rArr; Mortal(x)
*	&rArr; is the natural connective to use with &forall;.

#### Existential Quantifier &exist;
*	Express properties of one or more particular objects in a collection.
*	e.g. &exist;x, P(x) &and; Q(x)
*	&and; is the natural connective to use with &exist;.

#### Connections between Quantifiers
> &forall;x P(x) &nbsp; &hArr; &nbsp; &not;&exist;x &not;P(x)

> &forall;x &not;P(x) &nbsp; &hArr; &nbsp; &not;&exist;x P(x)

> &not;&forall;x P(x) &nbsp; &hArr; &nbsp; &exist;x &not;P(x)

> &not;&forall;x &not;P(x) &nbsp; &hArr; &nbsp; &exist;x P(x)

### Equality Predicate Symbol
*	States that two terms refer to the same object.
	*	e.g. Father(John) = Henry
	*	e.g. =(Father(John), Henry)
*	Useful to define properties.

### Conversion to CNF (Conjunctional Normalized Form)
*	Eliminate biconditionals &hArr; and implications &rArr;
*	*Eliminate &hArr; replacing &alpha; &hArr; &beta; with (&alpha; &rArr; &beta;) &and; (&beta; &rArr; &alpha;)*
*	*Eliminate &rArr; replacing &alpha; &rArr; &beta; with &not; &alpha; &or; &beta;*
