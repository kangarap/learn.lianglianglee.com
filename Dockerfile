FROM python:3.11-alpine
WORKDIR /app
# 复制所有网站文件
COPY . .
# 暴露端口
EXPOSE 8000
# 启动 HTTP 服务器
CMD ["python3", "-m", "http.server", "8000"]
