import java.sql.*;
import java.sql.Date;
import java.util.*;

/**
 * @author: Elena Mokshyna
 */

    /**
     *  Simple console program to work with the SuperAds database
     */
    public class SuperAdsConnector {

                /*
        Private Fields
         */

        //User's email
        String usrEmail;

        //Scanner
        private Scanner sc = new Scanner(System.in);

        // Menu items

        private Map<Integer, MenuCommand> menuItems = new TreeMap<>();

        //DB connection
        private Connection conn;

        //SQL statement
        private PreparedStatement sqlExpr;


        /**
         * Initializer
         */
        {
            menuItems.put(0, new MenuCommand() {
                public void execute() {
                    System.exit(0);
                }
                public String getName() {
                    return "Exit command";
                }
            });

            menuItems.put(1, new AddUserCommand());
            menuItems.put(2, new AddAdsCommand());
            menuItems.put(3, new PrintAdsCommand());
            menuItems.put(4, new DeleteAdsCommand());
        }

        /*
        Private methods
         */

        private interface MenuCommand{
            String getName();
            void execute() throws SQLException;

        }

        private class AddUserCommand implements MenuCommand {
            @Override
            public String getName() {
                return "Add user";
            }

            @Override
            public void execute() throws SQLException {
                usrEmail = getUsrEmail();

                System.out.println("Print new user's name: ");
                String name = sc.nextLine();

                sqlExpr = conn.prepareStatement("INSERT INTO users(email, name) VALUES (?, ?)");

                sqlExpr.setString(1, usrEmail);
                sqlExpr.setString(2, name);

                sqlExpr.executeUpdate();


            }
        }

        private class AddAdsCommand implements MenuCommand {

            @Override
            public String getName() {
                return "Add advertisements";
            }

            @Override
            public void execute() throws SQLException{
                usrEmail = getUsrEmail();

                sqlExpr = conn.prepareStatement("SELECT id FROM users where email = ?");
                sqlExpr.setString(1, usrEmail);

                ResultSet usrId = sqlExpr.executeQuery();

                if(usrId.next()) {

                    System.out.println("Print title for your ad: ");
                    String title = sc.nextLine();


                    System.out.println("Print text of yout ad: ");
                    String text = "";
                    String s = "";
                    while (!(s = sc.nextLine()).isEmpty()) {
                        text = text.concat("\n").concat(s);

                    }

                    System.out.println(text);

                    sqlExpr = conn.prepareStatement("INSERT INTO ads(title, date, content, user_id ) VALUES (?, ?, ?, ?)");
                    sqlExpr.setString(1, title);
                    sqlExpr.setDate(2, new java.sql.Date((new java.util.Date()).getTime()));
                    sqlExpr.setString(3, text);
                    sqlExpr.setInt(4, usrId.getInt(1));

                    sqlExpr.executeUpdate();
                }
            }
        }

        private class DeleteAdsCommand implements MenuCommand {

            @Override
            public String getName() {
                return "Delete advertisements";
            }

            @Override
            public void execute() throws SQLException{

                System.out.println("Print an id of the ads to delete: ");
                int ads_id = sc.nextInt();

                sqlExpr = conn.prepareStatement("DELETE FROM ads WHERE id = ?");

                sqlExpr.setInt(1, ads_id);

                sqlExpr.executeUpdate();

            }
        }

        private class PrintAdsCommand implements MenuCommand {
            @Override
            public String getName() {
                return "Print advertisements";
            }

            @Override
            public void execute() throws SQLException{

                usrEmail = getUsrEmail();

                sqlExpr = conn.prepareStatement("SELECT id FROM users WHERE email= ?");
                sqlExpr.setString(1, usrEmail);

                ResultSet usrId = sqlExpr.executeQuery();

                if(usrId.next()) {

                    sqlExpr = conn.prepareStatement("SELECT * FROM ads WHERE user_id = ?");

                    sqlExpr.setInt(1, usrId.getInt(1));

                    ResultSet ads = sqlExpr.executeQuery();

                    while (ads.next()) {
                        System.out.println(ads.getString("title") + " " + ads.getString("content") + " " + ads.getString("user_id"));
                    }
                }

            }

        }


        /*
        Methods
         */

        //Print menu until read command
        private MenuCommand printMenu() {
            Integer input;

            while (true) {

                for (int key : menuItems.keySet()) {
                    System.out.println(key + " : " + menuItems.get(key).getName());
                }

                System.out.println("What do you want to do? > ");
                String option = new Scanner(System.in).nextLine();

                try {
                    input = Integer.parseInt(option);
                } catch (Exception e) {
                    System.out.println("Bad input. Try again");
                    continue;
                }

                if (!menuItems.containsKey(input)) {

                    System.out.println("No such command. Try again");
                    continue;
                } else {
                    return menuItems.get(input);
                }
            }
        }

        //Connect to DB
        private void connectToDB() {
//            System.out.println("Enter your user name: ");
//            String user = new Scanner(System.in).nextLine();
            String user = "postgres";

//            System.out.println("Print your password: ");
//            String pass = new Scanner(System.in).nextLine();
            String pass = "root";

            try {
                conn = DriverManager.getConnection(
                        "jdbc:postgresql://localhost/SuperAds",
                        user,
                        pass
                );
                conn.setAutoCommit(true);

            } catch(Exception e) {
                e.printStackTrace();
                System.out.println("Connection failed. Try again");
                connectToDB();
            }

        }

        //Additional method to get user's ID
        private String getUsrEmail() {
            System.out.println("Print user's email: ");
            return sc.nextLine();
        }


        //Start working session
        public void startSession() throws SQLException{
            connectToDB();

            while (true) {
                MenuCommand command = printMenu();

                try {
                    command.execute();
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("Error occured. Try again.");
                }
            }
        }



        public static void main(String args[]) throws Exception {

            SuperAdsConnector connector = new SuperAdsConnector();
            connector.startSession();

        }
    }


