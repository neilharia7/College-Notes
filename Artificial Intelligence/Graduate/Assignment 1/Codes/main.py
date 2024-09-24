import math
import random
from collections import deque
from time import time_ns
from queue import PriorityQueue

from matplotlib import pyplot as plt


class Data:
    def __init__(self):
        self.__romania_map = {
            'Arad': [('Zerind', 75), ('Sibiu', 140), ('Timisoara', 118)],
            'Zerind': [('Oradea', 71), ('Arad', 75)],
            'Oradea': [('Zerind', 71), ('Sibiu', 151)],
            'Sibiu': [('Oradea', 151), ('Arad', 140), ('Fagaras', 99), ('Rimnicu Vilcea', 80)],
            'Timisoara': [('Arad', 118), ('Lugoj', 111)],
            'Lugoj': [('Timisoara', 111), ('Mehadia', 70)],
            'Mehadia': [('Lugoj', 70), ('Drobeta', 75)],
            'Drobeta': [('Mehadia', 75), ('Craiova', 120)],
            'Craiova': [('Drobeta', 120), ('Rimnicu Vilcea', 146), ('Pitesti', 138)],
            'Rimnicu Vilcea': [('Sibiu', 80), ('Craiova', 146), ('Pitesti', 97)],
            'Pitesti': [('Rimnicu Vilcea', 97), ('Craiova', 138), ('Bucharest', 101)],
            'Fagaras': [('Sibiu', 99), ('Bucharest', 211)],
            'Bucharest': [('Fagaras', 211), ('Pitesti', 101), ('Giurgiu', 90), ('Urziceni', 85)],
            'Giurgiu': [('Bucharest', 90)],
            'Urziceni': [('Bucharest', 85), ('Hirsova', 98), ('Vaslui', 142)],
            'Hirsova': [('Urziceni', 98), ('Eforie', 86)],
            'Eforie': [('Hirsova', 86)],
            'Vaslui': [('Urziceni', 142), ('Iasi', 92)],
            'Iasi': [('Vaslui', 92), ('Neamt', 87)],
            'Neamt': [('Iasi', 87)]
        }

        self.__straight_line_distance_to_bucharest = {
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

        self.__city_coordinates = {
            'Oradea': (47.0465, 21.9189),
            'Zerind': (46.6333, 21.5167),
            'Arad': (46.1667, 21.3167),
            'Timisoara': (45.7597, 21.2300),
            'Lugoj': (45.6900, 21.9000),
            'Mehadia': (44.9000, 22.3500),
            'Drobeta': (44.6369, 22.6597),
            'Craiova': (44.3302, 23.7949),
            'Rimnicu Vilcea': (45.0997, 24.3693),
            'Sibiu': (45.7970, 24.1519),
            'Fagaras': (45.8416, 24.9731),
            'Pitesti': (44.8606, 24.8678),
            'Bucharest': (44.4268, 26.1025),
            'Giurgiu': (43.9000, 25.9667),
            'Urziceni': (44.7167, 26.6333),
            'Hirsova': (44.6893, 27.9457),
            'Eforie': (44.0584, 28.6336),
            'Vaslui': (46.6407, 27.7276),
            'Iasi': (47.1585, 27.6014),
            'Neamt': (46.9759, 26.3819),
        }

    def get_romania_map(self):
        return self.__romania_map

    def get_straight_line_distance_to_bucharest(self):
        return self.__straight_line_distance_to_bucharest

    # Heuristic 1: Euclidean distance (Straight-Line distance)
    def euclidean_distance(self, city1: str, city2: str) -> float:
        """
        Calculate the Euclidean distance between two cities based on their coordinates.

        :param city1: The name of the first city.
        :param city2: The name of the second city.
        :return: The Euclidean distance between the two cities.
        """
        x1, y1 = self.__city_coordinates[city1]
        x2, y2 = self.__city_coordinates[city2]
        return math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)

    # Heuristic 2: Manhattan distance
    def manhattan_distance(self, city1: str, city2: str) -> float:
        """
        Calculate the Manhattan distance between two cities based on their coordinates.

        :param city1: The name of the first city.
        :param city2: The name of the second city.
        :return: The Manhattan distance between the two cities.
        """
        x1, y1 = self.__city_coordinates[city1]
        x2, y2 = self.__city_coordinates[city2]
        return abs(x1 - x2) + abs(y1 - y2)

    def heuristic_func(self, neighbor: str, target_city: str, heuristic: int):
        """

        :param neighbor:
        :param target_city:
        :param heuristic:
        :return:
        """

        if heuristic == 1:
            return self.euclidean_distance(neighbor, target_city)
        return self.manhattan_distance(neighbor, target_city)


