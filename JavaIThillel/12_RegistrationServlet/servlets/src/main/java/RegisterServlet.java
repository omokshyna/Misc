import entities.User;
import org.apache.commons.codec.digest.DigestUtils;
import org.hibernate.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet(urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        Session session = (Session) req.getAttribute("session");

        String email = req.getParameter("email");
        String pass = req.getParameter("password");
        String name = req.getParameter("name");



        Query query = session.createQuery("SELECT s FROM User s " +
                " WHERE s.email = :email");

        query.setParameter("email", email);

        if (query.list().size() == 0) {

            User u = new User();

            u.setEmail(email);
            u.setName(name);

            try {
                String hash = DigestUtils.md5Hex(pass);
                u.setPassword(hash);

                System.out.println(u.getPassword());
            } catch (Exception e) {
                resp.sendRedirect("/register");
            }

            session.save(u);
            req.getSession().setAttribute("email", u.getEmail());

            resp.sendRedirect("/login");


        }
    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }

}