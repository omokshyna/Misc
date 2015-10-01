/*
 * pointers.cpp
 * 
 * Copyright 2015 MEG <meg@r2d2>
 * 
 */

#include "pointers.h"
int main()
{
	srand(unsigned(time(0)));
	const int size = 5;
	int arr[size];
	
	//1. Calculate a sum of array's elements using pointers
	//~ init(arr, size);
	//~ show(arr, size);
	//~ summ(arr, size);
	
	//3. Using pointers reverse an array 
	//~ init(arr, size);
	//~ show(arr, size);
	//~ reverse(arr, size);
	//~ show(arr, size);
	
	//4. Copy one array to another in reverse order using two pointers 
	//~ init(arr, size);
	//~ show(arr, size);
	//~ int arr_copy[size];
	//~ copy_reverse(arr, arr_copy, size);
	//~ cout << endl;
	//~ show(arr_copy, size);
	//~ cout << &arr << " " << &arr_copy;
	
	
	//5. Using pointer find minimal and maximal elements of an array
	//~ init(arr, size);
	//~ show(arr, size);
	//~ int min;
	//~ int max;
	//~ find_min_max(arr, size, &min, &max);
	//~ cout << min << " " << max << endl;
	
	//6. Using pointer perform a cyclic shift of an array
	// on defined number of elements 
	init(arr, size);
	show(arr, size);
	shift(arr, size, -2);
	//~ int shift = 2;
	//~ reverse_interval(arr, 0, shift - 1);
	//~ reverse_interval(arr, shift, size-1);
	//~ reverse_interval(arr, 0, size - 1);
	show(arr, size);
	
	
	

	
	return 0;
}

