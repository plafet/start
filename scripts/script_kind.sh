#Скачиваем бинарный файл kind (для архитектуры AMD64 / x86_64)
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64 \
# делаем файл исполняемым
&& chmod +x ./kind \
# перемещаем файл в папку с бинарниками
&& sudo mv ./kind /usr/local/bin/kind \
# проверяем версию
&& kind --version
