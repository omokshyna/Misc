import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebFilter("/*")
public class NameSessionFilter implements Filter {

    FilterConfig config;
    SessionFactory sessionFactory;
    Session session;

    public void init(FilterConfig config) throws ServletException {
        this.config = config;
        System.out.println("Session Filter is initiated.");

    }

    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {


        Configuration configuration = new Configuration().configure();
        sessionFactory = configuration.buildSessionFactory(
                new StandardServiceRegistryBuilder().applySettings(configuration.getProperties()).build());

        session = sessionFactory.openSession();

        Transaction transaction = session.getTransaction();
        transaction.begin();

        List<String> names = session.createQuery("SELECT s.name FROM User s").list();

        request.setAttribute("names", names);

        chain.doFilter(request, response);

        transaction.commit();
    }

    public void destroy() {

        this.config = null;
        System.out.println("Session Filter is destroyed.");
        session.close();
        sessionFactory.close();

    }

}