class Search:

    def __init__(self):
        self.grid = Data().get_romania_map()
        self.sld_to_bucharest = Data().get_straight_line_distance_to_bucharest()

    def bfs(self, start_city: str, goal_city: str):
        """

        :param start_city: The starting city
        :param goal_city: The destination city to reach.
        :return: Tuple containing the path from start_city to goal_city and the total cities visited,
                    or (None, total cities visited) if no path found.
        """

        # to keep track of the visited nodes
        visited = set()
        cities_scanned = 0

        # to keep track of the paths to explore
        queue = deque([[start_city]])

        while queue:
            path = queue.popleft()
            city = path[-1]

            # check if the current city is the goal_city city
            if city == goal_city:
                return path, cities_scanned

            if city not in visited:
                # mark the city as visited by adding it to the visited set
                visited.add(city)
                cities_scanned += 1

                # add the next possible cities to the queue by exploring the neighbor cities of hte current city
                for neighbor_city in self.grid[city]:
                    new_path = path + [neighbor_city[0]]
                    queue.append(new_path)

        # if no path is found
        return None, cities_scanned

    def dfs(self, start_city: str, goal_city: str):
        """

        :param start_city: the starting city
        :param goal_city: The destination city to reach.
        :return: Tuple containing the path from start_city to goal_city and the total cities visited,
                    or (None, total cities visited) if no path found.
        """
        # to keep track of the visited nodes
        visited = set()
        cities_scanned = 0

        # to keep track of the paths to explore
        stack = [[start_city]]

        while stack:
            # pop the last path
            path = stack.pop()
            city = path[-1]

            # check if the current city is the goal_city city
            if city == goal_city:
                return path, cities_scanned

            if city not in visited:
                # mark the city as visited by adding it to the visited set
                visited.add(city)
                cities_scanned += 1

                # add the next possible cities to the stack by exploring the neighbor cities of the current city
                for neighbor_city in self.grid[city]:
                    new_path = path + [neighbor_city[0]]
                    stack.append(new_path)

        # if no path is found
        return None, cities_scanned

    def best_first_search(self, start_city, goal_city, heuristic: int):
        """
        (Greedy Best First Search)

        :param start_city: The starting city.
        :param goal_city: The destination city to reach.
        :param heuristic: The type of heuristic function to use (1 for Euclidean distance, 2 for Manhattan distance).
        :return: Tuple containing the path from start_city to goal_city and the total cost of the path,
                    or (None, float('inf')) if no path found.
        """

        # to keep track of the paths to explore
        queue = PriorityQueue()
        queue.put((0, [start_city]))

        # Store cost from start to each city
        g_cost = {start_city: 0}

        # Store parent for each city to reconstruct the path
        parents = {start_city: None}

        while not queue.empty():
            _, path = queue.get()
            city = path[-1]

            # check if the current city is the goal_city city
            if city == goal_city:
                return path, g_cost[goal_city]

            # add the next possible cities to the queue by exploring the neighbor cities of the current city
            for neighbor_city, distance in self.grid[city]:

                # Calculate tentative g(n) for the neighbor_city
                tentative_distance = g_cost[city] + distance

                if neighbor_city not in parents or tentative_distance < g_cost[neighbor_city]:
                    # Update the cost to reach this neighbor
                    g_cost[neighbor_city] = tentative_distance

                    # Calculate the priority based only on the heuristic
                    priority = Data().heuristic_func(neighbor_city, goal_city, heuristic)
                    queue.put((priority, path + [neighbor_city]))

                    # Keep track of how we got to this neighbor
                    parents[neighbor_city] = city

        # if no path is found
        return None, float('inf')

    def a_star_search(self, start_city: str, goal_city: str, heuristic: int):
        """
        Perform A* search algorithm to find the shortest path from start_city to goal_city using a heuristic function.

        :param start_city: The starting city.
        :param goal_city: The destination city to reach.
        :param heuristic: The type of heuristic function to use (1 for Euclidean distance, 2 for Manhattan distance).
        :return: Tuple containing the path from start_city to goal_city and the total cost of the path,
                    or (None, float('inf')) if no path found.
        """

        queue = PriorityQueue()
        queue.put((0, start_city))

        # Store parent for each city to reconstruct the path
        parents = {start_city: None}

        # Store cost from start to each city
        g_cost = {start_city: 0}

        while not queue.empty():
            # Get the city with the lowest f(n) (g + h)
            _, current_city = queue.get()

            # check if the current city is the goal_city city
            if current_city == goal_city:
                path = []

                while current_city is not None:
                    path.append(current_city)
                    current_city = parents[current_city]

                return path[::-1], g_cost[goal_city]

            # Evaluate neighbors of the current city
            for neighbor_city, distance in self.grid[current_city]:

                # Calculate tentative g(n) for the neighbor_city
                tentative_distance = g_cost[current_city] + distance

                # If we haven't visited this neighbor yet, or if this path is better
                if neighbor_city not in g_cost or tentative_distance < g_cost[neighbor_city]:
                    # Update the cost to reach this neighbor
                    g_cost[neighbor_city] = tentative_distance

                    # Calculate the priority (f-score) for this neighbor
                    # f-score = g-score (cost so far) + h-score (heuristic estimate)
                    f_cost = tentative_distance + Data().heuristic_func(neighbor_city, goal_city, heuristic)
                    queue.put((f_cost, neighbor_city))

                    # Keep track of how we got to this neighbor
                    parents[neighbor_city] = current_city

        # if no path is found
        return None, float('inf')


