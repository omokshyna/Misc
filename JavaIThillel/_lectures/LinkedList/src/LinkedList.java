public class LinkedList {
	public Element root = null;
	public Element element;
	public int numElements;
	public static int count;

	public void add(Object newElement){
		if (root == null) {
			root = new Element(newElement);
		} else {
			Element e = getLast();
			e.setNext(new Element(newElement));
	}}
		
	private Element getLast() {
		Element e = null;
		if (root != null) {
			e = root;			
			while (e.nextElement != null) {
				e = e.nextElement;
			}
		}
		return e;
	}
	
	public Object getByIdx(int idx) {
		Element e = root; 
		for (int i = 0; i < idx; i++) {
			e = e.nextElement;
		}
		return e.object;

	}
	
}

