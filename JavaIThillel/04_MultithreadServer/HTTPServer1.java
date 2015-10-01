import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Our Basic HttpServer
 */
public class HTTPServer {

    /**
     * Directory path
     */
    private String path;

    /**
     * Port to listen
     */
    private Integer port;

    /**
     * Server socket
     */
    private ServerSocket socket;

    /**
     * Number of Threads
     */
    private static int numThreads = 10;

    /**
     * Creates new instance of HttpServer
     */
    public HTTPServer(String path, int port) {
        this.path = path;
        this.port = port;
    }

    /**
     * Starts server in new thread
     * @throws Exception
     */
    public void start() throws Exception {
        this.socket = new ServerSocket(port);
        loop();
        socket.close();
    }

    /**
     * Run server, process requests
     */
    static ExecutorService ex = Executors.newFixedThreadPool(numThreads);

    private void loop() throws Exception{
        while(true) {
            final Socket s = this.socket.accept();
            ex.submit(new Runnable() {
                public void run() {
                    try {

                        HTTPRequest request = HTTPRequest.from(s.getInputStream());

                        System.out.println(" -> " + request);
                        HTTPResponse response = handle(request);
                        response.to(s.getOutputStream());
                        System.out.println(" <- " + response);

                    } catch (Exception e) {
                        System.err.println("Problem processing request " + e.getClass() + " " + e.getMessage());
                    }
                }
            });
        }
        }




    /**
     * Handle request and return response
     * @throws Exception
     */
    private HTTPResponse handle(HTTPRequest request) throws Exception {

        HTTPResponse response = HTTPResponse.OK;

        // Infer content-type
        String ext = request.getPath().split("\\.")[1];

        if (ext == "html") {
            response.setContentType("text/html");
        } else if (ext == "jpg") {
            response.setContentType("image/jpeg");
        }

        // Write body
        response.setBody(Files.readAllBytes(
                        FileSystems.getDefault().getPath(
                                path + request.getPath())
                )
        );

        return response;
    }

    /**
     * Entry point
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {

        HTTPServer httpServer = new HTTPServer("./", 4444);
        httpServer.start();

    }

}
