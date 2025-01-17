echo "Учтановим git из репы debian" \
&& sudo apt install git -y \
&& echo "проверим версию" \
&& git --version \
#Для начала работы с Git нужно его настроить. В первую очередь, указываем имя и адрес электронной почты, которые будут использоваться для указания автора. Это важно для командной работы  видеть, кто именно внёс изменения.
#Если вы попытаетесь зафиксировать изменения и сделать коммит (от англ. commit, совершать, фиксировать) без предварительной настройки, то в логах (от англ. log, протокол, журнал) будет указано автоматически сгенерированное имя:
#Author: Ubuntu <ubuntu@localhost>
#Некоторые команды и вовсе не будут работать без указания автора. Чтобы этого не случилось, нужно настроить своего пользователя с помощью команд: 
&& git config --global user.name "John Doe" \
&& git config --global user.email johndoe@rebrainme.com \
# Ключ --global говорит о том, что настройка пользователя будет глобальной (в пределах вашего пользователя, а не системы), и вам не придётся настраивать своё имя для каждого репозитория отдельно.
# Вы убедитесь в этом, посмотрев содержимое файла .gitconfig в домашней директории:
&& cat ~/.gitconfig \



