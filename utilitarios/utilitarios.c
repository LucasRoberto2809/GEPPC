#include "utilitarios.h"

int int_random(int min, int max) {
	return (random() % (max - min + 1)) + min;
}

double float_random(int len, int min, int max) {
	double random_num = (double)(random() % (max - min + 1)) + min;
	int i=0, div=10.0;
	for (i=0; i<len; i++) {
		random_num += (double)(random() % 9) / div;
		div *= 10.0;
	}
	return random_num;
}
