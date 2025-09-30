#include <stdio.h>
#include <stdlib.h>
#include <time.h>

struct FloatParametros{
	int decimal;
	int min;
	int max;
};

struct IntParametros{
	int min;
	int max;
};

int int_random(int min, int max);
double float_random(int len, int min, int max);
