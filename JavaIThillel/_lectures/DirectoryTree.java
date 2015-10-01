package hillel;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Directory Traverse Tree
 */
public class DirectoryTree {

    /**
     * Node
     */
    public static class Node {

        private File node;
        private int level;

        public Node(File node, int level) {
            this.node = node;
            this.level = level;
        }

        public File getNode() {
            return node;
        }

        public int getLevel() {
            return level;
        }
    }

    /**
     * Listener interface
     */
    public static interface TraverseListener {
        void onNode(Node node);
    }

    /**
     * Start path
     */
    private String path;

    /**
     * All listeners
     */
    private List<TraverseListener> listeners = new ArrayList<TraverseListener>();

    /**
     * Constructor
     */
    public DirectoryTree(String path) {
        this.path = path;
    }

    /**
     * Subscribe
     */
    public void subscribe(TraverseListener l) {
        if (!this.listeners.contains(l)) {
            this.listeners.add(l);
        }
    }

    /**
     * Start traversing
     */
    public void traverse() {
        traverse(new File(path), 0);
    }

    /**
     * Traverse node
     */
    private void traverse(File node, int level) {

        for (TraverseListener l : listeners) {
            l.onNode(new Node(node, level));
        }

        if(node.isDirectory()){
            String[] subNote = node.list();
            for(String filename : subNote){
                traverse(new File(node, filename), level+1);
            }
        }
    }

    /**
     * Entry Point
     */
    public static void main(String args[]) {

        DirectoryTree tree = new DirectoryTree("/home/yyyar/workspace/c4lt");

        tree.subscribe(new TraverseListener() {
            @Override
            public void onNode(Node node) {
               System.out.print(String.join("", Collections.nCopies(node.getLevel(), "  ")));
               System.out.print(node.getNode().isDirectory() ? "+ " : "- ");
               System.out.println(node.getNode().getName());
            }
        });

        tree.traverse();

    }
}
