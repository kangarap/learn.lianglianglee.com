FROM nginx:alpine
# 复制网站文件到 nginx 目录
COPY . /usr/share/nginx/html
# 安装 bash 和 findutils 用于脚本执行
RUN apk add --no-cache bash findutils
# 设置正确的权限
RUN chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /usr/share/nginx/html
# 为所有没有 index.html 的目录生成简单的索引页面
RUN find /usr/share/nginx/html -type d | while read dir; do \
    if [ ! -f "$dir/index.html" ]; then \
        dir_name=$(basename "$dir"); \
        # 生成目录列表页面
        cat > "$dir/index.html" << EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${dir_name}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
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
        a:hover { background: #f0f0f0; text-decoration: underline; }
        .back { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; }
        .back a { color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <h1>${dir_name}</h1>
        <ul>
$(ls -1 "$dir" 2>/dev/null | grep -v "^index.html$" | sed 's|^|<li><a href="|; s|$|">&</a></li>|')
        </ul>
        <div class="back">
            <a href="../">← 返回上级目录</a>
        </div>
    </div>
</body>
</html>
EOF
        echo "Generated index.html for: $dir"; \
    fi; \
done
# 创建 nginx 配置
RUN echo 'server { \
    listen 8000; \
    server_name localhost; \
    root /usr/share/nginx/html; \
    index index.html; \
    charset utf-8; \
    \
    location / { \
        try_files $uri $uri/index.html /index.html =404; \
    } \
    \
    autoindex off; \
    \
    error_log /var/log/nginx/error.log warn; \
    access_log /var/log/nginx/access.log; \
}' > /etc/nginx/conf.d/default.conf
EXPOSE 8000
CMD ["nginx", "-g", "daemon off;"]
