firstday=$(bash /finlab/DataEngineering/vendor/tdx/splitdaily/firstday.sh $1)
lastday=$(bash /finlab/DataEngineering/vendor/tdx/splitdaily/lastday.sh $1)

# 从 YYYYMMDD 中截取年份 YYYY
# ${1:0:4} 表示从位置 0 开始截取 4 个字符
yy() { printf '%s' "${1:0:4}"; }

cur=$(yy "$firstday")
end=$(yy "$lastday")
echo "start $cur"
echo "end $end"
while :; do
    # 逐年调用 splitdaily，参数已改为 YYYY
    echo $cur
    /finlab/DataEngineering/vendor/tdx/splitdaily/splitdaily $1 "$cur"
    # 结束年份也要处理一次，所以在调用后再退出
    # [[ ... ]] 是 bash 条件判断，== 表示字符串相等
    [[ $cur == "$end" ]] && break
    # ${cur:0:4} 表示取当前年份字符串的前 4 位
    y=${cur:0:4}
    ((y++))
    # printf -v 直接把格式化结果写回变量 cur
    printf -v cur '%d' "$y"
done

source ~/env.sh

# 改名加点,  sz.000001.2025
# ${f#$pre} 表示去掉变量 f 开头的前缀 $pre
for pre in sz sh bj; do for f in "$pre"[0-9]*; do [[ -f $f ]] && mv -v "$f" "$pre.${f#$pre}"; done; done

szdir="$MYDATA_STOCK/AStock/daily/TS/ShenzhenStockExchange"
for f in sz.[0-9]* ; do
    [[ -f $f ]] || continue
    # 按股票代码建目录，例如 sz.000001 -> .../sz.000001/
    # ${f%.*} 表示去掉最后一个点及其后面的内容
    dir=${f%.*} # 去掉扩展名
    echo $dir
    mkdir -p "$szdir/$dir"
    mv -v "$f" "$szdir/$dir/"
done

shdir="$MYDATA_STOCK/AStock/daily/TS/ShanghaiStockExchange"
for f in sh.[0-9]* ; do
    [[ -f $f ]] || continue
    # 按股票代码建目录，例如 sh.600000 -> .../sh.600000/
    # ${f%.*} 表示去掉最后一个点及其后面的内容
    dir=${f%.*} # 去掉扩展名
    echo $dir
    mkdir -p "$shdir/$dir"
    mv -v "$f" "$shdir/$dir/"
done

bjdir="$MYDATA_STOCK/AStock/daily/TS/BeijingStockExchange"
for f in bj.[0-9]* ; do
    [[ -f $f ]] || continue
    # 按股票代码建目录，例如 bj.430047 -> .../bj.430047/
    # ${f%.*} 表示去掉最后一个点及其后面的内容
    dir=${f%.*} # 去掉扩展名
    echo $dir
    mkdir -p "$bjdir/$dir"
    mv -v "$f" "$bjdir/$dir/"
done
