import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebFilter("/*")
public class AuthFilter implements Filter {


    private SessionFactory sessionFactory;


    public void init(FilterConfig config) throws ServletException {
        Configuration configuration = new Configuration().configure();
        sessionFactory = configuration.buildSessionFactory(
                new StandardServiceRegistryBuilder().applySettings(configuration.getProperties()).build());

        System.out.println("Session Filter is initiated.");
    }


    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {


        HttpServletRequest req = ((HttpServletRequest) request);
        System.out.println(req.getRequestURI());
        if (!req.getRequestURI().equals("/register") && !req.getRequestURI().equals("/login")
            && req.getSession().getAttribute("email") == null ) {
            ((HttpServletResponse)response).sendRedirect("/login");
            return;
        }

        Session session = sessionFactory.openSession();
        Transaction transaction = session.getTransaction();
        transaction.begin();

        request.setAttribute("session", session);

        try {
            chain.doFilter(request, response);
            transaction.commit();
        } catch (Exception e) {
            transaction.rollback();
        } finally {
            session.close();
        }


    }

    public void destroy() {

        System.out.println("Session Filter is destroyed.");
        sessionFactory.close();

    }

}