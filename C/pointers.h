#include <iostream>
#include <stdlib.h>
#include <time.h>
using namespace std;

template <typename T> void init(T arr[], int size)
{
	int * ptr = arr;
	
	for (int i = 0; i < size; i++)
	{
		*ptr = rand() % 10;
		ptr++;
	}
}

template <typename T> void show(T arr[], int size)
{
	int * ptr = arr;
	
	for (int i = 0; i < size; i++)
	{
		cout << *ptr << " ";
		ptr++;
	}
	cout << endl;
}

template <typename T> void summ(T arr[], int size)
{
	int * ptr = arr;
	int sum = 0;
	
	for (int i = 0; i < size; i++)
	{
		sum += *ptr;
		ptr++;
	}
	cout << "Summ of all elements = " << sum << endl;
}

template <typename T> void reverse(T arr[], int size)
{
	int * ptr_last = arr + size - 1; //pointer to the last element
	int * ptr_first = arr; // pointer to the first element
	int temp;
	for (int i = 0; i < size / 2; i++)
	{
		temp = *ptr_first;
		*ptr_first = *ptr_last;
		*ptr_last = temp;
		ptr_first++;
		ptr_last--;
	}
}

template <typename T> void copy_reverse(T arr[], T copy[], int size)
{
	int * ptr_first = arr; // pointer to the first element 
	int * ptr_last = copy + size - 1; //pointer to the last element of copy
	for (int i = 0; i < size; i++)
	{
		*ptr_last = *ptr_first;
		ptr_first++;
		ptr_last--;	
	}
}

template <typename T> void find_min_max(T arr[], int size, int* ptr_min, int* ptr_max)
{
	*ptr_min = arr[0];
	*ptr_max = arr[0];
	int * ptr_arr = arr;

	for (int i = 0; i < size; i++)
	{
		if (*ptr_arr < *ptr_min)
		{
			*ptr_min = *ptr_arr;
		}
		if (*ptr_arr > *ptr_max)
		{
			*ptr_max = *ptr_arr;
		}
		ptr_arr++;
	}
}


//~ template <typename T> void shift(T arr[], int size, int shift) 
//~ {
	//~ int temp;
	//~ 
	//~ if (shift >= 0)
	//~ {
		//~ for (int i = 0; i < shift; i++)
		//~ {
			//~ for (int j = 0; j < size; j++)
			//~ {
				//~ temp = arr[0];
				//~ arr[0] = arr[j];
				//~ arr[j] = temp;
			//~ }
		//~ }
	//~ }
	//~ else
	//~ {
		//~ for (int i = 0; i < -shift; i++)
		//~ {
			//~ for (int j = size - 1; j >= 0; j--)
			//~ {
				//~ temp = arr[0];
				//~ arr[0] = arr[j];
				//~ arr[j] = temp;
				//~ 
			//~ }
		//~ }
		//~ cout << endl;
	//~ }
//~ }

//~ 
//~ template <typename T> void shift1(T arr[], int size, int shift) 
//~ {
	//~ int temp;
	//~ int * ptr_first = arr;
	//~ int * ptr_change;
	//~ 
	//~ if (shift >= 0)
	//~ {
		//~ ptr_change = arr;
		//~ for (int i = 0; i < shift; i++)
		//~ {
			//~ for (int j = 0; j < size; j++)
			//~ {
				//~ temp = *ptr_first;
				//~ *ptr_first = *ptr_change;
				//~ *ptr_change = temp;
				//~ ptr_change++;
			//~ }
			//~ ptr_change = arr;
		//~ }
	//~ }
	//~ else
	//~ {
		//~ ptr_change = arr + size - 1;
		//~ for (int i = 0; i < -shift; i++)
		//~ {
			//~ for (int j = size - 1; j >= 0; j--)
			//~ {
				//~ temp = *ptr_first;
				//~ *ptr_first = *ptr_change;
				//~ *ptr_change = temp;
				//~ ptr_change--;				
			//~ }
			//~ ptr_change = arr + size - 1;
		//~ }
		//~ cout << endl;
	//~ }
//~ }


///////////////////////////////////////////////////////////////////////
template <typename T> void reverse_interval(T arr[], int start, int end)
{
	int temp;
	int * ptr_first = arr + start;
	int * ptr_last = arr + end;
	while(ptr_first < ptr_last)
	{
		temp = *ptr_first;
		*ptr_first = *ptr_last;
		*ptr_last = temp;
		ptr_first++;
		ptr_last--;  
		//~ temp = arr[start];
		//~ arr[start] = arr[end];
		//~ arr[end] = temp;
		//~ start++;
		//~ end--;
	}
}

template <typename T> void shift(T arr[], int size, int shift) 
{
	if (shift == 0)
	{
		return;
	}

	int start;
	int mid;
	int end;
	
	if (shift > 0)
	{
		start = 0;
		mid = size - 1 - shift;
		end = size - 1;
		
		reverse_interval(arr, start, mid);
		reverse_interval(arr, mid + 1, end);
		reverse_interval(arr, start, end);		
	}
	else if (shift < 0)
	{
		start = 0;
		mid = -shift - 1;
		end = size - 1;
		
		reverse_interval(arr, start, mid);
		reverse_interval(arr, mid + 1, end);
		reverse_interval(arr, start, end);	
		
	}
}
		
	
	
	
