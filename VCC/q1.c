/*
(a)
Verification Condition:
Loop Invariant:

(y <= 1000) && (x = \sum_{i=1}^{y-1} i)
= (y <= 1000) && (x = 1 + 2 + ... + (y-1))
= (y <= 1000) && (x = (y-1)(y)/2) 

The loop invariant is both adequate and inductive. 
*/

// (b)
#include<vcc.h>
#include<limits.h>
void q1()
{
        _(requires \true)
        {
                int x = 0;
                int y = 1;
                while(y<1000)
                _(invariant y<=1000 && ((x==(((y-1)*y)/2))))
                {
                	/*
                	(c) VCC has not shown any overflow warning 				previously. Though _(unchecked) has been added to 				address that issue. One can explicity bound the 				integers also to solve the issue.
                	*/
                       x = _(unchecked) x + y;
                       y = _(unchecked) y + 1;
                }
                _(assert y<x);
        }
}
