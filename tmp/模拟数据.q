
//
// Test data
//
n:100
customers:([] id:1+til n; name:n?`7)
sn:`aapl`goog`msft`nke`ftse
symbols:1!([] sym:`aapl`goog`msft`nke`ftse; src:count[sn]?`8);
trades:([] ts:$[12h;.z.d]+$[`minute;1]*til n;
    sym:n?(0!symbols)[`sym];
    price:n?10.0;
    size:n?1000)


