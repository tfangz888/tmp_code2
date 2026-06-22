
#!/bin/bash

# =====================================================================
# 脚本名称: list_files.sh
# 脚本功能: 遍历 folder1 和 folder2 的所有文件，提取文件名与后缀并写入 CSV
# 使用方式: chmod +x list_files.sh && ./list_files.sh
# =====================================================================

# 1. 定义目标文件夹和输出 CSV 文件路径
TARGET_FOLDERS=("folder1" "folder2")
OUTPUT_CSV="/tmp/dailyfiles.csv"

# 2. 初始化 CSV 文件，写入表头 (双引号包裹以防乱码)
echo "\"sym\",\"date\"" > "$OUTPUT_CSV"

echo "正在扫描文件夹..."

# 3. 循环遍历目标文件夹
for folder in "${TARGET_FOLDERS[@]}"; do
    # 检查文件夹是否存在
    if [ ! -d "$folder" ]; then
        echo "[警告] 文件夹 $folder 不存在，跳过。"
        continue
    fi

    # 使用 find 递归查找该文件夹下的所有文件 (-type f)
    # -print0 配合 read -d '' 可以完美处理文件名中带有空格或换行的特殊情况
    find "$folder" -type f -print0 | while IFS= read -r -d '' file; do
        
        # 提取不带路径的纯文件名 (例如: folder1/sub/aaa.2020.xlsx -> aaa.2020.xlsx)
        filename_with_ext=$(basename "$file")

        # 提取文件后缀 (例如: xlsx)
        # ${variable##*.} 代表删除最后一个点及之前的所有字符
        date="${filename_with_ext##*.}"

        # 提取不带后缀的文件名 (例如: aaa.2020)
        # ${variable%.*} 代表删除最后一个点及其后面的所有字符
        sym="${filename_with_ext%.*}"

        # 安全处理：如果文件没有后缀 (例如: LICENSE)
        # 此时 date 会等于 filename_with_ext，我们需要将其清空，并将 name 设为原文件名
        if [ "$date" = "$filename_with_ext" ]; then
            date=""
            sym="$filename_with_ext"
            continue
        fi

        # 4. 写入 CSV 
        # 使用双引号包裹字段，防止文件名中含有逗号(,)导致 CSV 格式错乱
        echo "\"$sym\",\"$date\"" >> "$OUTPUT_CSV"

    done
done

echo "扫描完成！数据已成功写入 $OUTPUT_CSV"
```
eof

### 🚀 如何使用：

1. **保存脚本**：在包含 `folder1` 和 `folder2` 的父级目录下新建一个名为 `list_files.sh` 的文件，并将上面的代码粘贴进去。
2. **赋予执行权限**：
   ```bash
   chmod +x list_files.sh
   ```
3. **运行脚本**：
   ```bash
