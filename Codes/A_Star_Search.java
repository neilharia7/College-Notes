import java.util.*;

/**
 * Created by Neil Haria on 2-08-2017.
 */
public class A_Star_Search {

    private static HashMap<Integer, Vertex> graph;
    private static HashMap<Vertex, Vertex> parent_vertex;
    private static HashSet<Vertex> visited_vertex;
    private static int nodes, edges, no_of_nodes_visited;
    private static List<Integer> path_cost;

    static class Vertex {
        int id, distance, heuristic_distance, final_dist;
        List<Edges> edge;

        Vertex(int c, int heuristic_dist) {
            this.id = c;
            this.distance = Integer.MAX_VALUE;
            this.heuristic_distance = heuristic_dist;
            this.edge = new ArrayList<>();
        }
    }

    static class Edges {
        Vertex u, v;
        int len;

        Edges(Vertex u, Vertex v, int length) {
            this.u = u;
            this.v = v;
            this.len = length;
        }

        Vertex getEndVertex() {
            return this.v;
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.println("Enter the number of nodes");
        nodes = sc.nextInt();
        System.out.println("Enter the number of edges");
        edges = sc.nextInt();

        graph = new HashMap<>();

        System.out.println("Enter the heuristic values of the nodes");
        for (int i = 1; i <= nodes; i++) {
            int heuristic = sc.nextInt();
            graph.put(i, new Vertex(i, heuristic));
        }

        System.out.println("Enter the source node");
        int source = sc.nextInt();
        System.out.println("Enter the destination node");
        int destination = sc.nextInt();

        System.out.println("Enter " + edges + " the connecting vertices and their weight");
        for (int i = 0; i < edges; i++) {
            int node_1 = sc.nextInt();
            int node_2 = sc.nextInt();
            int cost = sc.nextInt();

            // Connecting two nodes
            graph.get(node_1).edge.add(new Edges(graph.get(node_1), graph.get(node_2), cost));
            graph.get(node_1).edge.add(new Edges(graph.get(node_2), graph.get(node_1), cost));
        }

        System.out.println("Effective Cost: " + solve(source, destination));

        System.out.println("Total number of nodes visited: " + no_of_nodes_visited);
        System.out.println("Number of nodes in actual path: " + path_cost.size());

        // Printing the final path
        System.out.println("Shortest Path: ");
        for (int i = 0; i < path_cost.size() - 1; i++)
            System.out.print(path_cost.get(i) + " -> ");
        System.out.println(path_cost.get(path_cost.size() - 1));

        sc.close();
    }

    private static int solve(int source, int destination) {
        // Initially
        no_of_nodes_visited = 0;

        parent_vertex = new HashMap<>();
        visited_vertex = new HashSet<>();

        PriorityQueue<Vertex> priority_queue = new PriorityQueue<>(graph.size(),
                Comparator.comparingInt(a -> a.final_dist));

        for (int i : graph.keySet())
            graph.get(i).distance = Integer.MAX_VALUE;

        Vertex v = graph.get(source);
        // Initial distance
        v.distance = 0;
        // Using f(n) = g(n) + h(n)
        v.final_dist = v.distance + v.heuristic_distance;
        // System.out.println(" Test " + vertex.final_dist);

        // Pushing the source vertex in the priority queue
        priority_queue.offer(v);

        while (!priority_queue.isEmpty()) {

            // Retrieve and remove the head of the queue
            Vertex current_vertex = priority_queue.poll();
            no_of_nodes_visited++;

            if (!visited_vertex.contains(current_vertex)) {
                visited_vertex.add(current_vertex);

                if (current_vertex.id == destination) {
                    createRoute(source, destination);
                    return current_vertex.distance;
                }

                for (Edges e : current_vertex.edge) {
                    Vertex vertex = e.getEndVertex();

                    if (!visited_vertex.contains(vertex)) {
                        if (vertex.distance > current_vertex.distance + e.len) {
                            vertex.distance = current_vertex.distance + e.len;
                            // Using f(n) = g(n) + h(n)
                            vertex.final_dist = vertex.distance + vertex.heuristic_distance;
                            // System.out.println(" Test " + vertex.final_dist);

                            parent_vertex.put(vertex, current_vertex);
                            if (priority_queue.contains(graph.get(vertex.id))) {
                                priority_queue.remove(graph.get(vertex.id));
                            }

                            priority_queue.offer(vertex);
                        }
                    }
                }
            }
        }
        return -1;
    }

    private static void createRoute(int source, int destination) {
        path_cost = new LinkedList<>();
        Vertex current = graph.get(destination);

        path_cost.add(0, current.id);
        while (current != graph.get(source)) {
            current = parent_vertex.get(current);
            path_cost.add(0, current.id);
        }
    }
}

/*
OUTPUT
Enter the number of nodes
5
Enter the number of edges
6
Enter the heuristic values of the nodes
7 10 9 5 0
Enter the source node
1
Enter the destination node
5
Enter 6 the connecting vertices and their weight
1 2 1
1 3 1
2 3 9
3 4 6
3 5 12
4 5 5

Effective Cost: 12
Total number of nodes visited: 5
Number of nodes in actual path: 4
Shortest Path:
1 -> 3 -> 4 -> 5

 */
