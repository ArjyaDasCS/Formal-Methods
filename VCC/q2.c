#include<vcc.h>
#include<limits.h>
void div(unsigned x, unsigned d, unsigned *q, unsigned *r)
_(requires d > 0 && q != r)
_(ensures x == d * (*q) + *r && *r < d)
_(writes &(*q), &(*r))
{
        unsigned lq, lr;
        lq = 0;
        lr = x;
        while(lr >= d)
        _(invariant (lr == (x - (lq * d)) && (lq >= 0)))
        {
                lq++;
                lr = lr - d;
        }
        *q = lq;
        *r = lr;
        return;
}
