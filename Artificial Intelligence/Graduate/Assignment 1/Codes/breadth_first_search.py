from collections import deque

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


def bfs(start_city, goal_city):
    """
    Breadth-first search algorithm
    :param start_city: The city name from where the search starts
    :param goal_city: The city name where the search ends
    :return: 
    """

    # to keep track of the visited nodes
    visited_cities = set()

    # to keep track of the paths to explore
    queue = deque([[start_city]])

    while queue:
        path = queue.popleft()
        # we pick the city from the queue to navigate the paths
        city = path[-1]

        # base condition
        # check if the current city is the goal city
        if city == goal_city:
            return path

        if city not in visited_cities:
            # mark the city as visited by adding it to the visited set
            visited_cities.add(city)

            # add the next possible cities to the queue by exploring the neighbor cities of the current city
            for neighbor_city in romania_map[city]:
                new_path = path + [neighbor_city]
                queue.append(new_path)
    # if no path is found
    return None
