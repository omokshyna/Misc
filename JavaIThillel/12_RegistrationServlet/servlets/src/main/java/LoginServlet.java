import entities.User;
import org.apache.commons.codec.digest.DigestUtils;
import org.hibernate.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;




@WebServlet(urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        Session session = (Session) req.getAttribute("session");

        Query q = session.createQuery("SELECT s FROM User s " +
                " WHERE s.email = :email AND " +
                " s.password = :password ");


            q.setParameter("email", req.getParameter("email"));

            String hash =  DigestUtils.md5Hex(req.getParameter("password"));

            q.setParameter("password",  hash);


            try {
                User u = (User) q.list().get(0);
                req.getSession().setAttribute("email", u.getEmail());
                resp.sendRedirect("/secure");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("/login");
            }

    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

        if (req.getParameter("logout") != null) {
            req.getSession().removeAttribute("email");
        }

        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }






}