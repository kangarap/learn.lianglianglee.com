FROM nginx:alpine
# 复制网站文件
COPY . /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
# 安装必要的工具
RUN apk add --no-cache bash findutils coreutils
# 为所有没有 index.html 的目录生成索引页面
RUN for dir in $(find . -type d | grep -v '/\.'); do \
        if [ ! -f "$dir/index.html" ]; then \
            dir_name=$(basename "$dir"); \
            echo "<!DOCTYPE html>" > "$dir/index.html"; \
            echo "<html lang=\"zh-CN\">" >> "$dir/index.html"; \
            echo "<head><meta charset=\"UTF-8\"><title>$dir_name</title>" >> "$dir/index.html"; \
            echo "<style>" >> "$dir/index.html"; \
            echo "body{font-family:system-ui,sans-serif;background:#f5f5f5;padding:20px}" >> "$dir/index.html"; \
            echo ".container{max-width:800px;margin:0 auto;background:#fff;padding:30px;border-radius:8px}" >> "$dir/index.html"; \
            echo "h1{color:#333;border-bottom:2px solid #007bff;padding-bottom:10px}" >> "$dir/index.html"; \
            echo "ul{list-style:none;padding:0}" >> "$dir/index.html"; \
            echo "li{margin:10px 0}" >> "$dir/index.html"; \
            echo "a{color:#007bff;text-decoration:none;display:block;padding:8px}" >> "$dir/index.html"; \
            echo "a:hover{background:#f0f0f0}" >> "$dir/index.html"; \
            echo ".back{margin-top:30px;border-top:1px solid #eee;padding-top:20px}" >> "$dir/index.html"; \
            echo "</style></head><body><div class=\"container\">" >> "$dir/index.html"; \
            echo "<h1>$dir_name</h1><ul>" >> "$dir/index.html"; \
            for item in "$dir"/*; do \
                if [ "$(basename "$item")" != "index.html" ]; then \
                    item_name=$(basename "$item"); \
                    echo "<li><a href=\"$item_name\">$item_name</a></li>" >> "$dir/index.html"; \
                fi; \
            done; \
            echo "</ul><div class=\"back\"><a href=\"../\">← 返回上级</a></div>" >> "$dir/index.html"; \
            echo "</div></body></html>" >> "$dir/index.html"; \
            echo "Created: $dir/index.html"; \
        fi; \
    done
# 修复权限
RUN chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /usr/share/nginx/html
# 配置 nginx
RUN printf 'server {\n\
    listen 8000;\n\
    server_name localhost;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    charset utf-8;\n\
    \n\
    location / {\n\
        try_files $uri $uri/index.html /index.html;\n\
    }\n\
    \n\
    autoindex off;\n\
}\n' > /etc/nginx/conf.d/default.conf
EXPOSE 8000
CMD ["nginx", "-g", "daemon off;"]
