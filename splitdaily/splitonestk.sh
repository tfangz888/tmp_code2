firstday=$(bash /finlab/DataEngineering/vendor/tdx/splitdaily/firstday.sh $1)
lastday=$(bash /finlab/DataEngineering/vendor/tdx/splitdaily/lastday.sh $1)

ym() { printf '%s' "${1:0:6}"; }

cur=$(ym "$firstday")
end=$(ym "$lastday")
echo "start $cur"
echo "end $end"
while :; do
    [[ $cur == "$end" ]] && break
    echo $cur
    /finlab/DataEngineering/vendor/tdx/splitdaily/splitdaily $1 "$cur"
    y=${cur:0:4}
    m=${cur:4:2}
    m=$((10#$m)) # 去掉前导 0, 避免八进制
    if (( m == 12 )); then
        ((y++))
        m=1
    else
        ((m++))
    fi
    # 再补 0
    printf -v cur '%d%02d' "$y" "$m"
done

source ~/env.sh

# 改名加点,  sz.000001.20250405
for pre in sz sh bj; do for f in "$pre"[0-9]*; do [[ -f $f ]] && mv -v "$f" "$pre.${f#$pre}"; done; done

szdir="$MYDATA_STOCK/AStock/daily/TS/ShenzhenStockExchange"
for f in sz.[0-9]* ; do
    [[ -f $f ]] || continue
    dir=${f%.*} # 去掉扩展名
    echo $dir
    mkdir -p "$szdir/$dir"
    mv -v "$f" "$szdir/$dir/"
done

shdir="$MYDATA_STOCK/AStock/daily/TS/ShanghaiStockExchange"
for f in sh.[0-9]* ; do
    [[ -f $f ]] || continue
    dir=${f%.*} # 去掉扩展名
    echo $dir
    mkdir -p "$shdir/$dir"
    mv -v "$f" "$shdir/$dir/"
done

bjdir="$MYDATA_STOCK/AStock/daily/TS/BeijingStockExchange"
for f in bj.[0-9]* ; do
    [[ -f $f ]] || continue
    dir=${f%.*} # 去掉扩展名
    echo $dir
    mkdir -p "$bjdir/$dir"
    mv -v "$f" "$bjdir/$dir/"
done

