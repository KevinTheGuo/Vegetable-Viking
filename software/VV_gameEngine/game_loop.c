#include <stdio.h>
#include "qdbmp.h"

int main()
{
	BMP* astronaut;
	astronaut = BMP_ReadFile("test.bmp");
	return 0;
}
