# Artificial Intelligence Part I
## Intelligent Agents
### What is an agent?
* An **agent** is an entity that
	* **perceives** its enviroment through sensors (e.g. eyes, ears, cameras, sensors)
  	* **acts** on its environment through effectors (e.g. hands, legs, motors)
* A **rational agent** is one which does the right thing.
  	* **Rational action:** action that is expected to maximize its performance measure, given the evidence provided by the percept sequence and whatever built-in knowledge the agent has.
  	* **Rationality** depends on:
    	* Performance measure that defines the criterion of success
    	* Actions that the agent can perform
    	* Percept
    	* Environment (States)
* An **autonomous agent** does not rely entirely on built-in knowledge about the environment. It adapts to the environment through experience i.e. *learning*.
* An **agent program** is a function that implements the agent mapping from the percepts to actions.

### Types of Agents
#### Simple Reflex Agent
1. Find the rule whose condition matches the **current** situation (as defined by the percept).
2. Perform the action associated with that rule.
3. Very limited intelligence.
4. Suitable when environment == **Fully Observable**.

#### Reflex Agents with States (Model-Based)
1. Find the rule whose condition matches the current situation (as defined by the percept and the current state).
2. Perform the action associated with that rule.
4. Can work on **Partially Observable** environment.

**Note:** The *state* is a description of the current world environment. It contains all the necessary information to predict the effects of an action and to determine if the state is a goal state.

#### Goal-Based Agents
1. Find the action that will get me closer to the goal state from my current state.
2. Perform that action.

**Note:** A *goal* can be specific (explicit destination), abstract (speed, safety) or numerous.

#### Utility-Based Agents
* There may be many action sequences that can achieve the same goal.
* Which action sequence should the agent take?
 	* The one with the maximum utility i.e. lowest cost.
* Maps a *state* onto a real number which describes the associated degree of happiness.

### Types of Enviroment

* **Accessible (vs Inaccessible):**
* **Deterministic (vs Non-Deterministic / Stochastic):** 
* **Discrete (vs Continuous):**
* **Episodic (vs Sequential):**
* **Observable (vs Partially-Observable):**
* **Single agent (vs Multiple agents):**
* **Static (vs Dynamic):**

## Problem Formulation
### Problem-Solving Agent
* Rational Goal-Based Agent
 	* Performance measure is defined in terms of satisfying goals.
#### Steps
1.	**Goal Formulation**
	- Define and organise objectives (goal states)
2.	**Problem Formulation**
	- Define what states and actions (transitions) to consider.
3.	**Search for a Solution**
	- Find a sequence of actions that lead to a goal state.
	- No Knowledge → Random Search
	- Knowledge → Directed Search
4.	**Execution**
	- Actually carry out the recommended actions.
	
### Types of Problems
1. **Single-State Problem**
	- accessible world state (sensory information is available)
	- known outcome of action (deterministic)
2. **Multiple-State Problem**
	- inaccessible world state (with limited sensory information) i.e. agent only knows which set of states it is in
	- known outcome of action (deterministic)
3. **Contingency Problem**
	- limited or no sensory information (inaccessible)
	- limited agent knowledge, action result is not predictable
	- effect of action depends on what is found to be true through perception/monitoring (non-deterministic)
	- problem solving requires sensing during the execution phase
4. **Exploration Problem**
	- no information is known about the world state or outcome of action
	- experimentation is often needed
		- hypotheses as actions, search in the real world
		- *learning* builds the agent's knowledge of states and actions progressively
		
### Well-Defined Problem Formulation
* 	Definition of the problem
	*	The information used by an agent to decide what to do.
*	Specification:
	*	`Initial State`
	*	`Action State` i.e. available actions (successor functions)
	*	`State Space` i.e. reachable states from the initail state
		*	Solution Path: sequence of actions from one state to another
	*	`Goal Test`
		*	single state, enumerated list of states, abstract properties
	*	`Cost Function`
		*	Path Cost *g(n)* i.e. sum of all (action) step costs along the path
*	Solution
	*	A path (a sequence of operators leading) from the Initial State to a Final State that satisfies the Goal Test.
*	Search Cost
	*	Does the agent find the solution?
	*	Is it an good solution (i.e. with a low path cost)
	*	What is the cost to find the solution?
*	Total Cost of Problem Solving = Search Cost + Path Cost
	*	Trade-offs often required.
		*	Search for a very long time for an optimal solution. (e.g. Dijkstra's algorithm)
		*	Search for a shorter time for a *good enough* solution.
		
## Search
*	A **search agorithm** explores the state space by generating successors of already explored (known) states i.e. expanding the states.
*	A **search strategy** is defined by picking the order of node expansion. Preformance of strategies are evaluated by the following metrics:
	*	**Time Complexity:** How long does it take to find the solution?
	*	**Space Complexity:** How much memory is needed to perform the search?
	*	**Completeness:** Does it always find a solution if one exists?
	*	**Optimality**: Does it always find the best (least-cost) solution?

### Performance Evaluation
*	Measuring difficulty of an AI problem:
	*	`Branching Factor` (number of successors (children) of a node)
	*	`Average Branching Factor` (Total branches ÷ number of non-leaf nodes)
	*	`Depth of *Shallowest* Goal Node`
	*	`Maximum length of any path in state space`
*	Time Complexity
	*	 measured in terms of the number of nodes generated during search
*	Space Complexity
	*	measured in terms of the maximum number of nodes stored in memory
*	Search Cost
	*	depends on the time complexity
	*	can also include memory usage
*	Total Cost
	*	combines the search cost and solution cost (path cost of the solution found)
	
### Search Strategies 
*	Uninformed Search Strategies
	*	use only the information available in the problem definition
		*	Breadth-First Search (BFS)
		*	Depth-First Search (DFS)
		*	Uniformed-Cost Search
		*	Depth-Limited Search
		*	Iterative Deepening Search (IDS) or (more specifically) Iterative Deepening Depth-First Search (IDDFS)
	*	Informed Search Strategies 
		*	use problem-specific knowledge to guide the search
		*	usually more efficient (than uninformed search)
		
## Uninformed Search
### Variables used
*	**b**: 	Maxiumum Branching Factor
*	**d**:	Depth of Least-Cost solution
*	**m**:	Maximum Depth of State Space

### Breadth-First Search
*	Expand shallowest unexpanded node.
	*	Can be implemented using a FIFO queue.
*	Time: *1 + b + b<sup>2</sup> + b<sup>3</sup> + ... + b<sup>d</sup> = O(b<sup>d</sup>)*
*	Space: Assuming every node is kept in memory, *O(b<sup>d</sup>)*.
*	Complete: Yes
*	Optimal: Yes, when all steps cost equally
*	**Applications:**
	*	Testing graph for bipartitness
	*	*Ford-Fulkerson* method for computing the maximum flow in a flow network
	*	Finding the shortest path between two nodes u and v, with path length measured by number of edges (an advantage over DFS)

### Depth-First Search
- Expand deepest unexpanded node.
	- Can be implemented using a LIFO stack.
	- Backtrack only when no more expansion is possible.
- Time: *O(b<sup>m</sup>)*
- Space: *O(bm)*
- Complete:
	- Infinite-depth Spaces: No
	- Finite-depth Spaces w/ Loops: No
	- Finite-depth Spaces w/o Loops: Yes
- Optimal: No

