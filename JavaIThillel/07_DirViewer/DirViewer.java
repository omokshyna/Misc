import java.io.File;
import java.util.HashMap;


public class DirViewer {

	public static void viewDir(String path, int level) {
		// TODO Auto-generated method stub
		File dirMain = new File(path);
		
		File[] firstLevel = dirMain.listFiles();
		if (firstLevel != null && firstLevel.length > 0) {
			for (File f: firstLevel) {
				for (int i = 0; i < level; i++) {
					System.out.print("\t");
				}
				if (f.isDirectory()) {
					System.out.println("[" + f.getName() + "]");
					viewDir(f.getAbsolutePath(), level+1);
				} else {
					System.out.println(f.getName());
				}
			}
			
		}

	}

    public static void viewDir(String path) {
        viewDir(path, 0);
    }
	

	
	public static void main(String[] args) {
        viewDir("../");
	}
}
