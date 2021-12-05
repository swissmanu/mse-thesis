#include <stdio.h>

int main() {
	int fib[10];
	fib[0] = 0;
	fib[1] = 1;
	int i;

	for (i = 2; i <= 9; i++) {
		fib[i] = fib[i - 1] + fib[i - 2];
	}

	printf("%d", fib[9]);
}
