//---------------------------------------------------------------
// Program lab_7b - Asemblery Laboratorium IS II rok
//
// To compile&link: gcc -o lab_7b lab_7b.c lab_7b_asm.s
// To run:          ./lab_7b
//
//---------------------------------------------------------------

#include <stdio.h>

long sum3c( long a, long b, long c )
{
	return a + b + c;
}

long sum3a( long a, long b, long c );

void main( void )
{
	long a = -5, b = 2, c = 1;

	printf( "Sum3c(%ld, %ld, %ld) = %ld\n", a, b, c, sum3c( a, b, c ) );
	printf( "Sum3a(%ld, %ld, %ld) = %ld\n", a, b, c, sum3a( a, b, c ) );
}
