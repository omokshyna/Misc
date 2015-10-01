import java.io.IOException;

public class BinarySearch {
	
	public static int binarySearch(int num, int[] numArray) throws Exception {

            if(!checkSorted(numArray)) {
                throw new Exception("Array is not sorted!");
            }

            int start = 0;
            int end = numArray.length - 1;

            while (start <= end) {
                int mid = start + (end - start) / 2;
                if (num < numArray[mid]) {
                    end = mid - 1;
                } else if (num > numArray[mid]) {
                    start = mid + 1;
                } else {
                    return mid;
                }
            }

            return -1;
	}

    private static boolean checkSorted(int[] checkarray)  {
        boolean sorted = true;
        for (int i = 1; i < checkarray.length; i++) {
            if (checkarray[i - 1] > checkarray[i]) {
                sorted = false;

            }
        }
        return sorted;
    }

}