def run_searches(iterations: int = 100, debug: bool = False):
    # for plotting data points on the graph
    bfs_times = []
    dfs_times = []
    best_first_search_times = []
    astar_times = []

    cities = [city for city in Data().get_romania_map().keys()]

    for _ in range(iterations):
        current_city = random.choice(cities)
        goal_city = random.choice(cities)

        start_bfs_time = time_ns()
        bfs_path, bfs_cities_scanned = Search().bfs(start_city=current_city, goal_city=goal_city)
        bfs_times.append(time_ns() - start_bfs_time)

        start_dfs_time = time_ns()
        dfs_path, dfs_cities_scanned = Search().dfs(start_city=current_city, goal_city=goal_city)
        dfs_times.append(time_ns() - start_dfs_time)

        start_best_first_search_time = time_ns()
        gbfs_path, gbfs_cost = Search().best_first_search(
            start_city=current_city, goal_city=goal_city, heuristic=random.choice([1, 2]))
        best_first_search_times.append(time_ns() - start_best_first_search_time)

        start_astar_time = time_ns()
        path, cost = Search().a_star_search(
            start_city=current_city, goal_city=goal_city, heuristic=random.choice([1, 2]))
        astar_times.append(time_ns() - start_astar_time)

        if debug:
            print('Current City:', current_city, 'Goal City:', goal_city)
            print(' * ' * 15 + ' BFS ' + ' *' * 15)
            print('BFS Path', bfs_path)
            print('Cities scanned', bfs_cities_scanned)
            print(' - ' * 32)
            print(' * ' * 15 + ' DFS ' + ' * ' * 15)
            print('DFS Path', dfs_path)
            print('Cities scanned', dfs_cities_scanned)
            print(' - ' * 32)
            print(' * ' * 15 + ' GBFS ' + ' * ' * 15)
            print('GBFS Path', gbfs_path)
            print('Cost', gbfs_cost)
            print(' - ' * 32)
            print(' * ' * 15 + ' A Star ' + ' * ' * 15)
            print('A star Path', path)
            print('Cost', cost)
            print(' - ' * 32)

    return bfs_times, dfs_times, best_first_search_times, astar_times


def plot_results(**kwargs):
    plt.figure(figsize=(12, 8))

    for key, value in kwargs.items():
        plt.plot(value, label=key.replace('_', ' ').capitalize())

    plt.xlabel('Iterations')
    plt.ylabel('Time (Nanoseconds)')
    plt.title('Search Algorithm Performance Comparison')
    plt.legend()
    plt.show()


if __name__ == '__main__':
    bfs, dfs, gbfs, astar = run_searches(iterations=100)
    plot_results(breath_first_search=bfs, depth_first_search=dfs, best_first_search=gbfs, a_star=astar)
