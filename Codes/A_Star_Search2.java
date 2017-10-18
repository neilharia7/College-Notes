import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Scanner;

/**
 * Created by Neil Haria on 07-08-2017.
 */
class A_Star_Search2 {

    private static int row, column, source, destination, min_cost_node;
    private static String starting_node, destination_node;
    private static double[][] cost_matrix;

    private static ArrayList<String> node_list = new ArrayList<>();
    private static Queue open_list = new LinkedList();
    private static double[] total_cost;
    private static double[] heuristic_cost;
    private static boolean[] visited;
    private static boolean reached_destination;
    private static int[] parent_node;


    public static void main(String[] args)throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        Scanner sc = new Scanner(System.in);
        String str;
        System.out.println("Enter the dimensions of the graph");
        row = sc.nextInt();
        column = sc.nextInt();

        cost_matrix = new double[row][column];
        total_cost = new double[row];

	// get the starting and ending char from user
        System.out.println("Enter the starting point");
        starting_node = sc.next();
        System.out.println("Enter the destination point");
        destination_node = sc.next();

	// Initial setting
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < column; j++) {
                cost_matrix[i][j] = -1;
            }
            total_cost[i] = Double.MAX_VALUE;
        }

        System.out.println("Enter the edges");
        int edges = sc.nextInt();
        sc.nextLine();

        System.out.println("Enter " + edges + " connecting nodes and the weight of the same");
        for (int i = 0; i < edges; i++) {
            str = br.readLine();
            String[] edge = str.split(" ");
            if (!node_list.contains(edge[0]))
                node_list.add(edge[0]);
            if (!node_list.contains(edge[1]))
                node_list.add(edge[1]);

            // Connecting two nodes
            cost_matrix[node_list.indexOf(edge[0])][node_list.indexOf(edge[1])] =
                    Double.parseDouble(edge[2]);
            cost_matrix[node_list.indexOf(edge[1])][node_list.indexOf(edge[0])] =
                    Double.parseDouble(edge[2]);
        }

        heuristic_cost = new double[row];
        System.out.println("Enter " + row + " nodes associated with their heuristic values");
        for (int i = 0; i < row; i++) {
            str = br.readLine();
            String[] value = str.split(" ");
	    // adding heuritic cost to array
            heuristic_cost[node_list.indexOf(value[0])] = Double.parseDouble(value[1]);
        }

        visited = new boolean[row];
        parent_node = new int[row];
        source = node_list.indexOf(starting_node);
        destination = node_list.indexOf(destination_node);

        visited[source] = true;
        open_list.add(node_list.get(source));
        total_cost[source] = 0;

        start_Searching();
    }

    private static int find_minimum_cost_node() {
        int min_Index = -1;
        double min_Value = Double.MAX_VALUE;
        for (int i = 0; i < total_cost.length; i++) {
            if (total_cost[i] < min_Value && open_list.contains(node_list.get(i))) {
                min_Value = total_cost[i];
                min_Index = i;
            }
        }
        return min_Index;
    }

    private static void start_Searching() {
        while (!reached_destination) {
            if (!open_list.isEmpty()) {
                min_cost_node = find_minimum_cost_node();

                if (destination != min_cost_node) {
                    open_list.remove(node_list.get(min_cost_node));

                    for (int i = 0; i < row; i++) {
                        double temp_cost = cost_matrix[i][min_cost_node];

                        if (temp_cost != -1 && !visited[i]) {
                            open_list.add(node_list.get(i));

                            if (source != min_cost_node) {
                                total_cost[i] = heuristic_cost[i]
                                        + temp_cost
                                        + total_cost[min_cost_node]
                                        - heuristic_cost[min_cost_node];
                            }
                            else {
                                total_cost[i] = heuristic_cost[i]
                                        + temp_cost;
                            }

                            // Test
                            // System.out.println(total_cost[i]);
                            visited[i] = true;
                            parent_node[i] = min_cost_node;
                        }
                    }
                }
                else {
                    reached_destination = true;
		    
                    //System.out.println("Destination reached !!");
                    break;
                }
            }
        }
        if (reached_destination) {
            // Printing shortest path
            String path = " -> " + node_list.get(destination);
            int parent_index, current_index = destination;
            double effective_cost = total_cost[destination];
            while ((parent_index = parent_node[current_index]) != source) {
                path = " -> " + node_list.get(parent_index) + path;
                current_index = parent_index;
            }

            path = node_list.get(source) + path;
            System.out.println("Shortest path: " + path);
            System.out.println("Effective Cost: " + effective_cost);
        }
    }
}
/*

Test Case

Enter the dimensions of the graph
7 7
Enter the starting point
s
Enter the destination point
f
Enter the edges
7
Enter 7 connecting nodes and the weight of the same
s d 2
s a 1.5
a b 2
b c 3
c f 4
e f 2
d e 3
Enter 7 nodes associated with their heuristic values
s 10
a 4
b 2
c 4
e 2
d 4.5
f 0
Destination reached !!
Shortest path: s -> d -> e -> f
Effective Cost: 7.0

*/
