import org.junit.Test;

import java.lang.reflect.Method;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.Assert.assertEquals;

/**
 * Created by meg on 16.04.14.
 */
public class test1 {

    @Test
    public void testClassName() {
       String className = "java.lang.Object";
        try {
            Class c = Class.forName(className);
            assertEquals("java.lang.Object", c.getName());
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testFindMatch() throws ClassNotFoundException {
        Pattern p = Pattern.compile("^" + "wa" + ".*");

        Class c = Class.forName("java.lang.Object");

        for (Method m : c.getMethods()) {
            Matcher match = p.matcher(m.getName());
            if(match.find()) {
                assertEquals("wait", m.getName());
                System.out.println(m.getName());
            }
        }

    }


}
