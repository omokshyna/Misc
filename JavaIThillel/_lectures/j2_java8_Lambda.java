package hillel;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class j2_java8_Lambda {

    public static void main(String... args) throws Exception {

        // Old way
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println(Thread.currentThread());
            }
        }).start();

        // New Way with Lambda;
        new Thread( () ->
            System.out.println(Thread.currentThread())
        ).start();

        // Custom filter
        System.out.println(filter(Arrays.asList(1, 2, 3, 4, 5), i -> i % 2 == 0));

    }

    @FunctionalInterface
    static interface Tester<T> {
        boolean test(T i);
    }

    static List<Integer> filter(List<Integer> l, Tester<Integer> p) {
        List<Integer> newL = new ArrayList<>();
        for (Integer i : l) {
            if (p.test(i)) {
                newL.add(i);
            }
        }
        return newL;
    }
}
