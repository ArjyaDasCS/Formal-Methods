/*
Here combined functions simulates the execution of both abstract and concrete machine. Pre-condition glues them before executing any action and Post-condition checks if the gluing relation holds after taking the action (simulation). 
*/

#include<vcc.h>
#include<limits.h>

unsigned int unum;
_(ghost int intval)

void init()
_(writes &unum, &intval)
_(requires \true)
_(ensures unum == (unsigned)intval)
{
        unum = 0;
        _(ghost intval = 0)
}

void inc()
_(writes &unum, &intval)
_(requires ((unum>= 0 && unum <= 127) ==> (((unsigned)intval)==unum)) && ((unum>=128 && unum<=255) ==> (intval == -(256-((int)unum)))))
_(ensures ((unum>= 0 && unum<= 127) ==> (((unsigned)intval)==unum)) && ((unum>=128 && unum<=255) ==> (intval == -(256-((int)unum)))))
{
        _(assume (unum>=0 && unum<=255))
        if (unum == 255)
                unum = 0;
        else
                unum++;

        if (intval == 127)
                intval = -128;
        else
                _(ghost intval++)
}

void dec()
_(writes &unum, &intval)
_(requires ((unum>= 0 && unum <= 127) ==> (((unsigned)intval)==unum)) && ((unum>=128 && unum<=255) ==> (intval == -(256-((int)unum)))))
_(ensures ((unum>= 0 && unum<= 127) ==> (((unsigned)intval)==unum)) && ((unum>=128 && unum<=255) ==> (intval == -(256-((int)unum)))))
{
        _(assume (unum>=0 && unum<=255))
        if(unum == 0)
                unum = 255;
        else
                unum--;

        if(intval == -128)
                intval = 127;
        else
                _(ghost intval--)
}
