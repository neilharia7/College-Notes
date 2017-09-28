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
	*	`The agent’s sensory apparatus gives it access to the complete state of the environment.`
* **Deterministic (vs Non-Deterministic / Stochastic):** 
* **Discrete (vs Continuous):**	
	*	`There are a limited number of distinct percepts and actions.`
* **Episodic (vs Sequential):**	
	*	`Each episode is not affected by the actions taken in previous episodes.`
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
	*	`Depth of Shallowest Goal Node`
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
*	Expand deepest unexpanded node.
	*	Can be implemented using a LIFO stack.
	*	Backtrack only when no more expansion is possible.
*	Time: *O(b<sup>m</sup>)*
*	Space: *O(bm)*
*	Complete:
	*	Infinite-depth Spaces: No
	*	Finite-depth Spaces w/ Loops: No
	*	Finite-depth Spaces w/o Loops: Yes
*	Optimal: No
*	**Applications:**
	*	Topological Sorting
	*	Maze generation may use a randomized depth-first search
	*	Finding biconnectivity in graphs
	
### Depth-Limited Search
*	To avoid infinite searching, DFS with a cutoff on a max. depth *l* of a path.
*	Time: *O(b<sup>l</sup>)*
*	Space: *O(bl)*
*	Complete: Yes, if *l* &ge; *d*
*	Optimal: No

### Iterative Deepening Search
*	Improvement on Depth-Limited Search. Iteratively estimate the max. depth *l* of DLS one-by-one.
*	Time: *O(b<sup>d</sup>)*
*	Space: *O(bd)*
*	Complete: Yes
*	Optimal: Yes

## Informed Search
*	Uninformed search strategies have a systematic generation of new states but are inefficient.
*	Informed search strategies use problem-specific knowledge to determine which node to expand next.

#### Best First Search
*	Expand most desirable unexpanded node.
	*	Use an evaluation function *f(n)* to estimate the cost of each node.
	*	Nodes are ordered so that the one with the lowest *f(n)* is expanded first.
	*	The choice of *f* determines the search strategy.

#### Heuristic Function
*	**Path Cost Function** ***g(n)*****:**
	*	Cost from initial state to current state *n*.
	*	No information on the cost towards the goal.
	*	Need to estimate the cost to the closest goal.

*	**Heuristic Function** ***h(n)*****:**
	*	Estimated cost of the cheapest path from the state at node *n* to a goal state.
		*	Exact cost cannot be determined.
	*	Depends only on the state at that node.
	*	Additional knowledge of the problem is imparted to the search algorithm.
	*	Non-negative, problem specific function.
	*	If *n* is a goal node, then `h(n) = 0`.

### Greedy Best-First Search 
*	Expands the node that appears to be closest to the goal.
	*	Evaluation Function: `f(n) = h(n)`
	*	Objective: Quick Solution (but may be suboptimal)
*	The cost is estimated using problem-specific knowledge.
*	Time: *O(b<sup>m</sup>)* (Worst Case)
*	Space: *O(b<sup>m</sup>)* (Worst Case)
*	Complete: No
*	Optimal: No
*	`With a good heuristic function, the complexity can be reduced substantially.`
	
### A* Search
*	Uniform-Cost Search: (UCS)
	*	*g(n)*: Path cost to reach node *n* from the start node (Past Experience).
	*	`Optimal & Complete, but inefficient.`	

*	Greedy Best-First Search: (GBFS)
	*	*h(n)*: Estimated cost of the cheapest path from node *n* to goal node (Future Cost).
	*	`Neither Optimal nor Complete but relatively more efficient.`

*	Combining UCS and GBFS, A* Search:
	*	*f(n) = g(n) + h(n)*
	*	*f(n)*: Estimated total cost of the cheapest path through node *n* from start node to goal.
	*	`Optimal & Complete when` *h(n)* `statisfies certain conditions.`
	
#### Optimality of A* Search
*	If *h* is **admissible**, then the tree-search version of A* search is optimal.

#### Complexity of A*
*	Time: exponential in length of solution
*	Space: exponential in length of solution
*	With a good heuristic, significant savings are still possible compared to uninformed search methods.
*	Variants of A* search exist to deal with complexity issues.

### Heuristics
#### Admissible Heuristic
*	*h&ast;(n)*: True cost from node *n* to goal.
*	A heuristic is admissible if ***h(n) &le; h&ast;(n)*** for all *n*.
*	An admissible heuristic should never overestimate the cost to reach the goal.
*	i.e. *f(n)* never overestimates the actual cost of a path through node *n* to the goal.

#### Dominance
*	*h<sub>2</sub>* dominates *h<sub>1</sub>* if ***h<sub>2</sub>(n) &ge; h<sub>1</sub>(n)*** for all *n*.
*	Domination translates to efficiency.
*	Always better to use a heuristic function with higher values as long as it does not overestimate the cost.
*	If no heuristic dominates, *h(n) = max(*h<sub>1</sub>*(n), *h<sub>2</sub>*(n), ... , h<sub>m</sub>(n))*.

### Relaxed Problem
- A problem with fewer restrictions on the actions compared to an original problem is called a relaxed problem.
- State space graph of the relaxed problem is a supergraph of the original state space.
- Removal of restrictions creates more edges in the graph.

#### Heuristics from Relaxed Problems
- The cost of an optimal solution to a relaxed problem is an admissible heuristic for the original problem.
	- Relaxed problem adds edges to the state space.
	- Any optimal solution in the original problem is also a solution for the relaxed problem.

### MiniMax Algorithm
#### MIN & MAX
*	Assumption: You are **MAX**.
*	In a normal search problem, the optimal solution is a sequence of moves leading to a goal state &mdash; a terminal state that is a win.
*	In a game, *MIN* affects the solution.
*	The optimal strategy cannot perform worse than any strategy against an infallible opponent (i.e. MIN plays optimally) &mdash; it maximises the worst case outcome for MAX.

#### Minimax Algorithm
*	Minimax algorithm performs a depth-first exploration of the game tree.
*	Time: *O(b<sup>m</sup>)*, *b* is the no. of legal moves at each point and *m* is the max. depth of the tree.
*	Space: *O(bm)* if it generates all the successors at once **OR** *O(m)* if it generates successors one at a time.
*	For real games, the time cost is impractical.

### &alpha;-&beta; Pruning
*	In minimax search, the number of game states to examine is exponential in the number of moves.
*	The exponent cannot be eliminated but it can be halved by pruning away branches that cannot possibly influence the final decision.
*	Returns the same move as the minimax algorithm.

**General Idea**

*	If *m* is better than *n* for Player, then
	*	the state with utility *n* will never be reached
	*	and hence can be pruned away
	
**Note:**
*	*&alpha; is the lower bound of optimal utility.*
*	*&beta; is the upper bound of the optimal utility.*
*	*The maximiser is always trying to push the value of &alpha; up.*
*	*The minimiser is always trying to push the value of &beta; down.*
*	*If the node's value is between &alpha; & &beta;, then the players might reach it.*
*	*At the beginning (root of the tree), we set &beta; to &infin; and &alpha; to -&infin;.*

#### Advantages
*	Pruning does not affect the final result.
*	Effectiveness of pruning depends on the order in which successor nodes are examined.
	*	In the ideal case, the time complexity can be reduced to *O(b<sup>m/2</sup>)*.

### Constraint Satisfaction Problems
