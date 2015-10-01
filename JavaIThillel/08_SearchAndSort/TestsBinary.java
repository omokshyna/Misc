import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class TestsBinary {

    @Test(expected = Exception.class)
    public void testUnsorted() throws Exception{
        int[] nums = {2, 0, 1, 6};
        BinarySearch.binarySearch(2, nums);
    }

    @Test
    public void testSearch1() throws Exception{
        int[] nums = {1, 2, 3, 4, 5, 6, 7};
        assertEquals(2, BinarySearch.binarySearch(3, nums));
    }

    @Test
    public void testSearch2() throws Exception{
        int[] nums = {1, 2, 3, 4, 4, 6, 7};
        assertEquals(3, BinarySearch.binarySearch(4, nums));
    }



}
