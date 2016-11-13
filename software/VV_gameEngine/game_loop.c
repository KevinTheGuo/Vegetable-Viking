#include <stdio.h>
#include "qdbmp.h"

#define BMP_PIXEL_OUTPUT (volatile char*) 0x0020


int main()
{
	BMP* astronaut;
	astronaut = BMP_ReadFile("test.bmp");
	BMP_CHECK_ERROR(stdout, -1);

	return 0;
}
