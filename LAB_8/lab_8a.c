//---------------------------------------------------------------
// Program lab_8a - Asemblery Laboratorium IS II rok
//
// To compile&link: gcc -o lab_8a lab_8a.c lab_8a_asm.s
// To run:          ./lab_8a
//
//---------------------------------------------------------------

#include <stdio.h>

long factc( unsigned int k )
{
	if( k <= 1 )
		return 1;
	else
		return k * factc( k - 1 );
}

long facta( unsigned int k );

void main( void )
{
 int i;

 for( i = 1; i <= 30; i++ )
 {
   printf( "FactC(%d) = %ld\n", i, factc(i) );
   printf( "FactA(%d) = %ld\n\n", i, facta(i) );
 }
}
