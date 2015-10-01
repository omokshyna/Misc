package hillel;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Function;

public class j3_java8_Collections_streams {

    public static void main(String... args) {

        List<String> l = new ArrayList<>();
        l.add("hello");
        l.add("world");
        l.add("hi");

        // Print words that starts with "h"
        l.stream().filter(e -> e.startsWith("h")).forEach(e -> System.out.println(e));

        System.out.println();

        // Reverse all strings
        l.stream().map(e -> new StringBuffer(e).reverse().toString()).forEach(e -> System.out.println(e));

        System.out.println();



    }
}
