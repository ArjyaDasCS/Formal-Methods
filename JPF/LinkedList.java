package symbolicheap;

public class LinkedList
{
	public static void test5(NodeSimple n)
	{
		int len = 0;
		NodeSimple curr = n;
		while( curr != null && curr.next != null && curr != curr.next) 
		{
			len++;
			if (len == 2) 
			{
				System.out.println("length at least 2");
				break;
			}
			curr = curr.next;
		}
	}

	public static void main(String args[])
	{
		NodeSimple n = new NodeSimple(5);
		test5(n);
	}
}