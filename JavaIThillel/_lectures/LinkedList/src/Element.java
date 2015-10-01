public class Element {

	public Element nextElement;
	public Object object;

	public void setNext(Element el) {
		this.nextElement = el;
	}
	
	
	public Element(Object obj) {
		this.object = obj;
	}
}
