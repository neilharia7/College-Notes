import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Random;

/**
 * Created by Neil Haria on 25-07-2017.
 */
class RandomNumberGeneration {
    private static int random() {
        Random r = new Random();
        return r.nextInt(100 + 1) + 1;
    }

    private static int gcd(int p, int q) {return q == 0 ? p : gcd(q, p%q);}

    // For case 1 & 2
    private static boolean IsPowerOfTwo(int x) {
        return (x != 0) && ((x & (x - 1)) == 0);
    }

    private static int findPower(int m) {
        for (int i = 1; ; i++) {
            if (m == 1<<i)
                return i;
        }
    }

    private static boolean is_Prime(int m) {
        if (m < 2) return false;
        if (m < 4) return true; // 2 and 3
        if (m % 2 == 0 || m % 3 == 0) return false;
        if (m < 25) return true; // 5, 7, 11, 13, 17, 19 and 23
        for (int i = 5; i*i <= m; i += 6)
            if (m % i == 0 || m % (i + 2) == 0) return false;
        return true;
    }

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

        boolean flag = false;

        System.out.println("Enter value of m");
        int m = Integer.parseInt(br.readLine());

        System.out.println("Enter value of a");
        int a = Integer.parseInt(br.readLine());

        System.out.println("Enter the value of c");
        int c = Integer.parseInt(br.readLine());

        System.out.println("Enter the value of x0");
        int x0 = Integer.parseInt(br.readLine());
        double sum = 0;
        int k = 0;

        if (IsPowerOfTwo(m) && (c!= 0) && (gcd(m, c) == 1)) {
            for (int i = 0; ; i++) {
                int q = 1 + 4 * i;
                if (a == q) {
                    flag = true;
                    break;
                }
                else if (q > a)
                    break;
            }
            if (flag) {
                /**
                 * Case 1:
                 * For m, a power of 2 (m = 2^b) and c≠0 period p = 2^b is achieved
                 * provided c is relatively prime to m and a = 1+4k , k = 0,1,2,...
                 *
                 * output:
                 * m: 128
                 * a: 1, 5, 9, ...
                 * c: 1
                 * x0: any val
                 */
                double[] random_array = new double[m];
                double[] x_array = new double[m];
                x_array[0] = x0;
                random_array[0] = x0/m;
                System.out.println("Only Case 1 Satisfied\n");
                for (int i = 1; i < m; i++) {
                    for (int j = 0; j < m; j++) {
                        a = 1 + 4 * k;
                        k = random();
                        x_array[i] = (x_array[i - 1] * a + c) % m;
                        // System.out.print(x_array[i] + " ");
                        random_array[i] = x_array[i] / m;
                    }
                }
                Arrays.sort(random_array);
                System.out.print(random_array[0] + " ");
                for (int i = 1; i < m; i++) {
                    sum += Math.abs(random_array[i] - random_array[i - 1]);
                    System.out.print(random_array[i] + "\t");
                    // To print 10 numbers in a line
                    if (i%10 == 0) {
                        System.out.println();
                    }
                }
                System.out.println("\nSum: " + sum);
                System.out.println("Period: " + m);
                System.out.println("Density is : " + sum / m);
            }
        }
        else if (IsPowerOfTwo(m) && (c == 0) && (x0 % 2 ==0)) {
            for (int i = 0; ; i++) {
                int q = 3 + 8 * i;
                int r = 5 + 8 * i;
                if (a == q || a == r) {
                    flag = true;
                    break;
                }
                else if (q > a || r > a)
                    break;
            }
            if (flag) {
                /**
                 * Case 2:
                 * For m = 2^b and c = 0 , period p = 2^(b-2) is achieved provided X0
                 * is odd and multiplier a = 3+8k or a = 5+8k , k = 0,1,2,...
                 *
                 * output:
                 * m: 128
                 * a: 3, 5, 11, 13, ...
                 * c: 0
                 * x0: 2, 4, 6, ...
                 */
                int count = (int) Math.pow(2, findPower(m) - 2);
                /*
                System.out.println("Power of 2: " + findPower(m));
                System.out.println("Count: " + count);
                 */
                double[] random_array = new double[m];
                double[] x_array = new double[m];
                x_array[0] = x0;
                random_array[0] = x0/m;

                System.out.println("Only Case 2 Satisfied\n");
                for (int i = 1; i < count; i++) {
                    a = 5 + 8 * k; // or a = 3 + 8 * k;
                    k = random();
                    x_array[i] = (x_array[i - 1] * a + c) % m;
                    // System.out.print(x_array[i] + " ");
                    System.out.print(x_array[i] + " ");
                    random_array[i] = x_array[i] / m;
                }
                //System.out.println();
                sum = 0;
                Arrays.sort(random_array);
                System.out.print(random_array[0] + " ");
                for (int i = 1; i < count; i++) {
                    sum += Math.abs(random_array[i] - random_array[i - 1]);
                    System.out.print(random_array[i] + " ");
                }
                // Sum & Density results to 0 if sorted else 0.31...
                System.out.println("\nSum: " + sum);
                System.out.println("Period: " + count);
                System.out.println("Density is : " + sum / count);
            }
        }
        else if (is_Prime(m) && (c == 0)) {
            /**
             * For m a prime number and c = 0, period p = m-1 is achieved provided a has the
             * property that the smallest integer is such that a k-1
             * is divisible by m is k = m-1.
             *
             * output:
             * m: 5
             * a: 2, 3, 4, 6, .... except multiples of m
             * c: 0
             * x0: any val
             */
            System.out.println("Only Case 3 Satisfied\n");
            k = m - 1;
            System.out.println("Value of k: " + k);
            int count;
            if ((Math.pow(a, k) - 1)% m == 0) {
                count = m-1;
                double[] random_array = new double[count];
                double[] x_array = new double[count];
                x_array[0] = x0;
                random_array[0] = x0/count;
                for (int i = 1; i < count; i++) {
                    a = 3 + 8 * k;
                    k = random();
                    x_array[i] = (x_array[i - 1] * a + c) % m;
                    System.out.print("shit: " +x_array[i] + " ");
                    random_array[i] = x_array[i] / m;
                }
                sum = 0;
                //Arrays.sort(random_array);
                System.out.print(random_array[0] + " ");
                for (int i = 1; i < count; i++) {
                    sum += Math.abs(random_array[i] - random_array[i - 1]);
                    System.out.print(random_array[i] + " ");
                }
                System.out.println("\nSum: " + sum);
                System.out.println("Period: " + count);
                System.out.println("Density is : " + sum / count);
            }
        }
    }
}
