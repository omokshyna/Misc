package hillel;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

public class j5_java8_Nashorn {

    public static void main(String... args) throws Exception {

        ScriptEngineManager manager = new ScriptEngineManager();
        ScriptEngine engine = manager.getEngineByName("nashorn");

        // Simple print
        engine.eval(" print('hello world') ");

        // Javascript map
        engine.eval(" print( ['a','bb','cccc'].map(function(a) { return a.length();}) )");

        // Using Java classes from JS
        engine.eval("" +
                " var Thread = Java.type('java.lang.Thread'); " +
                " var MyThread = Java.extend(Thread, {     " +
                "        run: function() {                 " +
                "             print(Thread.currentThread());  " +
                "     }                                        " +
                "  });                                     " +
                "   var th = new MyThread();            " +
                "  th.start();                 " +
                " th.join();                ");


    }
}
