#include <iostream>
#include <fstream>
using namespace std;

int main(int argc, char** argv){
	string file     = string(argv[1]);
	string toAppend[argc];

	for (int index = 2; index < argc; index++){
		toAppend[index] = string(argv[index]);
	}

	ofstream out;
	out.open(file.c_str(),ios::app);

	for(int index = 0; index < (argc); index ++){
		out << toAppend[index] << " ";
	}
	out << "\n";
	out.close();
}