import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * WebCrawler class
 */

public class WebCrawler {

    public static String webAdress;
    public static String path;
    public boolean emails;
    public static int entryCount;
    private Set<String> emailSet = new HashSet<String>();
    private Set<String> urlSet = new HashSet<String>();
    private Scanner sc;

    /**
     * Default constructor
     */
    public WebCrawler() {
        webAdress = "http://www.conferenceusa.com/ot/c-usa-contact.html";
        emails = false;
        entryCount = 20;
        path = "./";
    }

    /**
     * Constructor that takes another web address and allows to ask for emails
     */
    public WebCrawler(String w, boolean em, int num) {
        webAdress = w;
        emails = em;
        entryCount = num;
    }

    /**
     * Method that accesses website urls and emails
     * recursively goes link by link
     * until the entryCount is reached
     *
     * @param adr
     * @throws IOException
     */
    private void accessHttp(String adr) throws IOException {
        HttpClient client = HttpClients.createDefault();
        Set<String> visited = new HashSet<String>();

        try {
            HttpResponse res = client.execute(new HttpGet(adr));
            visited.add(adr);
            String body = EntityUtils.toString(res.getEntity());
            matcher(body);

            if (!urlSet.isEmpty() && (urlSet.size() < entryCount)) { //here is the recursion. !!? errors
                for (String entry : urlSet) {
                    if (!visited.contains(entry)) {
                        System.out.println(urlSet.size());
                        accessHttp(entry);
                    }
                }
            }
        } catch (Exception e){
            e.getStackTrace();
            System.out.println("Check the input!");
        }
    }

    /** Used to match extracted html
     * using two patterns: for URLs and emails
     *
     * @param html
     */
    private void matcher(String html) {
        Pattern urlPattern = Pattern.compile("href=\"(http:.*?/+)+\"");
        Pattern emailPattern = Pattern.compile("mailto:(.*@.*\\..{2,3})\"");
        //not working properly on emails from http://qsar2014.insilico.eu/pages/contacts.php
        Matcher u = urlPattern.matcher(html);
        Matcher e = emailPattern.matcher(html);

        while (u.find() && (urlSet.size() < entryCount)) {
            //System.out.println(u.group(1));
            urlSet.add(u.group(1));
        }
        if (emails) {

            while (e.find() && (emailSet.size() < entryCount)) {
               // System.out.println(e.group(1));
                emailSet.add(e.group(1));
            }
        }
    }

    /**
     * Writes extracted urls and emails to file
     * @param setname
     * @param filename
     */

    private void writeToFile(Set<String> setname, String filename) {
        File f = new File(path + filename);
        try {

            FileWriter fw = new FileWriter(f, true);
            for (String name : setname) {
                fw.append(name + "\n");
            }
            fw.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }


    }

    /**
     * Used to run all the workflow about
     * and write it to file in the default directory
     * @throws Exception
     */
    public void run() throws Exception {
        accessHttp(webAdress);
        writeToFile(urlSet, "urls.txt");
        if (emails) {
            writeToFile(emailSet, "emails.txt");
        }
    }

}
