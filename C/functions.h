#include <iostream>
#include <stdlib.h>
#include <time.h>
using namespace std;


//1. 
template <typename T> T cube(T num)
{
	return num*num*num;
}

//2. 

template <typename T> T findMax(T num1, T num2)
{
	if (num1 > num2)
	{
		return num1;
	}
	else
	{
		return num2;
	}
}

//---------------------------------------------------------------------
//3. 
template <typename T> bool isPositive(T val)
{
	if (val > 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

//-----------
//4. 

template <typename T> void Sum(T a, T b)
{
	cout << a + b<< endl;
}

template <typename T> void Diff(T a, T b)
{
	cout << a - b << endl;
}

template <typename T> void Mult(T a, T b)
{
	cout << a * b << endl;
}

template <typename T> void Div(T a, T b)
{
	if (b == 0)
	{
		cout << "Division by 0!\n";
		return;
	}
		
	cout << a / b << endl;
}

template <typename T> void Calculator(T num1, T num2, char opern)
{
	switch(opern)
	{
		case '+':
			Sum(num1, num2);
			break;
		case '-':
			Diff(num1, num2);
			break;
		case '*':
			Mult(num1, num2);
			break;
		case '/':
			Div(num1, num2);
			break;
		default:
			cout << "Error\n";
	}
}

//-------------------------------------------------------
//5. 

void Rectangle(int N, int K)
{
	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < K; j++)
		{
			cout << "*";
		}
		cout << endl;
	}
}

//---------------------------------------------------------------------
//6. 

bool isPrime(int num)
{
	for (int i = 2; i < num; i++)
	{
		if (num % i == 0 && i != num)
		{
			return false;
		}
	}
	return true;
}

//---------------------------------------------------------------------
//7. 

//recursive
int factorial(int num)
{
	if (num == 0 || num == 1)
	{
		return 1;
	}
	else
	{
		return num * factorial(num - 1);
	}
}

//---------------------------------------------------------------------
//8. 
		
template <typename T> T power(T num, int pow)
{
	T result = 1;
	while (pow >= 1)
	{
		if (pow % 2 == 0)
		{
			num *= num;
			pow = pow / 2;
		}
		else
		{
			result *= num;
			pow--;
		}

	}
	return result;
}
		
//---------------------------------------------------------------------
//~ 9. 
int sum_in_range(int num1, int num2)
{
	if (num1 > num2)
	{
		int temp = num1;
		num1 = num2;
		num2 = temp;
	}
	
	int sum = 0;
	
	for (int i = num1 + 1; i < num2; i++)
	{
		sum += i;
	}
	
	return sum;
}

//---------------------------------------------------------------------
// 10. 
bool is_number_perfect(int num)
{
	int sum = 0;
	if (num % 2 != 0)
	{
		return false;
	}
	for (int i = 1; i < num; i++)
	{
		if (num % i == 0)
		{
			sum += i;
		}
	}
	
	if (sum == num)
	{
		return true;
	}
	return false;
}

void perfect_numbers_in_range(int num1, int num2)
{
	for (int i = num1 + 1; i < num2; i++)
	{
		cout << i << " - " << is_number_perfect(i) << endl;
	}
	cout << endl;
}

//---------------------------------------------------------------------
//11. 
void playing_card(int num)
{
	num -= 1;
	int const CARDS_IN_SUIT = 8; 
	int const FIRST_CARD = 6;
	
	if (num < 0 || num > 35)
	{
		cout << "Error\nEnter the valid card number\n";
	}
	
	int suit = num / (CARDS_IN_SUIT + 1);
	int denominance = num - suit * (CARDS_IN_SUIT + 1);
	
	if (denominance <= 4)
	{ 
		cout << "Your card is " << denominance + FIRST_CARD;
	}
	else if (denominance == 5)
	{
		cout << "Your card is Jack";
	}
	else if (denominance == 6)
	{
		cout << "Your card is Queen";
	}
	else if (denominance == 7)
	{
		cout << "Your card is King";
	}
	else if (denominance == 8)
	{
		cout << "Your card is Ace";
	}
	
	switch (suit)
	{
		case 0:
			cout << " of hearts";
			break;
		case 1:
			cout << " of diamonds";
			break;
		case 2:
			cout << " of clubs";
			break;
		case 3:
			cout << " of spades";
			break;
		default:
			break;
	}
}

//---------------------------------------------------------------------
//12. 
void is_alph_num(char asci)
{
	if ((asci  >=  48  && asci <= 57) || (asci  >=  65  && asci <= 90)
		|| (asci  >=  97  && asci <= 122))
	{
		cout << "It is an alphanumeric character";
	}
	else 
	{
		cout << "It is not an alphanumeric character";
	}
}

//---------------------------------------------------------------------
//13. 
void happy_number(int num)
{
	if (num < 100000 || num > 999999)
	{
		cout << "Error\n";
		return;
	}
	
	if ((num / 100000 == num % 10) && (num / 10000 % 10 == num % 100 / 10) &&
		(num / 1000 % 10 == num % 1000 / 100)) 
	{
		cout << "It is a happy number!\n";
	}
	else 
	{
		cout << "It is not a happy number!\n";
	}
}

//---------------------------------------------------------------------
//15. 
template <typename T> double mean_arr(T arr[], int size)
{
	T sum;
	for (int i = 0; i < size; i++)
	{
		sum += arr[i];
	}

	return sum / size;
}

//---------------------------------------------------------------------
void init_int(int arr[], int size)
{
	for (int i = 0; i < size; i++)
	{
		arr[i] = rand() % 21 - 10;
	}
}

template <typename T> void print(T arr[], int size)
{
	for (int i = 0; i < size; i++)
	{
		cout << arr[i] << " ";
	}
	cout << endl;
}

//16. 
template <typename T> void sign_elements(T arr[], int size)
{
	int pos = 0;
	int neg = 0;
	int zero = 0; 
	
	for (int i = 0; i < size; i++)
	{
		if (arr[i] == 0)
		{
			zero++;
		}
		else if (arr[i] > 0)
		{
			pos++;
		}
		else 
		{
			neg++;
		}
	}
	
	cout << "Number of null elements: " << zero << 
			", positive = " << pos << ", negative = " << neg << endl;
}
		
//---------------------------------------------------------------------



	

		
		
	


