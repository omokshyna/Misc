#include <iostream>
#include <stdlib.h>
#include <time.h>
using namespace std;

const int hcols = 5;

template <typename T> void Init(T arr[][hcols], int rows, int cols)
{
	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < cols; j++)
		{
			arr[i][j] = rand() % 101;
		}
	}
}

template <typename T> void Show(T arr[], int size)
{
	for (int i = 0; i < size; i++)
	{
		cout << arr[i] << "\t";
	}
	cout << endl;
}

template <typename T> void Show(T arr[][hcols], int rows, int cols)
{
	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < cols; j++)
		{
			cout << arr[i][j] << "\t";
		}
		cout << endl << endl;
	}
	cout << endl;
}

template <typename T> int FindRowMin(T arr[][hcols], int rows, int cols)
{
	int min = arr[0][0];
	int idx_i = -1;
	
	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < cols; j++)
		{
			if (arr[i][j] < min)
			{
				min = arr[i][j];
				idx_i = i;
			}
		}
	}
	cout << "Minimal element is " << min << "\nIts row is " << idx_i << endl;
	return idx_i; 
}


//col - means col to sum
template <typename T> int FindColSum(T arr[][hcols], int rows, int col_to_sum)
{
	int sum = 0;
	
	for (int i = 0; i < rows; i++)
	{
		sum += arr[i][col_to_sum];
	}

	return sum; 
}

// use to sort small arrays
template <typename T> void InsertSort(T arr[], int size) 
{
	T temp;
	int i;
	int j;

	for(i = 0; i < size; i++)
	{
		for(j = i; j > 0; j--)
		{
			if (arr[j] < arr[j-1])
			{
				temp = arr[j];
				arr[j] = arr[j - 1];
				arr[j - 1] = temp;
			}
			else
			{
				break;
			}
		}
	}
}

//function to sort and save sorted order
//idx - indexes that show how elements were sorted
template <typename T> void InsertSortAndSaveOrder(T arr[], int size, T idxs[], int size_idxs) 
{
	T temp;
	int i;
	int j;

	for(i = 0; i < size; i++)
	{
		for(j = i; j > 0; j--)
		{
			if (arr[j] < arr[j-1])
			{
				temp = arr[j];
				arr[j] = arr[j - 1];
				arr[j - 1] = temp;
				
				// change idxs
				temp = idxs[j];
				idxs[j] = idxs[j - 1];
				idxs[j - 1] = temp;
			}
			else
			{
				break;
			}
		}
	}
}

//binary search
template <typename T> int BinarySearch (T array[], int size, int key)
{
	int mid;
	int lo = 0;
	int hi = size - 1;
	
	while(lo <= hi){
		mid = (lo + hi)/2;
		if (key < array[mid])
		{
			hi = mid - 1;
		}
		else if (key > array[mid])
		{
			lo = mid + 1;
		}
		else
		{
			return mid;
		}
	}
	return -1;
}







