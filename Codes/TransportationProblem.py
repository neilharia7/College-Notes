import heapq
import sys
sys.setrecursionlimit(10000)

"""
D => depth
d => small depth (tends to `D` but should be smaller)
b => branching factor
c => constant

Algorithms              | Cost      | Time      | Space     | Idea

Backtracking Search     | Any       | O(b ^ D)  | O(D)      | Browse the entire space
DFS                     | 0         | O(b ^ D)  | O(D)      | Backtracking Search + stop when find the first end state.
BFS                     | c >= 0    | O(b ^ d)  | O(b ^ d)  | Goes layer by layer until it finds the end state, but it's worse in space as it needs to maintain the history
DFS - ID                | c >= 0    | O(b ^ d)  | O(d)      |
(Iterative Deepening)   |


Always exponential time
Avoid exponential space with DFS-ID
"""

class PriorityQueue:

    def __init__(self):
        self.DONE = -100000
        self.heap = []
        self.priorities = {} # map from state to priority

    # Insert |state| into the heap with priority |newPriority| if
    # |state| isn't in the heap or |newPriority| is smaller than the existing
    # priority

    # Return whether the priority queue is updated.
    def update(self, state, newPriority):
        oldPriority = self.priorities.get(state)

        if oldPriority is None or newPriority < oldPriority:
            self.priorities[state] = newPriority
            heapq.heappush(self.heap, (newPriority, state))
            return True
        return False

    # Returns (state with minimum priority, priority)
    # or (None, None) if the priority queue is empty
    def removeMin(self):
        while len(self.heap) > 0:
            priority, state = heapq.heappop(self.heap)
            if self.priorities[state] == self.DONE: continue # Outdated priority, skip
            self.priorities[state] = self.DONE
            return state, priority
        return None, None  # Nothing left..


### Model (search problem)

class TransportationProblem(object):

    def __init__(self, N):
        # N = number of block
        self.N = N

    def startState(self):
        return 1

    def isEnd(self, state):
        return state == self.N

    def succAndCost(self, state):
        # return list of (actions, newState, cost) triples
        result = []
        if state + 1 <= self.N:
            result.append(('walk', state + 1, 1))
        if state * 2 <= self.N:
            result.append(('tram', state * 2, 2))

        return result

### Algorithms
def printSolution(solution):
    totalCost, history = solution
    print(f'totalCost: {totalCost}')
    for item in history:
        print(item)

def backtrackingSearch(problem: TransportationProblem):
    # Best solution found so far (Dictionary because of python scoping technicality)
    best = {
        'cost': float('+inf'),
        'history': None
    }

    def recurse(state, history, totalCost):
        # At state, having undergone history, accumulated totalCost.
        # Explore the rest of the subtree under state.

        if problem.isEnd(state=state):
            # Update the best solution so far
            # TODO
            if totalCost < best['cost']:
                best['cost'] = totalCost
                best['history'] = history
            return

        # Recurse on children
        for action, newState, cost in problem.succAndCost(state=state):
            recurse(newState, history+[(action, newState, cost)], totalCost + cost)
    recurse(problem.startState(), history=[], totalCost=0)

    return best['cost'], best['history']


"""
Move from Exponential Time to Polynomial Time i.e. (Dynamic Programming)

Dynamic Programming

        state s
            |
        Cost(s, a)
            |
        FutureCost(s')
            |
        end state
Minimum cost path from state `s` to `a` end state

FutureCost(s) = {   0                                               if IsEnd(s)
                    min([Cost(s, a) + FutureCost(Succ(s, a))]       otherwise

Key Idea:
A `state` is a summary of all the past actions sufficient to
choose future actions optimally
"""

def dynamicProgramming(problem: TransportationProblem):
    cache = {} # state -> futureCost(state)
    def futureCost(state):
        # Base case
        if problem.isEnd(state=state):
            return 0
        if state in cache:  # exponential savings
            return cache[state]
        # actually doing work
        result = min(cost + futureCost(newState) for action, newState, cost in problem.succAndCost(state))
        cache[state] = result
        return result

    return futureCost(state=problem.startState()), []


"""
Assumptions: acyclicity
The state graph defined by Actions(s) and Succ(s, a) is acyclic.

To think about futureCost(s), you need to think about futureCost(s')
so there is natural ordering of states.

If cycles exist, there is no ordering.
"""

"""
Summary

State: summary of past acitons sufficient to choose future actions optimally
Dynamic Programming: backtracking search with memoization - potentially exponential savings

DP only works with acyclic graphs.. what if there are cycles?
"""

def uniformCostSearch(problem: TransportationProblem):

    frontier = PriorityQueue()
    frontier.update(problem.startState(), 0)
    while True:
        # Move from frontier to explored
        state, pastCost = frontier.removeMin()
        if problem.isEnd(state):
            return pastCost, []

        # Push out on the frontier
        for action, newState, cost in problem.succAndCost(state):
            frontier.update(newState, pastCost + cost)


"""
Analysis of uniform cost search

Theorem: correctness
When a state `s` is popped from the frontier and moved to the explored,
it's priority is PastCost(s), the minimum cost to `s`.
"""


### Main
problem = TransportationProblem(N=40)
printSolution(backtrackingSearch(problem))
printSolution(dynamicProgramming(problem))
printSolution(uniformCostSearch(problem))

"""
DP vs UCS
N total states, n of which are closer than end state

Algorithms  | Cycles?   | Action costs  | Time/Space
DP          | no        | any           | O(N)
UCS         | yes       | >=0           | O(nlogn)

Note: UCS potentially explores fewer states,
but requires more overhead to maintain the priority queue

Note: assume number of actions per state is constant (independent of n & N)

"""
