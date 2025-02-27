# Для начала необходимо установить пакет sudo
apt install sudo -y

# Объявляем пользователя в локальную переменную
user=test

# Создаем нового юзера

sudo adduser $user
# После этого добавляем пользователя в группу sudo
sudo usermod -aG sudo $user

# Затем создадим файл с именем пользователя в каталоге /etc/sudoers.d/
sudo touch /etc/sudoers.d/$user


sudo echo "'$user' ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
