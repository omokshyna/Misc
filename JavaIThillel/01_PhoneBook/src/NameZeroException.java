
public class NameZeroException extends Exception{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public void printStackTrace() {
		System.out.println("Name's length cannot be zero!");
	}
}
