import pykx as kx
import pandas as pd
import openpyxl

import sys

if len(sys.argv) > 1:
    file = sys.argv[1]
else:
    print("没有参数file")
df = pd.read_excel(file)

# 只取有用的列
df2 = df[['报告期', '代码', '每股派息(税前)', '送股比例', '转增比例', '除权除息日', '现金分红总额(万元)']]

col = df2['代码'].astype(str) # 确保全是字符串
df2['代码'] = col.str[-2:].str.lower() + '.' + col.str[:6] 

# 为空的列设置为0
col_to_fix = ['每股派息(税前)', '送股比例', '转增比例', '现金分红总额(万元)']
df2[col_to_fix] = df2[col_to_fix].fillna(0)

# 存为parquect, 不存索引
df2.to_parquet(file[:-4] + 'parquet', index=False)
# 存为csv
df2.to_csv(file[:-4] + 'csv', index=False)



def main():
    print("Hello from pythonprj!")


if __name__ == "__main__":
    main()
