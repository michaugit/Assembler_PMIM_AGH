//---------------------------------------------------------------
// Program lab_9a - Asemblery Laboratorium IS II rok
//
// To compile&link: gcc -o lab_9a lab_9a.c lab_9a_asm.s
// To run:          ./lab_9a
//
//---------------------------------------------------------------

#include <stdio.h>

long factc( unsigned int k )
{
	long result = 1;
	while( k > 1 )
	   result *= k--;
	return result;			
}

long facta( unsigned int k );

void main( void )
{
 int i;

 for( i = 1; i <= 30; i++ )
   printf( "FactC(%d) = %ld \nFactA(%d) = %ld\n\n", i, factc(i), i, facta(i) );
}
