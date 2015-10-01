package hillel;

import java.util.Arrays;
import java.util.function.Consumer;
import java.util.function.Function;

public class j6_java8_Method_references {

    public static void main(String... args) {
        // Method reference

        Arrays.asList("a", "b", "c").stream().forEach(System.out::println);

        Consumer<String> f = System.out::println;
        f.accept("aaaaaaa");

        Function<String, Integer> convert = Integer::valueOf;
        System.out.println(convert.apply("102"));

        Function<String, String> c = String::toUpperCase;
        Function<String, Integer> c2 = String::length;
        System.out.println( c.andThen(c2).apply("abc") );
    }
}
