from collections import deque

# Romania map represented as a graph (Adjacency List)
romania_map = {
    'Arad': ['Zerind', 'Timisoara', 'Sibiu'],
    'Zerind': ['Arad', 'Oradea'],
    'Oradea': ['Zerind', 'Sibiu'],
    'Timisoara': ['Arad', 'Lugoj'],
    'Lugoj': ['Timisoara', 'Mehadia'],
    'Mehadia': ['Lugoj', 'Dobreta'],
    'Dobreta': ['Mehadia', 'Craiova'],
    'Craiova': ['Dobreta', 'Rimnicu Vilcea', 'Pitesti'],
    'Sibiu': ['Arad', 'Oradea', 'Fagaras', 'Rimnicu Vilcea'],
    'Fagaras': ['Sibiu', 'Bucharest'],
    'Rimnicu Vilcea': ['Sibiu', 'Craiova', 'Pitesti'],
    'Pitesti': ['Rimnicu Vilcea', 'Craiova', 'Bucharest'],
    'Bucharest': ['Fagaras', 'Pitesti']
}


# BFS function to find the path
def bfs(start, goal):
    # Queue to keep track of paths to explore
    queue = deque([[start]])
    # Set to keep track of visited nodes
    visited = set()

    # While there are paths to explore
    while queue:
        # Get the first path from the queue
        path = queue.popleft()
        # Get the last node from the path
        node = path[-1]

        # If node is the goal, return the path
        if node == goal:
            return path

        # If the node has not been visited yet
        if node not in visited:
            # Mark the node as visited
            visited.add(node)
            # Explore neighbors and add new paths to the queue
            for neighbor in romania_map[node]:
                new_path = list(path)  # Copy the current path
                new_path.append(neighbor)  # Add the neighbor to the path
                queue.append(new_path)

    return None  # Return None if no path is found


# Example usage:
start_city = 'Arad'
goal_city = 'Bucharest'
path = bfs(start_city, goal_city)

if path:
    print(f"Path from {start_city} to {goal_city}: {path}")
else:
    print(f"No path found from {start_city} to {goal_city}")
