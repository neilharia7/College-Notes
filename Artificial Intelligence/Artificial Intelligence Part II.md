# Artificial Intelligence Part II

## Logical Agents
### The Knowledge-Based Approach
*	Agents that *know*
	*	achieve competence by being told new knowledge or by learning.
	*	achieve adaptibility by updating their knowledge.
	*	*Knowledge Representation*
	
*	Agents that *reason*
	*	use knowledge to deduce the course of action .
	*	*Knowledge Inference*
	
### Knowledge-Based Agents
*	**Basics:**
	*	A knowledge-based agent has a knowledge base(KB)
	*	Knowledge Base (KB): Set of Sentences (Sentence = Representation of a Fact/Rule).
	*	The two operations on the KB are **TELL** and **ASK**
	*	Adding & Querying Knowledge
		*	`TELL`: add a sentence to the KB
		*	`ASK`: retrieve knowledge from the KB
			*	Answer must *follow* from what has been *TELL*-ed.
	*	When a knowledge-based agent receives a percept, it tells the KB that it received the precept
	*	When a knowledge-based agent performs an action, it tells the KB that it performed the action
	*	An agent's designer can prime the KB with initial knowledge
	*	Agents can learn new knowledge
	
*	Infernce Mechanism: Determines what follows from the KB.
*	Knowledge Based System
	*	States: Instances of the KB
	*	Operators: Add/Infer a `new sentence`
	*	Goal: Answer a Query
	
### Levels of Knowledge
*	**Epistemological Level:** Declarative description of knowledge.
	*	e.g. facts: "there is smoke", rules: "if there is smoke, there is fire"
*	**Logical Level:** Logical encoding of knowledge (into sentences).
	*	e.g. facts: Smoke, rules: Implies(Smoke, Fire)
*	**Implementation Level:** Physical representation of knowledge.
	*	e.g. Strings, 2-D Arrays etc.

### Knowledge Representation
*	The KB (set of sentences ) needs to be expressed in a computer-tractable form.
*	The KR language must be expressive, concise, unambiguous, context-independent & effective.
*	KR Language split into:
	*	`Syntax` - a set of rules for writing sentences.
	*	`Semantics` - a set of rules (or contraints) for relating sentences to real-world facts.
	
### Reasoning & Logic
*	Logic = Representation + Inference
*	Reasoning - Construction of new sentences from existing ones.
*	Entailment - Generate sentences that are necessarily true, given that the existing sentences are true. KB &#8872; &alpha;.

 #### Inference:
*	*Inference (reasoning) is the process by which conclusions are reached.*
*	Logical inference (deduction) is the process that implements entailment between sentences.
*	Properties of Inference:
	*	**Soundness:** An inference algorithm is sound if it derives only sentences that are entailed by the KB. 
		*	If A⊢B then A⊨B
	*	**Completeness:** An inference algorithm is complete if it can derive any sentence that is entailed by the KB. 
		*	If A⊨B then A⊢B
	*	**Proof Theory:** A set of rules for deducing the entailments of sentences.
	
*	**Note:** A⊨B means that B is true in every structure in which A is true. A⊢B means B can be proved using A as the premises. 
	
*	**Valid** Sentence (Tautology): iff TRUE under all possible interpretations in all possible worlds. e.g. S &or; &not;S is valid.
*	**Satisfiable** Sentence: iff there is some interpretation in some world for which it is TRUE. e.g. S &and; &not;S is unsatisfiable.

**Deductive Inference:**

X &rArr; Y, X &#8866; Y

- Sound.
- *Modus Ponens*.

**Inductive Inference:**

X &rArr; Y, Y &#8866; X

- Not sound.
- Generalisation.

#### Different Logics
*	**Propositional Logic:**
	*	Symbols represent propositions (facts).
	*	Boolean connectives combine symbols.
*	**First-Order Logic:**
	*	Objects and predicates (unary, binary or n-ary) represent properties of and relations between objects.
	*	Variables, boolean connectives and quantifiers.
*	**Temporal Logic:**
	*	World ordered by a set of time points/intervals.
*	**Probabilistic & Fuzzy Logic:**
	*	Degrees of belief and truth in sentences.
	*	e.g. "Washington is a large city" with truth degree 0.6.

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

### Limits of Propositional Logic
Propositional logic is a *weak logic*
*	Too many propositions to TELL the KB. Results in increased time complexity of inference.
*	Handling changes in the environment is difficult.


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

**Note**
*	Remember that the semantics depends on the ordering of the quantifiers if more than one is used.

### Equality Predicate Symbol
*	States that two terms refer to the same object.
	*	e.g. Father(John) = Henry
	*	e.g. =(Father(John), Henry)
*	Useful to define properties.

### Using First-Order Logic
*	The *knowledge domain* is the part of the world we want to express knowledge about.
*	The **facts** and **rules** are fed into the KB (knowledge base).
*	TELLing the KB:
	*	i.e. Assertion (add sentence to the KB)
	*	e.g. TELL(KB, &forall;x,y MotherOf(x) = y &hArr; Parent(x, y) &and; Female(y))
*	ASKing the KB:
	*	i.e. Query (retrieve/infer a sentence from the KB)
	*	Yes/No Answer
		*	e.g. ASK(KB, Grandparent(Elizabeth, William))
	*	Binding List or *Substitution*
		*	e.g. ASK(KB, &exist;x Child(William, x)) yields (x / Charles)
*	Knowedge-based agents need to use goals in conjuction with knowledge to make plans.
	
## Inference in First-Order Logic

### Inference Rules w/ Quantifiers
#### Substitutions 
*	SUBST(&theta;, &alpha;): binding list &theta; is applied to a sentence &alpha;.
	*	e.g. SUBST({x / John, y / Richard}, Brother(x, y)) = Brother(John, Richard)
	
