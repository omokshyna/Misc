import entities.Ad;
import entities.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.Service;
import org.hibernate.service.ServiceRegistry;

/**
 * Hibernate App Demo
 */
public class App {

    public static SessionFactory getSessionFactory() {
        Configuration configuration = new Configuration().configure();
        return configuration.buildSessionFactory (
                new StandardServiceRegistryBuilder().applySettings(
                        configuration.getProperties()).build()
        );

    }



    /**
     * Entry Point
     */
    public static void main(String args[]) throws Exception {

        SessionFactory factory = getSessionFactory();
        Session session = factory.openSession();

        // Get user
//
//        User user1 = (User) session.get(User.class, 10);
//        System.out.println("entities.User: " + user1);


        // Create new user in transaction

        System.out.println();
        System.out.println();
//        Transaction transaction = session.getTransaction();
//        transaction.begin();
//
//        User user = new User();
//        user.setEmail("buga@ga");
//        user.setWantReceiveEmails(false);
//        session.persist(user);
//
//        transaction.commit();

        Transaction transaction1 = session.getTransaction();
        transaction1.begin();

        Ad ad = new Ad();
        ad.setAdsDate();
        ad.setTitle("Pig's ears");
        ad.setContent("Yammi ears, yam-yam!");

        User user = (User) session.get(User.class, 10);
//        ad.setUser(user);

        session.persist(ad);

        transaction1.commit();

//        System.out.println("Our users:");
//        for (Object s : session.createQuery(
//                "SELECT s FROM User s").list()) {
//            System.out.println(s);
//        }

        System.out.println("Our ads: ");
        for (Object a: session.createQuery(
                "SELECT a FROM Ad a").list()) {
            System.out.println(a.toString());
        }

        session.close();
        factory.close();

    }
}