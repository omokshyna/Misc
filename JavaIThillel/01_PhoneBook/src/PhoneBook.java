import java.io.*;
import java.util.HashMap;
import java.util.Scanner;

public class PhoneBook {
	private static HashMap<String, String> data = new HashMap<String, String>();
	private static String path = "PB.txt";
	private Scanner sc;

	// Read into hash map
	public static HashMap<String, String> readPB(String path) throws IOException {
		File file = new File(path); 
	    if (! file.exists()) { // It's not there!
	      boolean created = file.createNewFile();
	      if (created) {
		    	System.out.println("New file was created.");
		    } else {
		    	System.out.println("Unexpected error occured.");
		    }
	    }
	    
		BufferedReader br = new BufferedReader(new FileReader(file));
		
		String line = br.readLine();
		if (line != null) {
			// process the line.
			data.put(line.split("\t")[0], line.split("\t")[1]);
		} 
		br.close();
		return data;
	}

	// List all records
	public void printAll(HashMap<String, String> hm) {
		for (String name : hm.keySet()) {
			System.out.println("Name: " + name + "\t\t\tPhone Number: "
					+ hm.get(name));
		}
	}

	// Add Phone
	public HashMap<String, String> addPhone(HashMap<String, String> hm)
			throws NameZeroException, SymbolException {

		sc = new Scanner(System.in);
		System.out.println("Print name: ");
		String name = sc.nextLine();

		// check name
		if (name.length() == 0) {
			throw new NameZeroException();
		} else {
			// read phone
			System.out.println("Print phone number: ");
			String phoneNum = sc.nextLine();
			// check phone
			if (phoneNum.matches("\\d+")) {
				if (hm.containsKey(name)) {
					System.out.println("Name already exists in the Phone Book.");
					System.out.println("Do you want to rewrite it? Print 1, if yes. Print 0, if no.");
					int decision = sc.nextInt();
					if (decision == 1) {
						hm.put(name, phoneNum);
					} else if (decision == 0) {
						System.out.println("Name will no be rewritten.");
					} 
				} else {
					hm.put(name, phoneNum);
				}
				
			} else {
				throw new SymbolException();
			}	
			
		}
		return hm;
	}
	

	// Find phone by name
	public void findPhone(HashMap<String, String> hm) {
		sc = new Scanner(System.in);
		System.out.println("Print name: ");
		String name = sc.nextLine();
		
		if (hm.containsKey(name)) {
			System.out.println("Name: " + name + "\t\t\tPhone Number: "
					+ hm.get(name));
		} else {
			System.out.println("This name is not in the Phone Book. To add a new name choose 3 in a main menu.");
		}
	}

	// Write to PhoneBook
	private void writeToFile(HashMap<String, String> hm) {
		File f = new File(path);
		// check if PB exists. If not - create a new one
		if (!f.exists()) {
			System.out.println("Phone book does not exist. New Phone Book will be created.");
		}
		try {

			FileWriter fw = new FileWriter(f, true);
			for (String name : hm.keySet()) {
				fw.append(name + "\t" + hm.get(name) + "\n");
			}
			fw.close();
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
		}

	}


	// Delete record
	public static HashMap<String, String> deletePhone(HashMap<String, String> hm) {
		Scanner sc = new Scanner(System.in);
		System.out.println("Print name: ");
		String name = sc.nextLine();
		if (hm.containsKey(name)) {
			System.out.println("Name: " + name + "\t\t\tPhone Number: "
					+ hm.get(name));
			System.out.println("Are you sure you want to delete this number? Print 1, if yes. Print 0, if no.");
			int decision = sc.nextInt();
			if (decision == 1) {
				hm.remove(name);
				System.out.println(name + "'s number deleted.");
			}
		} else {
			System.out.println("This name is not in the Phone Book. To add a new name choose 3 in a main menu.");
		}
		return hm;
	}
	
	
//Constructor
	public PhoneBook() throws IOException {

		int end = 0;
		while (end == 0) {

			System.out.println(" __________________________________ ");
			System.out.println("|             PHONE BOOK           |");
			System.out.println("|==================================|");
			System.out.println("|Options:                          |");
			System.out.println("|       1. List all records        |");
			System.out.println("|       2. Find phone by name      |");
			System.out.println("|       3. Add new phone           |");
			System.out.println("|       4. Delete record           |");
			System.out.println("|       0. Exit                    |");
			System.out.println("|==================================|");
			System.out.println("|__________________________________|");
			System.out.println("|       	What to do?             ");

			Scanner sc = new Scanner(System.in);
			int selector = sc.nextInt();

			readPB(path);
			
			

			switch (selector) {
			case 1: {
				printAll(data);
				break;
			}
			case 2: {
				findPhone(data);
				break;
			}
			case 3: {
				try {
					data = addPhone(data);
				} catch (NameZeroException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SymbolException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				break;
			}
			case 4: {
				data = deletePhone(data);
				break;
			}
			case 0: {
				writeToFile(data);
				System.out.println("PhoneBook exits.");
				end = 1;
				break;
			}
			default: {
				writeToFile(data);
				System.out.println("Wrong input!");
			}
				sc.close();
			}
		}
	}
}
