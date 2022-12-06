import gov.nasa.jpf.symbc.Debug;

public class Sort
{
	// function to implement Bubble Sort
	public static void sort(int[] arr)
	{
		for(int i=0; i<arr.length; i++)
		{
			for(int j=0; j<arr.length-i-1; j++)
			{
				if(arr[j] > arr[j+1])
				{
					int temp = arr[j];
					arr[j] = arr[j+1];
					arr[j+1] = temp;
				}
			}
		}
	}

	public static void checkSorted(int[] arr)
	{
		for(int i=0; i<arr.length-1; i++)
		{
			assert(arr[i] <= arr[i+1]);
		}
	}

	public static void main(String args[])
	{
		int size = 5;
		int[] arr = new int[size];
		int a0 = Debug.makeSymbolicInteger("x0");
		int a1 = Debug.makeSymbolicInteger("x1");
		int a2 = Debug.makeSymbolicInteger("x2");
		int a3 = Debug.makeSymbolicInteger("x3");
		int a4 = Debug.makeSymbolicInteger("x4");
		arr[0] = a0;
		arr[1] = a1;
		arr[2] = a2;
		arr[3] = a3;
		arr[4] = a4;
		sort(arr);
		checkSorted(arr);
	}
}