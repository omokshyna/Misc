#include <iostream>
using namespace std;

int main()
{
	
	for (int row = 0; row < 3; row++)
	{
		for (int i = 1; i <= 9; i++)
		{
			for (int j = 1; j <= 3; j++)
			{
				cout << j + 3 * row << " * " << i << " = " << (j + 3 * row) * i << "\t";
			}
			cout << endl;
		}
		cout << endl;
	}
	
	return 0;
}

