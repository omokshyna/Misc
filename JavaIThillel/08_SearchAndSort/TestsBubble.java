import org.junit.Test;

import java.util.Arrays;

import static org.junit.Assert.assertEquals;

public class TestsBubble {

    @Test
    public void TestEmptySort() {
        int[] nums = {};

        assertEquals(0, BubbleSort.bubbleSort(nums).length);
    }

    @Test
    public void TestProperSort1() {
        int[] nums = {8, 2, 5, 0};
        int[] numsSorted = {0, 2, 5, 8};

        Arrays.equals(nums, numsSorted);
    }

    @Test
    public void TestProperSort2() {
        int[] nums = {8, 2, 5, 0, 7, 7, 82};
        int[] numsSorted = {0, 2, 5, 7, 7, 8, 82};

        Arrays.equals(nums, numsSorted);
    }



}
