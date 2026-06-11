// g++ -o a -g -O0 feed.cpp c.o -I. -lpthread
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <k.h>
#include <common.h>

#if 1
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

    time_t currentTime; struct tm *ct;
    time(&currentTime);
    ct= localtime(&currentTime);

    singleRow= knk(5, ks((S) "ABC"), kf(10.0), kj(20), kf(1000001.0), ktj(-16, castTime(ct)));
    // Perform single row insert, tickerplant will add timestamp column itself
    //////// 异步调用, 句柄前加负号, 不需要 r0 释放result. 同步调用需要释放
    result= k(-handle, ".u.upd", ks((S) "md"), singleRow, (K)0); 
    if(isRemoteErr(result)) {
        kclose(handle);
        return EXIT_FAILURE;
    } 
//    r0(result);

    singleRow= knk(5, ks((S) "DEF"), kf(10.0), kj(20), kf(1000002.0), ktj(-16, castTime(ct)));
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

#if 0
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

    time_t currentTime; struct tm *ct;
    time(&currentTime);
    ct= localtime(&currentTime);

    K multipleRow= knk(5, ktn(KS, n), ktn(KF, n), ktn(KJ, n), ktn(KF, n), ktn(KN, n));
    for(i= 0; i < n; i++) {
        kS(kK(multipleRow)[0])[i]= ss(symbols[i % n]);
        kF(kK(multipleRow)[1])[i]= 100.0 * (i+1);
        kJ(kK(multipleRow)[2])[i]= i+1;
        kF(kK(multipleRow)[3])[i]= 100000.0 * (i+1);
	kJ(kK(multipleRow)[4])[i]= castTime(ct);
    }

    // Perform multiple row insert, tickerplant will add timestamp column itself
    ////// 异步调用, 句柄前加负号, 不需要 r0 释放result. 同步调用需要释放
    result= k(-handle, ".u.upd", ks((S) "md"), multipleRow, (K)0);
    if(isRemoteErr(result)) {
        kclose(handle);
        return EXIT_FAILURE;
    }

    //r0(result);
    kclose(handle);
    return EXIT_SUCCESS;
}
#endif


