// Mnożenie_dużych_liczb.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#include <iostream>
#include <string> 
#include <vector>
using namespace std;


string mul(string number1, string number2)
{
	int n = number1.size();
	int m = number2.size();
	if (n == 0 || m == 0)
		return "0";

	
	vector<int> result(n + m, 0); // kontener n + m intow wypelnionych zerami 

	
	int temp1 = 0; // zmienne pomocnicze do znajdowania pozycji w kontenerze result
	int temp2 = 0;

	// idziemy od prawej strony po 1 liczbie
	for (int i = n - 1; i >= 0; i--)
	{
		int cr = 0; // przeniesienie
		int n1 = number1[i] - '0'; // przekodowanie z ascii na cyfrę znaku z pierwszej liczby

		temp2 = 0;  

		// idziemy od prawej po drugiej liczbie             
		for (int j = m - 1; j >= 0; j--)
		{
			int n2 = number2[j] - '0'; // dekodowanie do cyfry znak z drugiej liczby

			//dodanie n1 * n2 i przeniesienia do odpowiedniej pozycji wyniku
			int sum = n1 * n2 + result[temp1 + temp2] + cr;

			cr = sum / 10; // wyluskanie przeniesienia

			// zapis cyfry wyniku na odpowiedniej pozycji
			result[temp1 + temp2] = sum % 10;

			temp2++;
		}

		// uwzglednienie ostatniego przeniesienia 
		if (cr > 0)
			result[temp1 + temp2] += cr;

		temp1++; // przesunięcie pozycji w lewo pierwszej liczby
	}

	// zapis wyniku jako string
	int i = result.size() - 1;
	string value = "";
	while (i >= 0)
		value += to_string(result[i--]);

	return value;
}


int main()
{
	string str1 = "91241539898349572391875936493476928345345353453298652936592834";
	string str2 = "9324569320659136425964523693465237890465827345698746538475";

	cout << str1 << endl;
	cout << str2 << endl;
	cout << mul(str1, str2);
	return 0;
}