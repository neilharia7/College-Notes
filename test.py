# from queue import PriorityQueue
#
#
# def a_star(start_city, goal_city, heuristics, graph):
#     """
#     :param start_city: the starting city
#     :param goal_city: the city where we want to reach
#     :param heuristics: a dictionary containing the heuristic values for each city
#     :param graph: a dictionary representing the graph
#     :return: path from start city to goal city or None if no path found
#     """
#     # to keep track of the visited nodes
#     visited = set()
#
#     # to keep track of the paths to explore
#     queue = PriorityQueue()
#     queue.put((0, [start_city]))
#     total_cost = 0
#
#     while not queue.empty():
#         cost, path = queue.get()
#         city = path[-1]
#
#         # check if the current city is the goal city
#         if city == goal_city:
#             return path, total_cost
#
#         if city not in visited:
#             # mark the city as visited by adding it to the visited set
#             visited.add(city)
#
#             # add the next possible cities to the queue by exploring the neighbor cities of the current city
#             for neighbor_city in graph[city]:
#                 new_path = path + [neighbor_city]
#                 # the cost to reach the neighbor city
#                 new_cost = cost  # assuming each edge has a cost of 1
#                 print("cost", cost, "path", new_path, "neighbor_city", neighbor_city)
#                 # the total cost is the cost to reach the neighbor city plus the heuristic value
#                 total_cost = new_cost + heuristics[neighbor_city]
#                 queue.put((total_cost, new_path))
#
#     # if no path is found
#     return None, -1
#
# straight_line_distance_to_bucharest = {
#     'Oradea': 380,
#     'Zerind': 374,
#     'Arad': 366,
#     'Timisoara': 329,
#     'Lugoj': 244,
#     'Mehadia': 241,
#     'Drobeta': 242,
#     'Craiova': 160,
#     'Rimnicu Vilcea': 193,
#     'Sibiu': 253,
#     'Fagaras': 176,
#     'Pitesti': 98,
#     'Bucharest': 0,
#     'Giurgiu': 77,
#     'Urziceni': 80,
#     'Hirsova': 151,
#     'Eforie': 161,
#     'Vaslui': 199,
#     'Iasi': 226,
#     'Neamt': 234
# }
#
romanian_map = {
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

#
# response, cost = a_star('Arad', 'Bucharest', straight_line_distance_to_bucharest, romanian_map)
# print(' -> '.join(response), cost)

def heuristic_1(city, goal_city, sld_to_bucharest):
    """
    Heuristic 1: Using the SLD to Bucharest as an intermediary.
    """
    return abs(sld_to_bucharest[city] - sld_to_bucharest[goal_city])

def heuristic_2(city, goal_city, sld_to_bucharest):
    """
    Heuristic 2: Using the minimum SLD via Bucharest.
    """
    return min(sld_to_bucharest[city] + sld_to_bucharest[goal_city], sld_to_bucharest[city])

# Example usage:
sld_to_bucharest = {
    'Oradea': 380,
    'Zerind': 374,
    'Arad': 366,
    'Timisoara': 329,
    'Lugoj': 244,
    'Mehadia': 241,
    'Drobeta': 242,
    'Craiova': 160,
    'Rimnicu Vilcea': 193,
    'Sibiu': 253,
    'Fagaras': 176,
    'Pitesti': 98,
    'Bucharest': 0,
    'Giurgiu': 77,
    'Urziceni': 80,
    'Hirsova': 151,
    'Eforie': 161,
    'Vaslui': 199,
    'Iasi': 226,
    'Neamt': 234
}

# Testing the heuristics
city = 'Arad'
goal_city = 'Craiova'
print("Heuristic 1:", heuristic_1(city, goal_city, sld_to_bucharest))
print("Heuristic 2:", heuristic_2(city, goal_city, sld_to_bucharest))

from queue import PriorityQueue


def a_star(start_city, goal_city, heuristic_func, sld_to_bucharest, graph):
    """
    A* search algorithm.
    """
    queue = PriorityQueue()
    queue.put((0, [start_city]))
    visited = set()

    heuristic_cost = 0

    while not queue.empty():
        cost, path = queue.get()
        city = path[-1]

        if city == goal_city:
            return path, heuristic_cost

        if city not in visited:
            visited.add(city)

            for neighbor in graph[city]:
                new_path = path + [neighbor]
                heuristic_cost = cost + heuristic_func(neighbor, goal_city, sld_to_bucharest)
                queue.put((heuristic_cost, new_path))

    return None


# Example usage of A* with heuristic 1
response, cost = a_star('Arad', 'Craiova', heuristic_1, sld_to_bucharest, romanian_map)
print(' -> '.join(response), cost)

# Example usage of A* with heuristic 2
response, cost = a_star('Arad', 'Craiova', heuristic_2, sld_to_bucharest, romanian_map)
print(' -> '.join(response), cost)