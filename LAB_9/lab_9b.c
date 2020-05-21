//---------------------------------------------------------------
// Program lab_9b - Asemblery Laboratorium IS II rok
//
// To compile&link: gcc -o lab_9b lab_9b.c lab_9b_asm.s
// To run:          ./lab_9b
//
//---------------------------------------------------------------

#include <stdio.h>

long fibc( unsigned int k )
{
	long fold = 0;
	long fnew = 1;
	long sum;

	if( k == 0 ) return fold;
	else if( k == 1 ) return fnew;
	else
	{
		do {
			sum = fold + fnew;
			fold = fnew;
			fnew =  sum;
			k--;
		}
		while( k > 1 );
		return sum;
	}
}

long fiba( unsigned int k );


void main( void )
{
 int i;

 for( i = 0; i <= 100; i++ )
   printf( "FibC(%d) = %ld \nFibA(%d) = %ld\n\n", i, fibc( i ), i, fiba( i ) );
}
