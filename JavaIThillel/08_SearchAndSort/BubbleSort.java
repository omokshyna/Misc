public class BubbleSort {

	public static int[] bubbleSort(int[] nums) {
		boolean sorted = false;

		while (sorted == false) {
			sorted = true;
			for (int i = 0; i < nums.length - 1; i++) {
				if (nums[i] > nums[i + 1]) {
					int temp = nums[i + 1];
					nums[i + 1] = nums[i];
					nums[i] = temp;
					sorted = false;
				}
			}
		}
		return nums;
	}

	private static void printArr(int[] nums) {
		for (int a : nums) {
			System.out.println(a);
		}
	}

}
