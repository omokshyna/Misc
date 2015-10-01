package hillel;


public class j4_java8_Default_method {
    static interface A {

        static String upper (String s) {
            return s.toUpperCase();
        }

        String transform(String s);

        default String toTransformedString(String s) {
            return transform(s);
        }
    }

    static class B implements A {
        @Override
        public String transform(String s) {
            return s.concat("!!");
        }
    }

    public static void main(String... args) throws Exception {
        B b = new B();
        System.out.println(A.upper("hello"));

        System.out.println(b.toTransformedString("cool"));
    }
}
