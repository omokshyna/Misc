import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @Author Elena Mokshyna
 */

/**
 * Gives information about methods and fields of some class
 * by first letters of their names
 */
public class Reflector {

    private String className;
    private String methodPattern;
    private Scanner sc;

    /**
     * Setter for the className
     */

    private void setClassName() {
        System.out.println("Enter class name: ");
        className = sc.nextLine();

    }


    /**
     *
     */

    private String getArgs(Method method) {
        String out = "(";
        for (Class b: method.getParameterTypes()) {
            out = new StringBuilder().append(out).append(b.getName() +  ", ").toString();

        }
        out = new StringBuilder().append(out).append(")").toString();
        return out;
    }




    /**
     * Function that finds methods and fields in some class c
     * and prints information about these methods and fields to the console
     * @param c
     */
    private void findMatch(Class c) {
        System.out.println("Enter first chars of method or field: ");
        methodPattern = sc.nextLine();

        Pattern p = Pattern.compile("^" + methodPattern + ".*");

        for (Method m : c.getMethods()) {
            Matcher match = p.matcher(m.getName());
            if(match.find()) {
                String args = getArgs(m);


                System.out.println(m.getReturnType().getName() + " " + m.getName() + args);
            }
        }

        //Prints type and name for field
        for (Field f : c.getFields()) {
            Matcher match = p.matcher(f.getName());
                if(match.find()) {
                    System.out.println(f.getType() + f.getName());
                }
            }

    }

    public void run() {
            try {
                    sc = new Scanner(System.in);

                    setClassName();
                    Class c = Class.forName(className);

                    findMatch(c);


                while (true) {

                    System.out.println("Continue? Y/N");
                    if (sc.nextLine().equals("Y")) {
                        this.findMatch(c);
                    } else {
                        return;
                    }
                }
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                run();
            }
    }

    public static void main (String[] args) throws ClassNotFoundException {

        Reflector r = new Reflector();
        r.run();

    }
}
