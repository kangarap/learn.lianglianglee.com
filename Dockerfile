FROM nginx:alpine
# 复制网站文件到 nginx 目录
COPY . /usr/share/nginx/html
# 创建自定义 nginx 配置，解决路径问题
RUN echo 'server { \
    listen 8000; \
    root /usr/share/nginx/html; \
    index index.html; \
    \
    # 自动在目录后补全 index.html \
    location / { \
        try_files $uri $uri/ $uri/index.html =404; \
    } \
    \
    # 禁用目录列表 \
    autoindex off; \
}' > /etc/nginx/conf.d/default.conf
EXPOSE 8000
