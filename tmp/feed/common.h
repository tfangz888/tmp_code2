/* common.h */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <k.h>

// 转换时间,用于增加一列时间
/*

    time_t currentTime; struct tm *ct;
    time(&currentTime);
    ct= localtime(&currentTime);

    singleRow= knk(5, ks((S) "ABC"), kf(10.0), kj(20), kf(1000001.0), ktj(-16, castTime(ct)));


    K multipleRow= knk(5, ktn(KS, n), ktn(KF, n), ktn(KJ, n), ktn(KF, n), ktn(KN, n));
    for(i= 0; i < n; i++) {
        kS(kK(multipleRow)[0])[i]= ss(symbols[i % n]);
        kF(kK(multipleRow)[1])[i]= 100.0 * (i+1);
        kJ(kK(multipleRow)[2])[i]= i+1;
        kF(kK(multipleRow)[3])[i]= 100000.0 * (i+1);
        kJ(kK(multipleRow)[4])[i]= castTime(ct);
    }
 */
J castTime(struct tm *x) {
    return (J)((60 * x->tm_hour + x->tm_min) * 60 + x->tm_sec) * 1000000000;
}

I handleOk(I handle)
{
    if(handle > 0)
        return 1;
    if(handle == 0)
        fprintf(stderr, "Authentication error %d\n", handle);
    else if(handle == -1)
        fprintf(stderr, "Connection error %d\n", handle);
    else if(handle == -2)
        fprintf(stderr, "Timeout error %d\n", handle);
    return 0;
}



I isRemoteErr(K x) {
    if(!x) {
        fprintf(stderr, "Network error: %s\n", strerror(errno));
        return 1;
    } else if(-128 == xt) {
        fprintf(stderr, "Error message returned : %s\n", x->s); 
        r0(x);
        return 1;
    }
    return 0;
}
