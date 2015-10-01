//Create grid with user-defined width and height


#include <iostream>
using namespace std;

int main()
{
	int width, height;
	
	cout << "Enter the width of grid: ";
	cin >> width;
	cout << "Enter the height of grid: ";
	cin >> height;
	
	for (int i = 0; i <= height*2; i++) 
	{
		for (int j = 0; j < width; j++)
		{
			if (i % 2 == 0 || i == height * 2) 
			{
				cout << "+---";
			}
			else
			{
				cout << "|   ";
			}
		}
		if (i % 2 == 0 || i == height * 2) 
		{
			cout << "+";
		}
		else
		{
			cout << "|";
		}
		cout << "\n";
	}
	
	return 0;
}

