

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.Socket;
import java.net.ServerSocket;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class SimpleHttpServer {

    private ServerSocket socket;
    private String response;
    private OutputStreamWriter writer;

    private interface Request {
        String getName();
        String getContent();
        void returnRequest(String path, Socket s);
    }

    private class ImageRequest implements Request {
        public String getName() {
            return "jpeg";
        }

        public String getContent(){
            return "image/jpg";
        }

        public void returnRequest(String path, Socket s) {
            try {
                OutputStream dos = new DataOutputStream(s.getOutputStream());

                try {
                    BufferedImage img = ImageIO.read(new File("./" + path));

                    ImageIO.write(img, "jpg", dos);
                } catch (IOException e) {
                    writer.write("404 File not found");
                }

                dos.flush();

            } catch (IOException e) {
                System.out.println(e.getStackTrace());
            }

        }
    }

    private class HtmlRequest implements Request {

        public String getName() {
            return "html";
        }

        public String getContent(){
            return "text/html";
        }

        public void returnRequest(String path, Socket s) {
            try {
                Scanner sc = new Scanner(new BufferedReader(new FileReader("./" + path)));
                while(sc.hasNextLine()) {
                    writer.write(sc.nextLine() + "\r\n");
                }
            } catch (IOException e) {
                System.out.println(e.getStackTrace());
            }

        }
    }

    private class TextRequest extends HtmlRequest {
        public String getName() {
            return "txt";
        }
    }

    private class WelcomePage implements Request {

        public String getName() {
            return "\\/";
        }

        public String getContent(){
            return "text/html";
        }

        public void returnRequest(String path, Socket s) {
            try {
                writer.write("Welcome to our beautiful server!");
                writer.write("We have picture here: a.jpeg");
                writer.write("Funny stories: a.txt");
                writer.write("And nicely formatted html: a.html");
            } catch (IOException e) {
                System.out.println(e.getStackTrace());
            }

        }
    }


    private Map<String, Request> requestsToServer = new HashMap<String, Request>();

    {
        requestsToServer.put("jpeg", new ImageRequest());
        requestsToServer.put("html", new HtmlRequest());
        requestsToServer.put("txt", new TextRequest());
        requestsToServer.put("\\/", new WelcomePage());
    }

    private Request getRequest(String reqName) {
        if (!requestsToServer.containsKey(reqName)) {
            try {
                writer.write("");

            } catch (IOException e) {
                e.printStackTrace();
            }
            return null;
        } else {
            return requestsToServer.get(reqName);
        }
    }


    public SimpleHttpServer() throws Exception {
        this.socket = new ServerSocket(4444);
    }


    public void run() throws IOException {
        try {
            while (true) {
                Socket s = this.socket.accept();


                BufferedReader in = new BufferedReader(new InputStreamReader(s.getInputStream()));
                String line = in.readLine();
                response  = parseText(line);
                System.out.println(line);
                while (!(line = in.readLine()).isEmpty()) {
                    System.out.println(line);
                }

                writer = new OutputStreamWriter(new BufferedOutputStream(s.getOutputStream()));
                writer.write("HTTP 200 OK\n");


                String requestName = new String();


                if (response.contains(".")) {
                    requestName = response.split("\\.")[1];
                } else {
                    requestName = "\\/";
                }

                Request request = getRequest(requestName);

                writer.write("Content:" + request.getContent() + "\n\n");
                request.returnRequest(response, s);

                writer.flush();
                s.getOutputStream().close();
                s.close();

            }
        } catch (Exception e) {
            writer.write("500 Internal Server Error");
        }


    }

    private String parseText(String body) {
        Pattern p = Pattern.compile("GET\\s(.*)\\s");

        Matcher m = p.matcher(body);
        String s = new String();
        while(m.find()) {
            s += m.group(1);
        }
        return s;
    }
    /**
     * Entry Point
     */
    public static void main(String args[]) throws Exception {


        SimpleHttpServer s = new SimpleHttpServer();
        s.run();
    }




}