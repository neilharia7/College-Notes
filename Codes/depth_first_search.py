romania_map = {
    'Oradea': ['Zerind', 'Sibiu'],
    'Zerind': ['Arad', 'Oradea'],
    'Arad': ['Timisoara', 'Sibiu', 'Zerind'],
    'Timisoara': ['Arad', 'Lugoj'],
    'Lugoj': ['Mehadia', 'Timisoara'],
    'Mehadia': ['Drobeta', 'Lugoj'],
    'Drobeta': ['Mehadia', 'Craiova'],
    'Craiova': ['Drobeta', 'Rimnicu Vilcea', 'Pitesti'],
    'Rimnicu Vilcea': ['Sibiu', 'Craiova', 'Pitesti'],
    'Sibiu': ['Oradea', 'Arad', 'Fagaras', 'Rimnicu Vilcea'],
    'Fagaras': ['Sibiu', 'Bucharest'],
    'Pitesti': ['Rimnicu Vilcea', 'Craiova', 'Bucharest'],
    'Bucharest': ['Fagaras', 'Pitesti', 'Giurgiu', 'Urziceni'],
    'Giurgiu': ['Bucharest'],
    'Urziceni': ['Vaslui', 'Bucharest', 'Hirsova'],
    'Hirsova': ['Urziceni', 'Eforie'],
    'Eforie': ['Hirsova'],
    'Vaslui': ['Iasi', 'Urziceni'],
    'Iasi': ['Vaslui', 'Neamt'],
    'Neamt': ['Iasi']
}


def dfs(start_city, goal_city):
    """

    :param start_city: the starting city
    :param goal_city: the city where we want to reach

    :return: path from start_city city to goal_city city or None if no path found
    """

    # to keep track of the visited nodes
    visited = set(start_city)

    # to keep track of the paths to explore
    stack = [[start_city]]

    while stack:
        # pop the last path
        path = stack.pop()
        city = path[-1]

        # check if the current city is the goal_city city
        if city == goal_city:
            return path

        if city not in visited:
            # mark the city as visited by adding it to the visited set
            visited.add(city)

            # add the next possible cities to the stack by exploring the neighbor cities of the current city
            for neighbor_city in romania_map[city]:
                new_path = path + [neighbor_city]
                stack.append(new_path)

    # if no path is found
    return None
