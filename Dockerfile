FROM nginx:alpine
# 复制网站文件到 nginx 目录
COPY . /usr/share/nginx/html
# 设置正确的权限
RUN chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /usr/share/nginx/html
# 创建 nginx 配置
RUN { \
    echo 'server {'; \
    echo '    listen 8000;'; \
    echo '    server_name localhost;'; \
    echo '    root /usr/share/nginx/html;'; \
    echo '    index index.html;'; \
    echo '    charset utf-8;'; \
    echo ''; \
    echo '    location / {'; \
    echo '        try_files $uri $uri/ $uri/index.html /index.html;'; \
    echo '    }'; \
    echo ''; \
    echo '    autoindex off;'; \
    echo '}'; \
} > /etc/nginx/conf.d/default.conf
EXPOSE 8000
CMD ["nginx", "-g", "daemon off;"]
