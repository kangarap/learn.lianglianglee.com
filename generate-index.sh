#!/bin/bash
# 为所有没有 index.html 的目录生成索引页面
find . -type d | while read dir; do
    # 跳过隐藏目录
    [[ "$(basename "$dir")" == .* ]] && continue
    
    if [ ! -f "$dir/index.html" ]; then
        dir_name=$(basename "$dir")
        
        # 生成目录列表 HTML
        cat > "$dir/index.html" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DIRECTORY_NAME</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: #f5f5f5;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 { color: #333; margin-bottom: 20px; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        ul { list-style: none; }
        li { margin: 10px 0; }
        a { 
            color: #007bff; 
            text-decoration: none; 
            font-size: 16px;
            display: block;
            padding: 8px;
            border-radius: 4px;
            transition: background 0.2s;
        }
        a:hover { background: #f0f0f0; }
        .back { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; }
        .back a { color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <h1>DIRECTORY_NAME</h1>
        <ul>
HTMLEOF
        # 添加目录内容
        ls -1 "$dir" 2>/dev/null | grep -v "^index.html$" | while read item; do
            echo "<li><a href=\"$item\">$item</a></li>" >> "$dir/index.html"
        done
        # 添加结束部分
        cat >> "$dir/index.html" << 'HTMLEOF'
        </ul>
        <div class="back">
            <a href="../">← 返回上级目录</a>
        </div>
    </div>
</body>
</html>
HTMLEOF
        # 替换目录名占位符
        sed -i "s/DIRECTORY_NAME/$dir_name/g" "$dir/index.html"
        echo "Created index.html for: $dir"
    fi
done
