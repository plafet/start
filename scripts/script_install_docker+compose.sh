sudo apt update && echo "Обновили индексы пакетов apt" \
&& sudo apt install curl software-properties-common ca-certificates apt-transport-https -y \
&& echo "Установили дополнительные пакеты" \
&& wget -O- https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null \
&& echo "импортировали GPG-Ключ" \
&& echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable"| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
&& echo "Добавили репозиторий Докера" \
&& sudo apt update && echo "Еще раз обновили индексы пакетов"\
&& apt-cache policy docker-ce && echo "Проверили из какого репозитория будет выполнятся установка Докера" \
&& sudo apt install docker-ce -y && echo "Установили Докер" \
&& sudo docker -v && echo "Проверили версию Докера в системе"\
&& echo "Начинаем установку Docker Compose" \
&& git clone https://github.com/docker/compose.git && docker compose version && echo "Если видим версия компосе, значит он успешно встал"
