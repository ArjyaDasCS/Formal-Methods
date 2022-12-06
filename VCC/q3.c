#include<vcc.h>
#include<limits.h>
int arraymax (int *A, unsigned len)
_(requires \thread_local_array(A, len))
_(ensures (\result == INT_MIN || (\forall unsigned index; (index < len) ==> (A[index] <= \result))))
{
        unsigned i = 0;
        int max = INT_MIN;
        while (i < len)
        _(invariant (i <= len) && (\forall unsigned index; (index < i) ==> (A[index] <= max)))
        {
                if (A[i] > max)
                        max = A[i];
                i++;
        }
        return max;
}
