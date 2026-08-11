FROM alpine:latest

WORKDIR /app

COPY TacoExpress.apk /app/TacoExpress.apk

CMD ["sh", "-c", "echo 'TacoExpress APK listo para despliegue' && ls -lh /app/TacoExpress.apk"]