#### Aditional Inference Rules

**Universal Elimination:**
> &forall;x &alpha; &#8872; SUBST({x / g}, &alpha;) &nbsp;&nbsp;&nbsp; where `g` is a ground term

**Existential Elimination:**
> &exist;x &alpha; &#8872; SUBST({x / K}, &alpha;) &nbsp;&nbsp;&nbsp; where `K` is a *Skolem constant*

**Existential Introduction:**
> &alpha; &#8872; &exist;x SUBST({x / g}, &alpha;) &nbsp;&nbsp;&nbsp; where `g` is a ground term

#### Skolemization

Existential quantifiers (&exist;) can be eliminated by replacing the corresponding variable with a Skolem function. The arguments of a Skolem function include all the universally quantified variables that are bound by universal quantifiers whose scopes include the scope of the existential quantifier being eliminated. If a Skolem function has no arguments, it's known as a Skolem constant.

*	&forall;x &exist;y P(x, y) becomes &forall;x P(x, S(x))
*	&exist;y &forall;x P(x, y) becomes &forall;x P(x, S)
*	&exist;y P(y) becomes P(S)

### Unification
*	Find a substitution that makes two atomic sentences alike. or `When two terms match we say that they unify.`
	*	Their structures and arguments are compatible.
*	i.e. UNIFY(&alpha;, &beta;) = &theta; where SUBST(&theta;, &alpha;) = SUBST(&theta;, &beta;)
	*	**Examples (Terms that unify)**
		*	'Hey you' = 'Hey you' 
		*	foo(X) = foo(bar)            `X = bar` 
		*	foo(N, N) = foo(bar, X)      `N = bar, X = bar`
	*	**Examples (Terms that don't unify)**
		*	'Hey you' = 'Hey me'
		*	foo(bar) = foo(bar, bar)
		*	foo(N, N) = foo(bar, rab)


#### Composition of Substitutions
> SUBST(Compose(&theta;<sub>1</sub>, &theta;<sub>2</sub>), &alpha;) = SUBST(&theta;<sub>2</sub>, SUBST(&theta;<sub>1</sub>, &alpha;))

### Proof as a Search Problem
- Proof procedure is a sequence of inference rules applied to the KB.
- Initial State i.e. KB → Operators i.e. Inference Rules → Goal State i.e. KB w/ Goal
- Branching factor increases as the KB grows.

### Generalised Modus Ponens
Universal-Elimination + And-Introduction + Modus Ponens

**Example:**<br>
Missile(M1),<br>
Owns(Nono, M1),<br>
&forall;x Missile(x) &and; Owns(Nono, x) &rArr; Sells(West, Nono, x)<br>
&#8872; Sells(West, Nono, M1)

> &gamma;<sub>1</sub>, &gamma;<sub>2</sub>,...,&gamma;<sub>n</sub>, (&alpha;<sub>1</sub> &and; &alpha;<sub>2</sub> &and; ... &and; &alpha;<sub>n</sub> &rArr; &beta;) &#8872; SUBST(&theta;, &beta;)
> where &forall;i SUBST(&theta;, &gamma;<sub>i</sub>) = SUBST(&theta;, &alpha;<sub>i</sub>)

Every fact (&gamma;<sub>i</sub>) must have a corresponding antecedent (&alpha;<sub>i</sub>) in the rule for GMP.


### Forward & Backward Chaining

*	**Forward Chaining (data driven) &mdash;** Start with the KB and generate new sentences given a particular event (&alpha;). KB, &alpha; &#8872; ?.
*	**Bacward Chaining (goal driven) &mdash;** Start with a sentence not in the KB (&beta;) and attempt to establish its premises. KB &#8872; &beta; ?.

#### Forward Chaining 
**Idea:** Inferring new consequences.

**Pseudo Algorithm**

1.	TELLing a new sentence &alpha;.
2.	If &alpha; is already in the KB, do nothing.
3.	Find all the implications that have &alpha; as a premise, i.e. &alpha; &and; &alpha;<sub>1</sub> &and; ... &and; &alpha;<sub>n</sub> &rArr; &beta;.
4. 	Then, if all the other premises &alpha;<sub>i</sub> are known under some MGU &theta;, infer the conclusion &beta; under &theta;.
5. 	If some premises &alpha;<sub>i</sub> can be matched several ways, then infer each corresponding conclusion.

**Using Forward Chaining**

1. 	Given a KB, derive all the facts and rules.
2. 	If there are facts with &exist;, skolemize them and derive the new facts.
3. 	Use GMP to satisfy the rules and derive new facts recursively until the goal is reached.

#### Backward Chaining
**Idea:** Checking for causes.

**Pseudo Algorithm**

1.	ASKing a query &beta;.
2.	If &beta; is already in the KB, proof immediate.
3.	Else, find all implications that have &beta; as a conclusion, i.e. &alpha;<sub>1</sub> &and; &alpha;<sub>2</sub> &and; ... &and; &alpha;<sub>n</sub> &rArr; &beta;.
4.	Then, try and establish all the premises &alpha;<sub>i</sub> and infer &beta;.

**Using Backward Chaining**

1. 	Given a KB, derive all the facts and rules.
2. 	If there are facts with &exist;, skolemize them and derive the new facts.
3. 	Derive a unifying list that satisfies the goal &beta;.


### Conversion to CNF (Conjunctional Normalized Form)
*	Eliminate biconditionals &hArr; and implications &rArr;
*	*Eliminate &hArr; replacing &alpha; &hArr; &beta; with (&alpha; &rArr; &beta;) &and; (&beta; &rArr; &alpha;)*
*	*Eliminate &rArr; replacing &alpha; &rArr; &beta; with &not; &alpha; &or; &beta;*
