import java.lang.reflect.Array;
import java.util.ArrayList;

/**
 * Created by meg on 27.04.14.
 */
public class SnailWalk {

    public static void  cookSnail(int[][] arr) {

        int nrows = arr.length;
        int ncol = arr[0].length;

        int countRows = 0;
        int countColumns = 0;


        while ((countRows <= nrows) && (countColumns <= ncol)) {

            for (int i = countColumns; i <= ncol; i++) {
                System.out.print(countRows);
                System.out.println(i);

            }
            countRows++;


            for (int j = countRows; j <= nrows; j++) {
                System.out.print(j);
                System.out.println(ncol);
            }

            ncol--;

            for (int k = ncol; k >= countColumns; k--) {
                System.out.print(nrows);
                System.out.println(k);
            }

            nrows--;

            for (int l = nrows; l >= countRows; l--) {
                System.out.print(l);
                System.out.println(countColumns);
            }

            countColumns++;


        }
    }


    public static void main(String[] main) {
        int[][] arr1 = new int[3][2];

        cookSnail(arr1);


    }
}