<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>

</head>
<body>

   SECURED! <br/>

   Your email ${email}  </br>
      ${reg_answer}

      <p>Your ads  ${ads}</p>


       <p>List of ads:</p>
       <ul>
              <c:forEach var="ad" items="${ads}">
                 <li> <c:out value="Title: ${ad.title}"/> </li>
              </c:forEach>
        </ul>

</body>
</html>