// g++ -o a -g -O0 a.cpp c.o -I. -lpthread
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <k.h>
#include <common.h>

#if 0
/* File name: singleRow.c */
int main() {
    I handle;
    I portnumber= 5010;
    S hostname= "localhost";
    S usernamePassword= "kdb:pass"; 
    K result, singleRow;

    handle= khp(hostname, portnumber); 
    if(!handleOk(handle))
        return EXIT_FAILURE;

    singleRow= knk(4, ks((S) "ABC"), kf(10.0), kj(20), kf(1000001.0));
    // Perform single row insert, tickerplant will add timestamp column itself
    //// 异步调用, 句柄前加负号, 不需要 r0 释放result. 同步调用需要释放
    result= k(-handle, ".u.upd", ks((S) "md"), singleRow, (K)0); 
    if(isRemoteErr(result)) {
        kclose(handle);
        return EXIT_FAILURE;
    } 
//    r0(result);

    singleRow= knk(4, ks((S) "DEF"), kf(10.0), kj(20), kf(1000001.0));
    // Perform single row insert, tickerplant will add timestamp column itself
    result= k(-handle, ".u.upd", ks((S) "md"), singleRow, (K)0);
    if(isRemoteErr(result)) {
        kclose(handle);
        return EXIT_FAILURE;
    }
 //   r0(result);

    kclose(handle);
    return EXIT_SUCCESS;
} 
#endif

#if 1
int main() {
    int i, n= 3;
    I handle;
    I portnumber= 5010;
    S hostname= "localhost";
    S usernamePassword= "kdb:pass";
    S symbols[]= { "ABC", "DEF", "GHI" };
    K result;

    handle= khp(hostname, portnumber);
    if(!handleOk(handle))
        return EXIT_FAILURE;

    K multipleRow= knk(4, ktn(KS, n), ktn(KF, n), ktn(KJ, n), ktn(KF, n));
    for(i= 0; i < n; i++) {
        kS(kK(multipleRow)[0])[i]= ss(symbols[i % n]);
        kF(kK(multipleRow)[1])[i]= 10.0 * i;
        kJ(kK(multipleRow)[2])[i]= i;
        kF(kK(multipleRow)[3])[i]= 100000.0 * i;
    }

    // Perform multiple row insert, tickerplant will add timestamp column itself
    //// 异步调用, 句柄前加负号, 不需要 r0 释放result. 同步调用需要释放
    result= k(handle, ".u.upd", ks((S) "md"), multipleRow, (K)0);
    if(isRemoteErr(result)) {
        kclose(handle);
        return EXIT_FAILURE;
    }

    r0(result);
    kclose(handle);
    return EXIT_SUCCESS;
}
#endif
