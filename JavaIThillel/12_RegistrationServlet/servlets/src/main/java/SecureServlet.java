import org.hibernate.Query;
import org.hibernate.Session;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = "/secure")
public class SecureServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

       Session session = (Session) req.getAttribute("session");

       Query q = session.createQuery(
               " SELECT a FROM Advertisment a " +
               " WHERE a.user.email = :email ");
       q.setParameter("email", req.getSession().getAttribute("email"));

       req.setAttribute("ads", q.list());
       req.getRequestDispatcher("secure.jsp").forward(req, resp);
    }
}
