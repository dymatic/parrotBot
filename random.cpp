#include <cstdlib>
#include <iostream>
#include <time.h>
using namespace std;
int main(int argc, char** argv){
cout << argv[rand()%(argc-1)];
return 0;
}