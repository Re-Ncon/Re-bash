#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
BOLD='\033[1m'
GREEN='\033[0;32m'
BLACK='\e[30m'
YELLOW='\033[0;33m'
#!!!!
#UPD: 	1.Обновлен скрипт по установке и настройки SMB
#		2.Добавлен в раздел настройки ОС Astra, скрипт по установке Network File System.
#		3.Исправленны ошибки в названии меню.
#		4.Добавлен в раздел Работы с SSH - установка и удаления пакета ssh, Обновлен(Прошлый не работал XD ) скрипт Генерации ключей ssh
#===========================================================================
#								РАЗДЕЛ МЕНЮ
#===========================================================================
#Основные меню для вызова функций
#Show_menu			|			Главное меню управления
#Show_menu1			|			Меню управление Kaspersky
#Show_menu2			|			Меню управление DrWeb
#Show_menu3			|			Меню управление SSH
#Show_menu4			|			Меню управление Astra
#Show_menu5			|			Меню управление Jacarta
#Show_menu6			|			Меню управление Domain

#install_ald		|			Меню установки ald домена
#install_fipa		|			Меню установки freeipa домена

#opti_1				|			Меню установки DNS
#opti_2				|			Меню установки NTP/chrony
#opti_4				|			Меню установки ZABBIX
#opti_5				|			Меню установки ThunderBird
#opti_7				|			Меню установки NetworkFileServer
#==========================================================================="

show_menu() {
PREFIX="" #Доп. Удаление информации в переменных
START="" #Доп. Удаление информации в переменных
END="" #Доп. Удаление информации в переменных
BASE_IP="" #Доп. Удаление информации в переменных
CURRENT_IP="" #Доп. Удаление информации в переменных

clear
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${GREEN}${BOLD}     МЕНЮ УПРАВЛЕНИЯ RENCON v-1.7a ${NC}            ${RED}${BOLD}Предназначен на ОС Astra Linux\16.06.2026${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}            ${RED}${BOLD}Разработал: Re-Ncon${NC}"
echo -e "${YELLOW}${BOLD}1. Рассылка файлов${NC}"
echo -e "${YELLOW}${BOLD}2. Работа с Kaspersky${NC}"
echo -e "${YELLOW}${BOLD}3. Работа с DrWeb${NC}"
echo -e "${YELLOW}${BOLD}4. Работа с SSH${NC}"
echo -e "${YELLOW}${BOLD}5. Работа с Jacarta${NC}"
echo -e "${YELLOW}${BOLD}6. Работа с Доменом${NC}"
echo -e "${YELLOW}${BOLD}7. Настройка ОС Astra${NC}"
echo -e "${YELLOW}${BOLD}8. Проверка связи с АРМ${NC}"
echo -e "${RED}${BOLD}9.ВЫХОД${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Выберите действие [1-9]:" choice

case "$choice" in
    1) deploy_files;; #yes
    2) show_menu1;; #yes
    3) show_menu2;;
    4) show_menu3;;
    5) show_menu5;;
    6) show_menu6;;
	7) show_menu4;;
    8) ping_arm;;
    9) exit 0;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
show_menu1(){
clear
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${GREEN}${BOLD} МЕНЮ УПРАВЛЕНИЯ RENCON-Kaspersky${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${YELLOW}${BOLD}1. Локальное исправление ошибок KESL${NC}"
echo -e "${YELLOW}${BOLD}2. Установка агентов по сети на АРМ${NC}"
echo -e "${YELLOW}${BOLD}3. Установка сервеной части${NC}"
echo -e "${RED}${BOLD}4. <<< НАЗАД${NC}"
echo -e "${RED}${BOLD}5. ВЫХОД${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Выберите действие [1-5]:" choice

case "$choice" in
#    1) agent_inether_pack;;
    1) check_errors;;
    2) full_pack;;
    3) server_pack;;
    4) show_menu;;
    5) exit 0;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
show_menu2(){
clear
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${GREEN}${BOLD}   МЕНЮ УПРАВЛЕНИЯ RENCON-DrWeb${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${YELLOW}${BOLD}1. Исправления для секретной сессии${NC}"
echo -e "${RED}${BOLD}2. <<< НАЗАД${NC}"
echo -e "${RED}${BOLD}3. ВЫХОД${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Выберите действие [1-3]:" choice

case "$choice" in
    1) errordrweb_sesion;;
    2) show_menu;;
    3) exit 0;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
show_menu3(){
clear
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${GREEN}${BOLD}   МЕНЮ УПРАВЛЕНИЯ RENCON-SSH${NC}"
if [ $(dpkg-query -W -f='${Status}' ssh 2> /dev/null | grep -c "ok installed") -eq 0 ];
then
echo -e "${RED}${BOLD}	SSH НЕ УСТАНОВЛЕН${NC}"
else
ST=`sshd -T | grep -E "permitrootlogin"`
echo -e -n "${GREEN}${BOLD}Сейчас пользователь root для ssh: ${NC}"
if [ "$ST" = "permitrootlogin yes" ]; then
    echo -e "${RED}${BOLD}[ РАЗРЕШЕН ]${NC}"
    else
    echo -e "${GREEN}${BOLD}[ ЗАКРЫТ ]${NC}"
fi
fi
echo -e -n "${GREEN}${BOLD}Ключи SSH: "
if [ -f "/root/.ssh/id_ed25519" ] || [ -f "/root/.ssh/id_ed25519.pub" ]; then
echo -e "${RED}${BOLD}[ СГЕНЕРИРОВАНЫ ] Удолите${NC}"
else
echo -e "${GREEN}${BOLD}[ ОТСУТСТВУЮТ ]${NC}"
fi
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${YELLOW}${BOLD}1. Генерация ключей SSH${NC}"
echo -e "${YELLOW}${BOLD}2. Удаление ключей SSH${NC}"
echo -e "${YELLOW}${BOLD}3. Разблокировка root SSH${NC}"
echo -e "${YELLOW}${BOLD}4. Блокировка root SSH${NC}"
echo -e "${YELLOW}${BOLD}5. Установка SSH${NC}"
echo -e "${YELLOW}${BOLD}6. Удаление SSH${NC}"
echo -e "${RED}${BOLD}7. <<< НАЗАД${NC}"
echo -e "${RED}${BOLD}8. ВЫХОД${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Выберите действие [1-8]:" choice

case "$choice" in
    1) send_keyssh;;
    2) rem_keyssh;;
    3) unblock_ssh_root;;
    4) block_ssh_root;;
    7) show_menu;;
	5) install_ssh;;
	6) rem_ssh;;
    8) exit 0;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
show_menu4(){
clear
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${GREEN}${BOLD}   МЕНЮ УПРАВЛЕНИЯ RENCON-ASTRA${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${YELLOW}${BOLD}1. Настройка DNS${NC}		  ${BLACK}${BOLD}|Адрессация${NC}"
echo -e "${YELLOW}${BOLD}2. Настройка NTP${NC}		  ${BLACK}${BOLD}|Единое время${NC}"
echo -e "${YELLOW}${BOLD}3. Настройка SMB${NC}		  ${BLACK}${BOLD}|Общая директория 'Для ОС Linux и Windows'${NC}"
echo -e "${YELLOW}${BOLD}4. Настройка NFS${NC}		  ${BLACK}${BOLD}|Общая директория 'Только для ОС linux'${NC}"
echo -e "${YELLOW}${BOLD}5. Настройка PXE${NC}		  ${BLACK}${BOLD}|Установка ОС по сети${NC}"
echo -e "${YELLOW}${BOLD}6. Настройка ZABBIX${NC}		  ${BLACK}${BOLD}|Мониторинг${NC}"
echo -e "${YELLOW}${BOLD}7. Настройка THUNDERBIRD${NC}	  ${BLACK}${BOLD}|Почта${NC}"
echo -e "${RED}${BOLD}8. <<< НАЗАД${NC}"
echo -e "${RED}${BOLD}9. ВЫХОД${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Выберите действие [1-9]:" choice

case "$choice" in
    1) opti_1;;#DNS
    2) opti_2;;#NTP
    3) opti_3;;#SMB
    7) opti_4;;#EXIM4
    6) opti_5;;#ZABBIX
    5) opti_6;;#PXE
    4) opti_7;;#NFS

    8) show_menu;;
    9) exit 0;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
show_menu5(){
clear
echo -e "${GREEN}${BOLD}==================================         ${BLACK}${BOLD}|Для установки jacarta, скопируйте .deb файлы${NC}"
echo -e "${GREEN}${BOLD}   МЕНЮ УПРАВЛЕНИЯ RENCON-JACARTA          ${BLACK}${BOLD}|в одну директорию с скриптом!${NC}"
echo -e "${GREEN}${BOLD}==================================         ${BLACK}${BOLD}|${NC}"
echo -e "${YELLOW}${BOLD}1. Установка Сервера Jacarta${NC}"
echo -e "${YELLOW}${BOLD}2. Установка Клиента Jacarta${NC}"
echo -e "${YELLOW}${BOLD}3. Установка Админа Jacarta${NC}"
echo -e "${YELLOW}${BOLD}4. Удаление Jacarta${NC}"
echo -e "${RED}${BOLD}5. <<< НАЗАД${NC}"
echo -e "${RED}${BOLD}6. ВЫХОД${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Выберите действие [1-6]:" choice

case "$choice" in
    1) server_jacarta;;
    2) user_jacarta;;
    3) admin_jacarta;;
	4) remove_jacarta;;
    5) show_menu;;
    6) exit 0;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
#----------------------------------------------------------------------------
}
#===========================================================================
show_menu6(){
clear
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${GREEN}${BOLD}  МЕНЮ УПРАВЛЕНИЯ RENCON-DOMAIN${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${YELLOW}${BOLD}1. ALD-домен${NC}"
echo -e "${YELLOW}${BOLD}2. FreeIPA-домен${NC}"
echo -e "${RED}${BOLD}3. <<< НАЗАД${NC}"
echo -e "${RED}${BOLD}4. ВЫХОД${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Выберите действие [1-4]:" choice

case "$choice" in
    1) install_ald;;
    2) install_fipa;;
    3) show_menu;;
    4) exit 0;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
install_ald(){
clear
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${GREEN}${BOLD}  МЕНЮ УПРАВЛЕНИЯ УСТАНОВКИ ALD${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${YELLOW}${BOLD}1. Установка ALD-домена Сервер${NC}"
echo -e "${YELLOW}${BOLD}2. Установка ALD-домена Клиент${NC}"
echo -e "${YELLOW}${BOLD}3. Установка ALD-домена Резерв${NC}"
echo -e "${YELLOW}${BOLD}4. Удаление  ALD-домена${NC}"
echo -e "${RED}${BOLD}5. <<< НАЗАД${NC}"
echo -e "${RED}${BOLD}6. ВЫХОД${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Выберите действие [1-6]:" choice

case "$choice" in
    1) install_ald_S;;
    2) install_ald_C;;
    3) install_ald_R;;
    4) remove_ald;;
	5) show_menu6;;
    6) exit 0;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
install_fipa(){
clear
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${GREEN}${BOLD}МЕНЮ УПРАВЛЕНИЯ УСТАНОВКИ Free-IPA${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${YELLOW}${BOLD}1. Установка Free-IPA-домена Сервер${NC}"
echo -e "${YELLOW}${BOLD}2. Установка Free-IPA-домена Клиент${NC}"
echo -e "${YELLOW}${BOLD}3. Удаление  Free-IPA-домена${NC}"
echo -e "${RED}${BOLD}4. <<< НАЗАД${NC}"
echo -e "${RED}${BOLD}5. ВЫХОД${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Выберите действие [1-5]:" choice

case "$choice" in
    1) install_fipa_S;;
    2) install_fipa_C;;
    3) remove_fipa;;
	4) show_menu6;;
    5) exit 0;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
opti_1(){
clear
echo -e "${GREEN}${BOLD}=================DNS==============${NC}"
echo -e "${YELLOW}${BOLD}1. Сервер${NC}"
echo -e "${YELLOW}${BOLD}2. Вернуть Настройки${NC}"
echo -e "${GREEN}${BOLD}=================DNS==============${NC}"
read -p "Выберите действие [1-2]:" choice

case "$choice" in
    1) opti_1_server;;
    2) opti_1_reset;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
opti_2(){
clear
echo -e "${GREEN}${BOLD}=================NTP==============${NC}"
echo -e "${YELLOW}${BOLD}1. Сервер${NC}"
echo -e "${YELLOW}${BOLD}2. Клиент${NC}"
echo -e "${GREEN}${BOLD}=================NTP==============${NC}"
read -p "Выберите действие [1-2]:" choice

case "$choice" in
    1) opti_2_server;;
    2) opti_2_client;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
opti_4(){
clear
echo -e "${GREEN}${BOLD}================THUNDERBIRD=============${NC}"
echo -e "${YELLOW}${BOLD}1. Сервер${NC}"
echo -e "${YELLOW}${BOLD}2. Клиент${NC}"
echo -e "${YELLOW}${BOLD}3. Удалить${NC}"
echo -e "${GREEN}${BOLD}================THUNDERBIRD=============${NC}"
read -p "Выберите действие [1-3]:" choice

case "$choice" in
    1) opti_4_server;;
    2) opti_4_client;;
	3) opti_4_remove;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
opti_5(){
clear
echo -e "${GREEN}${BOLD}================ZABBIX=============${NC}"
echo -e "${YELLOW}${BOLD}1. Сервер${NC}"
echo -e "${YELLOW}${BOLD}2. Клиент${NC}"
echo -e "${YELLOW}${BOLD}3. Удалить${NC}"
echo -e "${GREEN}${BOLD}================ZABBIX=============${NC}"
read -p "Выберите действие [1-3]:" choice

case "$choice" in
    1) opti_5_server;;
	2) opti_5_client;;
	3) opti_5_remove;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
opti_7(){
clear
echo -e "${GREEN}${BOLD}=================NFS==============${NC}"
echo -e "${YELLOW}${BOLD}1. Сервер${NC}"
echo -e "${YELLOW}${BOLD}2. Клиент${NC}"
echo -e "${YELLOW}${BOLD}3. Удалить${NC}"
echo -e "${GREEN}${BOLD}=================NFS==============${NC}"
read -p "Выберите действие [1-3]:" choice

case "$choice" in
    1) opti_7_svr;;
	2) opti_7_cli;;
	3) opti_7_rem;;
    *) echo -e "${RED}Неверный выбор!${NC}"
esac
}
#===========================================================================
#							КОНЕЦ РАЗДЕЛА МЕНЮ
#===========================================================================

#===========================================================================
#		Отправка файлов на локальные машины по сети | deploy_files
#===========================================================================
deploy_files(){
clear
echo ""
echo "========================"
echo "Раскидывания файликов"
echo "по ssh на другие машины"
echo "========================"
echo ""

source_dir="/szi"
target_dir="/"
username=""
ssh_port=22
timeout=2

#------------------------------------------------
#Функция которая начинает работу при отработке основной части этого скрипта
#Проверяет на достпность в сети арм за счет попытки пинга.
check_host() {
ping -c 1 $CURRENT_IP 2>&1 >> /dev/null

return $?
}
#------------------------------------------------

echo -e ""
read -p  "Введите начальный IP(например, 192.168.1.1):" BASE_IP
#-----------------------------------------------
#проверяем есть ли у айпишника разделение через "." 4 позиции
#Функция проверяет, правильно ли введен айпи адресс, а именно имеет ли он 4 позиции разделеной точкой, так же каждую позицию записывает в переменную ip parts
IFS='.' read -r -a ip_parts <<< "$BASE_IP"
if [ ${#ip_parts[@]} -ne 4 ]; then
    echo -e "${RED}${BOLD} ОШИБКА, МИЛОРД: Неверный формат IP-адресса${NC}"
    echo "ВЫ ВВЕЛИ:$ip_parts"
    exit 1
fi 
#-----------------------------------------------
echo ""
read -p "Введите колличество машин для копирования, которые находятся в одной подсети: " ARM_COUNT
echo ""
read -p "Введите имя пользователя ssh (например user): " INPUT_USER
echo ""
[ ! -z "$INPUT_USER" ] && username=$INPUT_USER
read -p "МИЛОРД, ВНИМАНИЕ! Начальная директория ($source_dir) Желайте изменить (y,N): " ot1

#-----------------------------------------------
if [ -z $ot1 ]; then
    ot1=n
fi
if [ $ot1 = "y" ] || [ $ot1 = "Y" ]; then
    echo ""
    read -p "Введите новую начальную директорию директорию: " source_dir
    echo -e "${GREEN}${BOLD}Смена начальной директории:${NC} ${YELLOW}${BOLD}$source_dir${NC}"
    else
    echo -e "${GREEN}${BOLD}По умолчанию используется директория:${NC} ${YELLOW}${BOLD}$source_dir${NC}"
    echo ""
fi
read -p "МИЛОРД, ВНИМАНИЕ! Целевая директория ($target_dir) Желайте изменить (y,N): " ot1

#-----------------------------------------------
if [ -z $ot1 ]; then
    ot1=n
fi
if [ $ot1 = "y" ] || [ $ot1 = "Y" ]; then
    echo ""
    read -p "Введите новую целевую директорию: " target_dir
    echo -e "${GREEN}${BOLD}Смена целевой директории:${NC} ${YELLOW}${BOLD}$target_dir${NC}"
    else
    echo -e "${GREEN}${BOLD}По умолчанию используется директория:${NC} ${YELLOW}${BOLD}$target_dir${NC}"
    echo ""
fi
#-----------------------------------------------
PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}."
START=${ip_parts[3]}
END=$((START+ ARM_COUNT-1))
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${GREEN}${BOLD}     Настройки копирования:${NC}"
echo -e "${GREEN}${BOLD}Начальная директория:${NC}${YELLOW}${BOLD}$source_dir${NC}"
echo -e "${GREEN}${BOLD}Целевая директория:${NC}${YELLOW}${BOLD}$target_dir${NC}"
echo -e "${GREEN}${BOLD}Пользователь:${NC}${YELLOW}${BOLD}$username${NC}"
echo -e "${GREEN}${BOLD}Диапазон IP-адрессов${NC}"
echo -e "${YELLOW}${BOLD}$PREFIX$START ; $PREFIX$END${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Нажимет ENTER для начала копирования или CTRL-C для отмены"
#-----------------------------------------------
clear
for ((i=START;i<=END;i++)); do
    CURRENT_IP="${PREFIX}${i}"
    echo -n -e "Проверяем хост ${YELLOW}${BOLD}$CURRENT_IP${NC} ..."
check_host
	ko=$?
	if [ $ko = '0'  ]; then
	echo -e "${GREEN}${BOLD}Доступен${NC}"
	echo -e "${YELLOW}${BOLD}Начинаем копирование на:${NC}${GREEN}${BOLD}$CURRENT_IP ...${NC}"
	scp -r $source_dir $username@$CURRENT_IP:$target_dir 2> /dev/null 1> /dev/null 
	    if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[УСПЕХ]${NC}"
	    else
	    echo -e "${RED}${BOLD}[ОТКАЗ]${NC}"
	    fi
	else
	echo -e "${RED}${BOLD}[НЕДОСТУПЕН] -  Возможно нет сети на АРМ, или он ОТКЛЮЧЕН!${NC}"
	fi
    echo "--------------------------"
done
echo -e "${GREEN}${BtOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
#							НАЧАЛО РАЗДЕЛА KASPERSKY
#===========================================================================
#check_errors			|		Проверка и исправление ошибок Агента
#agent_inether_pack		|		(НЕ ИСПОЛЬЗУЕТСЯ)
#full_pack				|		Установка агентов по сети
#server_pack			|		Установка серверной части Kaspersky
#===========================================================================
check_errors(){
if [ "$USER" != "root" ]; then 
    echo "Этот скрипт должен быть запущен с правами root!">&2
    exit 1
fi

echo -e "${YELLOW}${BOLD}Устанавливаем права 755 на /opt...${NC}"
chmod 755 /opt
if [ $? -eq 0 ] ; then
    echo -e "${GREEN}${BOLD}Права успешно изменены.${NC}"
else
    echo -e "${RED}${BOLD}Ошибка при изменении прав на /opt.${NC}">&2
    exit 1
fi

echo -e "${YELLOW}${BOLD}Меняем источник обновлений Kaspersky Endpoint Security на SCServer...${NC}"
if [ -f /opt/kaspersky/kesl/bin/kesl-setup.pl ]; then
    kesl-control --set-settings 6 SourceType=SCServer
    if [ $? -eq 0 ]; then
	echo -e "${GREEN}${BOLD}Источник обновлений успешно изменен на SCServer${NC}"
	else
	echo -e "${RED}${BOLD}Ошибка при изменении источника обновлений.${NC}">&2
	exit 1
    fi
    else
    echo -e "${RED}${BOLD}Kaspersky Endpoint Security не найден или неустановлен!${NC}">&2
    exit 1
fi

echo -e "${YELLOW}${BOLD}Меняем IP адрес сервера Kaspersky в агенте...${NC}"

if [ -f /opt/kaspersky/klnagent64/lib/bin/klnagent64 ]; then
    read  -p "Введите новый IP адрес сервера:" SERVER_IP
    /opt/kaspersky/klnagent64/bin/klmover -address $SERVER_IP
    if [ $? -eq 0 ]; then
	echo -e "${GREEN}${BOLD}IP адрес сервера успешно изменен на $SERVER_IP${NC}"
	else
	echo -e "${RED}${BOLD}Ошибка при изменении IP адреса сервера.${NC}">&2
	exit 1
    fi
fi
echo "Перезагружаем klnagent64"
systemctl restart klnagent64
sleep 10
echo "Перезагружаем kesl"
systemctl restart kesl
echo -e "${GREEN}${BOLD}Все операции успешно завершены.${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
agent_inether_pack(){
echo "#===========================================================================" >> $LOG_FILE
echo "Начало использования скрипта :$(date +"$DATE_FORMAT")" >>$LOG_FILE
echo "#===========================================================================" >> $LOG_FILE
username="root"

clear
echo -e "${YELLOW}${BOLD}Будет произведенна установка${NC}"
echo -e "${YELLOW}${BOLD}Klnagent64, Kesl, Kesl-gui${NC}"
echo -e "${YELLOW}${BOLD}Процесс установки включается в себя:${NC}"
echo -e "${YELLOW}${BOLD}Установку пакетов dpkg -i, и последующий запуск поистисталов${NC}"
echo -e "${RED}${BOLD}Пожалуйста подождите, процесс выполнения скрипта для 1 машины занимает от 30 секунд! ...${NC}"
#------------------------------------------------H
check_base_ip(){
IFS='.' read -r -a ip_parts <<< "$BASE_IP"
if [ ${#ip_parts[@]} -ne 4 ]; then
echo -e "${RED}${BOLD} ОШИБКА, МИЛОРД: Неверный формат IP-адресса${NC}"
echo "ВЫ ВВЕЛИ:$ip_parts"
exit 1
fi
}
#Для Диапазона
#------------------------------------------------H
check_base_ip2(){
IFS='.' read -r -a ip_parts <<< "$ip"
}
#Для файла hosts
#------------------------------------------------H
check_host() {
ping -c 1 $CURRENT_IP 1>> $LOG_FILE 2>> $LOG_FILE
return $?
}
#------------------------------------------------H
check_arm_ip(){
IFS='.' read -r -a ip_parts <<< "$ARM_KASPER"
if [ ${#ip_parts[@]} -ne 4 ]; then
    echo -e "${RED}${BOLD} ОШИБКА, МИЛОРД: Неверный формат IP-адресса${NC}"
    echo "ВЫ ВВЕЛИ:$ip_parts"
    exit 1
fi
}
#------------------------------------------------H
echo -e -n "${GREEN}${BOLD}Хотите использовать IP адреса АРМ из файла /etc/hosts? [y/N]: ${NC}"
read hosts_ot1
if [ -z $hosts_ot1 ]; then
    hosts_ot1=n
fi
#------------------------------------------------------------
if [ $hosts_ot1 = "y" ] || [ $hosts_ot1 = "Y" ]; then
#------------------------------------------------------------
TEMP_IPS=$(mktemp)
grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "/etc/hosts" > "$TEMP_IPS" # Читаем файлик хостс и вытаскиваем только ип Создаем временный файлик и записываем туда айпишники
	else
echo -e ""
read -p  "Введите начальный IP(например, 192.168.1.1):" BASE_IP
check_base_ip
echo ""
read -p "Введите колличество машин, которые находятся в одной подсети: " ARM_COUNT
PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}."
START=${ip_parts[3]}
END=$((START+ ARM_COUNT-1))
fi
echo ""
read -p "Введите адресс сервера централизованного упарвления KASPERSKY например (192.168.1.1): " ARM_KASPER
echo ""
echo -e "${YELLOW}${BOLD}Укажите откуда клиентская часть будет загружать базы${NC}"
echo -e "${GREEN}${BOLD}Напишите ${YELLOW}${BOLD}[KLServers]${GREEN}${BOLD} - если хотите загружать базы из интернета!${NC}"
echo -e "${GREEN}${BOLD}Напишите ${YELLOW}${BOLD}[SCServer]${GREEN}${BOLD} - если хотите загружать базы c сервера KASPERSKY в локальной сети!${NC}"
echo -e "${GREEN}${BOLD}Напишите ${YELLOW}${BOLD}[/bases]${GREEN}${BOLD} - если хотите загружать базы локально с этой машины!${NC}"
read -p "Укажите откуда: " ARM_BASES
read -p "Укажите директорию где находятся пакеты установки:" dir_arm
echo ""
read -p "Нажимет ENTER для начала удаленной установки или CTRL-C для отмены"
#-----------------------------------------------
tmpfile_a=/tmp/tmpfilea.pstntl
tmpfile_k=/tmp/tmpfilek.pstntl
#-----------------------------------------------AGENT
echo "EULA_ACCEPTED=Y
KLNAGENT_SERVER=$ARM_KASPER
KLNAGENT_PORT=14000
KLNAGENT_SSLPORT=13000
KLNAGENT_USESSL=Y
KLNAGENT_GW_MODE=1" > $tmpfile_a && cp $tmpfile_a /tmp/autoanswers.conf
#-----------------------------------------------KESL
echo "EULA_AGREED=yes
PRIVACY_POLICY_AGREED=yes
USE_KSN=yes
UPDATER_SOURCE=$ARM_BASES
UPDATE_EXECUTE=no
CONFIGURE_SELINUX=yes
KERNEL_SRCS_INSTALL=yes
USE_GUI=yes" > $tmpfile_k && cp $tmpfile_k /tmp/autoinstall.ini
#-----------------------------------------------
clear
if [ $hosts_ot1 = "y" ] || [ $hosts_ot1 = "Y" ]; then
while read -r ip; do
check_base_ip2  #Разделяем айпишник на партсы тобишь, первый парт это первые цифры до точки, след партс это следющие цифры до точки и т.д.
PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}."
CURRENT_IP="${PREFIX}${ip_parts[3]}"
	if [ `hostname -I` = "$CURRENT_IP" ] || [ "$CURRENT_IP" = "127.0.0.1" ]; then
	echo -e "Будет пропущен так как это локальный хост ${YELLOW}${BOLD}$CURRENT_IP${NC}"
	echo "Будет пропущен так как это локальный хост "
	else
	echo -n -e "Проверяем хост ${YELLOW}${BOLD}$CURRENT_IP${NC} ..."
check_host
	ko=$?
	if [ $ko = '0'  ]; then
	echo -e "${GREEN}${BOLD}Доступен${NC}"
	echo -e "${YELLOW}${BOLD}Начинаем установку на:${NC}${GREEN}${BOLD}$CURRENT_IP ...${NC}"
	scp -r /tmp/autoinstall.ini root@$CURRENT_IP:/tmp/ >> $LOG_FILE
	scp -r /tmp/autoanswers.conf root@$CURRENT_IP:/tmp/ >> $LOG_FILE
	ssh -t $username@$CURRENT_IP "cd $dir_arm; bash" << 'EOF' >> $LOG_FILE
	sudo dpkg -i /klnagent*.deb
	sudo dpkg -i /kesl_*.deb
	sudo dpkg -i /kesl-*.deb
	sleep 2
	KLAUTOANSWERS=/tmp/autoanswers.conf
	sudo KLAUTOANSWERS=/tmp/autoanswers.conf /opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl
	sudo systemctl restart klnagent64
	sudo /opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall=/tmp/autoinstall.ini
	sudo systemctl start kesl
	sleep 2
	sudo rm /tmp/autoinstall.ini
	sudo rm /tmp/autoanswers.conf
EOF
	    if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[УСПЕХ]${NC}"
	    else
	    echo -e "${RED}${BOLD}[ОТКАЗ]${NC}"
	    fi
	else
	echo -e "${RED}${BOLD}[НЕДОСТУПЕН] -  Возможно нет сети на АРМ, или он ОТКЛЮЧЕН!${NC}"
	fi
    echo "--------------------------"
    fi
done < "$TEMP_IPS"
rm $TEMP_IPS
	else
for ((i=START;i<=END;i++)); do
    CURRENT_IP="${PREFIX}${i}"
    echo -n -e "Проверяем хост ${YELLOW}${BOLD}$CURRENT_IP${NC} ..."
check_host
	ko=$?
	if [ $ko = '0'  ]; then
	echo -e "${GREEN}${BOLD}Доступен${NC}"
	echo -e "${YELLOW}${BOLD}Начинаем установку на:${NC}${GREEN}${BOLD}$CURRENT_IP ...${NC}"
	echo -e "Начинаем установку на: $CURRENT_IP ..." >>$LOG_FILE
	scp -r /tmp/autoinstall.ini root@$CURRENT_IP:/tmp/ >>$LOG_FILE
	scp -r /tmp/autoanswers.conf root@$CURRENT_IP:/tmp/ >>$LOG_FILE
	ssh $username@$CURRENT_IP "cd $dir_arm; bash" << 'EOF' >> $LOG_FILE
	sudo dpkg -i /klnagent*.deb
	sudo dpkg -i /kesl_*.deb
	sudo dpkg -i /kesl-*.deb
	sleep 2
	KLAUTOANSWERS=/tmp/autoanswers.conf
	sudo KLAUTOANSWERS=/tmp/autoanswers.conf /opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl
	sudo systemctl restart klnagent64
	sudo /opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall=/tmp/autoinstall.ini
	sudo systemctl start kesl
	sleep 2
	sudo rm /tmp/autoinstall.ini
	sudo rm /tmp/autoanswers.conf
EOF
	    if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[УСПЕХ]${NC}"
	    else
	    echo -e "${RED}${BOLD}[ОТКАЗ]${NC}"
	    fi
	else
	echo -e "${RED}${BOLD}[НЕДОСТУПЕН] -  Возможно нет сети на АРМ, или он ОТКЛЮЧЕН!${NC}"
	fi
    echo "--------------------------"
done
fi
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
full_pack(){
source_dir="/szi"
target_dir="/"
username=""
ssh_port=22
timeout=2
clear
echo -e "${RED}${BOLD}ВНИМАНИЕ!!!${NC}"
echo -e "${YELLOW}${BOLD}Данный процесс выполняет копирование файлов(deb)${NC}"
echo -e "${YELLOW}${BOLD}Установку и настройку пакетов KESL, KLNAGENT64, KESL-GUI${NC}"
echo -e "${YELLOW}${BOLD}Проверка ошибок и их исправление${NC}"
echo -e "${RED}${BOLD}Процесс выполнения скрипта для 1 машины может занимает 30-120 секунд! ...${NC}"
read -p "Нажимет ENTER для начала или CTRL-C для отмены"
#------------------------------------------------H
check_base_ip(){
IFS='.' read -r -a ip_parts <<< "$BASE_IP"
if [ ${#ip_parts[@]} -ne 4 ]; then
echo -e "${RED}${BOLD} ОШИБКА, МИЛОРД: Неверный формат IP-адресса${NC}"
echo "ВЫ ВВЕЛИ:$ip_parts"
exit 1
fi
}
#------------------------------------------------H
check_host() {
ping -c 1 $CURRENT_IP 2>&1 >> /dev/null
return $?
}
#------------------------------------------------H
check_arm_ip(){
IFS='.' read -r -a ip_partss <<< "$ARM_KASPER"
if [ ${#ip_partss[@]} -ne 4 ]; then
    echo -e "${RED}${BOLD} ОШИБКА, МИЛОРД: Неверный формат IP-адресса${NC}"
    echo "ВЫ ВВЕЛИ:$ip_partss"
    exit 1
fi
}
#------------------------------------------------H
echo -e ""
read -p  "Введите начальный IP(например, 192.168.1.1):" BASE_IP
#-----------------------------------------------
check_base_ip
#-----------------------------------------------
echo ""
read -p "Введите колличество АРМ, которые находятся в одной подсети: " ARM_COUNT
echo ""
read -p "Введите имя пользователя ssh (например user): " INPUT_USER
echo ""
[ ! -z "$INPUT_USER" ] && username=$INPUT_USER
read -p "МИЛОРД, ВНИМАНИЕ! Локальная директория которая будет копироваться ($source_dir) Желайте изменить (y,N): " ot1

#-----------------------------------------------
if [ -z $ot1 ]; then
    ot1=n
fi
if [ $ot1 = "y" ] || [ $ot1 = "Y" ]; then
    echo ""
    read -p "Введите новую локальную директорию: " source_dir
    echo -e "${GREEN}${BOLD}Смена локальной директории:${NC} ${YELLOW}${BOLD}$source_dir${NC}"
    else
    echo -e "${GREEN}${BOLD}По умолчанию используется директория:${NC} ${YELLOW}${BOLD}$source_dir${NC}"
    echo ""
fi
#-----------------------------------------------
read -p "МИЛОРД, ВНИМАНИЕ! Целевая/конечная директория ($target_dir) Желайте изменить (y,N): " ot1

#-----------------------------------------------
if [ -z $ot1 ]; then
    ot1=n
fi
if [ $ot1 = "y" ] || [ $ot1 = "Y" ]; then
    echo ""
    read -p "Введите новую целевую директорию: " target_dir
    echo -e "${GREEN}${BOLD}Смена целевой директории:${NC} ${YELLOW}${BOLD}$target_dir${NC}"
    else
    echo -e "${GREEN}${BOLD}По умолчанию используется директория:${NC} ${YELLOW}${BOLD}$target_dir${NC}"

fi
    echo ""
    read -p "Введите адресс сервера централизованного упарвления KASPERSKY например (192.168.1.1): " ARM_KASPER
    echo ""
    echo -e "${YELLOW}${BOLD}Укажите откуда клиентская часть будет загружать базы${NC}"
    echo -e "${GREEN}${BOLD}Напишите ${YELLOW}${BOLD}[KLServers]${GREEN}${BOLD} - если хотите загружать базы из интернета!${NC}"
    echo -e "${GREEN}${BOLD}Напишите ${YELLOW}${BOLD}[SCServer]${GREEN}${BOLD} - если хотите загружать базы c сервера KASPERSKY в локальной сети!${NC}"
    echo -e "${GREEN}${BOLD}Напишите ${YELLOW}${BOLD}[/bases]${GREEN}${BOLD} - если хотите загружать базы локально с этой машины!${NC}"
    read -p "Укажите откуда: " ARM_BASES
    echo ""
#-----------------------------------------------
PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}."
START=${ip_parts[3]}
END=$((START+ ARM_COUNT-1))
echo -e "${GREEN}${BOLD}==================================${NC}"
echo -e "${GREEN}${BOLD}          Настройки:${NC}"
echo -e "${GREEN}${BOLD}Целевая директория:${NC}${YELLOW}${BOLD}$target_dir${NC}"
echo -e "${GREEN}${BOLD}Локальная директория:${NC}${YELLOW}${BOLD}$source_dir${NC}"
echo -e "${GREEN}${BOLD}Пользователь:${NC}${YELLOW}${BOLD}$username${NC}"
echo -e "${GREEN}${BOLD}Сервер Kaspersky:${NC}${YELLOW}${BOLD}$ARM_KASPER${NC}"
echo -e "${GREEN}${BOLD}Загрузка А/Б из:${NC}${YELLOW}${BOLD}$ARM_BASES${NC}"
echo -e "${GREEN}${BOLD}Диапазон IP-адрессов${NC}"
echo -e "${YELLOW}${BOLD}$PREFIX$START ; $PREFIX$END${NC}"
echo -e "${GREEN}${BOLD}==================================${NC}"
read -p "Нажимет ENTER для начала копирования или CTRL-C для отмены"
#-----------------------------------------------
#-----------------------------------------------
PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}."
START=${ip_parts[3]}
END=$((START+ ARM_COUNT-1))
tmpfile_a=/tmp/tmpfilea.pstntl
tmpfile_k=/tmp/tmpfilek.pstntl
#-----------------------------------------------AGENT
echo "EULA_ACCEPTED=Y
KLNAGENT_SERVER=$ARM_KASPER
KLNAGENT_PORT=14000
KLNAGENT_SSLPORT=13000
KLNAGENT_USESSL=Y
KLNAGENT_GW_MODE=1" > $tmpfile_a && cp $tmpfile_a /tmp/autoanswers.conf
#-----------------------------------------------KESL
echo "EULA_AGREED=yes
PRIVACY_POLICY_AGREED=yes
USE_KSN=yes
UPDATER_SOURCE=$ARM_BASES
UPDATE_EXECUTE=no
CONFIGURE_SELINUX=yes
KERNEL_SRCS_INSTALL=yes
USE_GUI=yes" > $tmpfile_k && cp $tmpfile_k /tmp/autoinstall.ini
#-----------------------------------------------
clear
for ((i=START;i<=END;i++)); do
    CURRENT_IP="${PREFIX}${i}"
    echo -n -e "Проверяем хост ${YELLOW}${BOLD}$CURRENT_IP${NC} ..."
check_host
	ko=$?
	if [ $ko = '0'  ]; then
	echo -e "${GREEN}${BOLD}Доступен${NC}"
	echo -e "${YELLOW}${BOLD}Начинаем установку на:${NC}${GREEN}${BOLD}$CURRENT_IP ...${NC}"
	scp -r /tmp/autoinstall.ini $username@$CURRENT_IP:/tmp/ 2> /dev/null 1> /dev/null
	scp -r /tmp/autoanswers.conf $username@$CURRENT_IP:/tmp/ 2> /dev/null 1> /dev/null
	scp -r $source_dir $username@$CURRENT_IP:$target_dir 2> /dev/null 1> /dev/null 
	ssh -t $username@$CURRENT_IP "cd $target_dir; bash"<< 'EOF'
	sudo dpkg -i /klnagent*.deb
	sudo dpkg -i /kesl_*.deb
	sudo dpkg -i /kesl-*.deb
	sleep 2
	KLAUTOANSWERS=/tmp/autoanswers.conf
	sudo KLAUTOANSWERS=/tmp/autoanswers.conf /opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl
	sudo systemctl restart klnagent64
	sudo /opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall=/tmp/autoinstall.ini
	sudo systemctl start kesl
	sleep 2
	sudo rm /tmp/autoinstall.ini
	sudo rm /tmp/autoanswers.conf
	chmod 755 /opt
EOF
	    if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[УСПЕХ]${NC}"
	    else
	    echo -e "${RED}${BOLD}[ОТКАЗ]${NC}"
	    fi
	else
	echo -e "${RED}${BOLD}[НЕДОСТУПЕН] -  Возможно нет сети на АРМ, или он ОТКЛЮЧЕН!${NC}"
	fi
    echo "--------------------------"
done
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
# =========================================================
# ПЕРЕМЕННЫЕ ЛОГИРОВАНИЯ И НАСТРОЙКИ
# =========================================================

server_pack(){
clear
LOG_TO_FILE=1  # 0 - писать всё скрытно в файл, 1 - выводить весь ход команд на экран
LOG_PATH="/var/log/ksc_install.log"

# Коды цветов для красивого вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Инициализация лог-файла
if [ "$LOG_TO_FILE" -eq 0 ]; then
    touch "$LOG_PATH" && chmod 640 "$LOG_PATH"
    echo "=== Запуск установки KSC на Astra Linux: $(date) ===" > "$LOG_PATH"
fi

# Функция выполнения команд в зависимости от режима логов
run_cmd() {
    if [ "$LOG_TO_FILE" -eq 0 ]; then
        eval "$@" >> "$LOG_PATH" 2>&1
    else
        echo -e "${BLUE}[Команда]: $@${NC}"
        eval "$@"
    fi
}

# Функция вывода статуса [ OK ] или [ ОТКАЗ ]
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${BOLD}[ ОК ]${NC}"
    else
        echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
        if [ "$LOG_TO_FILE" -eq 0 ]; then
            echo -e "${YELLOW}Проверьте лог для отладки: $LOG_PATH${NC}"
        fi
        exit 1
    fi
}

echo -e "${GREEN}${BOLD}Установка сервера централизованного управления KASPERSKY${NC}"
echo -e "${GREEN}${BOLD}В установку входит MariaDB, KSC, WEB-консоль, KESL, KLNAGENT${NC}"
sleep 1
echo ""

# Интерактивный опрос
read -p "Пароль для пользователя root БД задан? [Y/n] " ot2 
ot2=${ot2:-y}

if [ "${ot2,,}" = "n" ]; then
    read -sp "Задайте пароль root для БД: " pass_root
    echo -e "\n${GREEN}${BOLD}Пароль будет применен при настройке MariaDB${NC}"
else
    read -sp "Введите текущий пароль root БД: " pass_root
fi
echo ""

read -p "Введите IP-address этого компьютера: " KSC_IP 

echo -e "\n${GREEN}${BOLD}               Начинаем установку на Astra Linux${NC}\n"
sleep 1

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Установка MariaDB          ${NC}"
if ! dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep "ok installed" > /dev/null; then
    run_cmd "apt-get update && apt-get install mariadb-server -y"
    check_status
else
    echo -e "${GREEN}${BOLD}[ Уже установлен ]${NC}"
fi
sleep 1

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Проверка директории логов  ${NC}"
run_cmd "mkdir -p /var/log/mariadb"
run_cmd "chown -R mysql:mysql /var/log/mariadb"
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Инициализация пароля СУБД  ${NC}"
run_cmd "mysql -e \"ALTER USER 'root'@'localhost' IDENTIFIED BY '${pass_root}'; FLUSH PRIVILEGES;\""
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Обновление конфигурации БД ${NC}"
run_cmd "mysql_upgrade -u root -p'${pass_root}' --verbose --force"
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}5. Настройка my.cnf           ${NC}"
cat << EOF > /etc/mysql/mariadb.cnf
[client]
default-character-set=utf8mb4
[mysql]
default-character-set=utf8mb4
[mysqld]
collation-server=utf8mb4_unicode_ci
init-connect='SET NAMES utf8mb4'
character-set-server=utf8mb4

[mariadb]
log_output=FILE
general_log=1
general_log_file=/var/log/mariadb/mariadb.log

[client-server]
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[server]
sort_buffer_size=10M
join_buffer_size=100M
join_buffer_space_limit=300M
join_cache_level=8
tmp_table_size=512M
max_heap_table_size=512M
key_buffer_size=200M
innodb_buffer_pool_size=512M
innodb_thread_concurrency=20
innodb_flush_log_at_trx_commit=0
innodb_lock_wait_timeout=300
max_allowed_packet=32M
max_connections=151
max_prepared_stmt_count=12800
table_open_cache=60000
table_open_cache_instances=4
table_definition_cache=60000
optimizer_switch='join_cache_incremental=on'
optimizer_switch='join_cache_hashed=on'
optimizer_switch='join_cache_bka=on'
EOF
run_cmd "systemctl restart mariadb"
check_status
sleep 1

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}6. Создание БД и прав KSC     ${NC}"
run_cmd "mysql -u root -p'${pass_root}' -e \"
CREATE DATABASE IF NOT EXISTS KAV;
CREATE USER IF NOT EXISTS 'ksc'@'localhost' IDENTIFIED BY '12345678';
GRANT USAGE ON *.* TO 'ksc'@'localhost';
GRANT SELECT, SHOW VIEW ON mysql.* TO 'ksc'@'localhost';
GRANT SELECT, SHOW VIEW ON sys.* TO 'ksc'@'localhost';
GRANT PROCESS, SUPER ON *.* TO 'ksc'@'localhost';
GRANT ALL PRIVILEGES ON KAV.* TO 'ksc'@'localhost';
FLUSH PRIVILEGES;\""
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}7. Настройка групп в OS       ${NC}"
run_cmd "groupadd -f kladmins"
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}8. Установка пакета KSC       ${NC}"
run_cmd "dpkg -i ./ksc64*.deb"
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}9. Постинсталл KSC            ${NC}"
cat << EOF > /tmp/answers.txt
EULA_ACCEPTED=1
PP_ACCEPTED=1
KLSRV_UNATT_SERVERADDRESS=$KSC_IP
KLSRV_UNATT_DBMS_TYPE=mysql
KLSRV_UNATT_DBMS_INSTANCE=localhost
KLSRV_UNATT_DBMS_PORT=3306
KLSRV_UNATT_DB_NAME=KAV
KLSRV_UNATT_DBMS_LOGIN=ksc
KLSRV_UNATT_DBMS_PASSWORD=12345678
KLSRV_UNATT_DBMS_KLADMINSGROUP=kladmins
EOF
run_cmd "KLAUTOANSWERS=/tmp/answers.txt /opt/kaspersky/ksc64/lib/bin/setup/postinstall.pl"
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}10. Установка Web-console     ${NC}"
run_cmd "dpkg -i ./ksc-web*.deb"
if [ $? -eq 0 ]; then
    HOST_ARM=$(hostname)

    # Автоматический выбор логики установки в зависимости от версии консоли (v15 или старая)
    if [ -f "/opt/kaspersky/ksc-web-console/setup/setup.sh" ]; then
        run_cmd "mkdir -p /etc/ksc-web-console"
        cat << EOF > /etc/ksc-web-console/setup.json
{
 "address": "$KSC_IP",
 "port": 8080,
 "defaultLangId": 1049,
 "enableLog": true,
 "trusted": "$KSC_IP|13299|/var/opt/kaspersky/klnagent_srv/1093/cert/klserver.cer|$HOST_ARM",
 "acceptEula": true,
 "certPath": "/var/opt/kaspersky/klnagent_srv/1093/cert/klserver.cer"
}
EOF
        run_cmd "/opt/kaspersky/ksc-web-console/setup/setup.sh --set-settings /etc/ksc-web-console/setup.json --silent"
    else
        cat << EOF > /etc/ksc-web-console-setup.json
{
 "address": "$KSC_IP",
 "port": 8080,
 "defaultLangId": 1049,
 "enableLog": true,
 "trusted": "$KSC_IP|13299|/var/opt/kaspersky/klnagent_srv/1093/cert/klserver.cer|$HOST_ARM",
 "acceptEula": true,
 "certPath": "/var/opt/kaspersky/klnagent_srv/1093/cert/klserver.cer"
}
EOF
        run_cmd "/opt/kaspersky/ksc-web-console/setup/postinstall.pl"
    fi
    check_status
else
    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
    exit 1
fi

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}11. Установка Агента (klnagent)${NC}"
run_cmd "dpkg -i ./klnagent*.deb"
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}12. Постинсталл Агента        ${NC}"
cat << EOF > /tmp/autoanswers.conf
EULA_ACCEPTED=Y
KLNAGENT_SERVER=$KSC_IP
KLNAGENT_PORT=14000
KLNAGENT_SSLPORT=13000
KLNAGENT_USESSL=Y
KLNAGENT_GW_MODE=1
EOF
run_cmd "KLAUTOANSWERS=/tmp/autoanswers.conf /opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl"
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}13. Установка KESL            ${NC}"
run_cmd "dpkg -i ./kesl_*.deb"
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}14. Постинсталл KESL          ${NC}"
cat << EOF > /tmp/autoinstall.ini
EULA_AGREED=yes
PRIVACY_POLICY_AGREED=yes
USE_KSN=yes
UPDATER_SOURCE=$KSC_IP
UPDATE_EXECUTE=no
CONFIGURE_SELINUX=yes
KERNEL_SRCS_INSTALL=yes
USE_GUI=yes
EOF
run_cmd "/opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall=/tmp/autoinstall.ini"
run_cmd "systemctl start kesl"
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}15. Установка KESL GUI        ${NC}"
run_cmd "dpkg -i ./kesl-*.deb"
check_status

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}16. Перезапуск служб          ${NC}"
run_cmd "systemctl restart klnagent64"
run_cmd "systemctl restart klserver"
run_cmd "systemctl restart kesl"
check_status

echo -e "\n\n${GREEN}${BOLD}==============================="${NC}"
echo -e "${GREEN}${BOLD} УСТАНОВКА УСПЕШНО ЗАВЕРШЕНА  ${NC}"
echo -e "${GREEN}${BOLD}==============================="${NC}"
read -p "Нажмите Enter для выхода..." 
}

# Запуск функции установки
server_pack
serкver_pack(){
clear
echo -e "${GREEN}${BOLD}Установка сервера централизованного управления KASPERSKY${NC}"
echo -e "${GREEN}${BOLD}В установку входит MariaBD KSC WEB KESL KLNAGENT KESL-GUI${NC}"
sleep 1
echo ""
read -p "Пароль для пользователя root задан? [Y/n] " ot2 
if [ -z "$ot2" ]; then
    ot2=y
fi
if [ $ot2 = "n" ] || [ $ot2 = "N" ]; then
    read -sp "Задайте пароль root: " pass_root
    echo -e "${GREEN}${BOLD}Смена пароля${NC}"
    else
    read -sp "Введите пароль root: " pass_root
fi
echo ""
read -p "Введите ip-address этого компьютера: " KSC_IP 

echo ""
echo -e "${GREEN}${BOLD}              Начинаем установку${NC}"
echo ""
sleep 1
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Установка MariaDB          ${NC}"
if [ $(dpkg-query -W -f='${Status}' mariadb-server 2> /dev/null | grep -c "ok installed") -eq 0 ];
then
sudo apt install mariadb-server -y 2> /dev/null 1> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ ОК ]${NC}"

	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"

	fi

else
    echo -e "${GREEN}${BOLD}[ Уже установлен ]${NC}"
fi
sleep 1
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Конфигурация MariaDB       ${NC}"
[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
expect -c 2> /dev/null 1> /dev/null "
spawn \"mysql_secure_installation\"
sleep 1
send \"$pass_root\r\"
sleep 1
send \"y\r\"
sleep 1
send \"$pass_root\r\"
sleep 1
send \"$pass_root\r\"
sleep 1
send \"y\r\"
sleep 1
send \"y\r\"
sleep 1
send \"y\r\"
sleep 1
send \"y\r\"
sleep 1
expect eof"
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"

	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"

fi
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Обновление MariaBD         ${NC}"
sudo mysql_upgrade --verbose --force 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"

	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
 
fi
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Настройка my.conf          ${NC}"
rm /etc/mysql/mariadb.cnf
touch /etc/mysql/mariadb.cnf
cat << EOF >> /etc/mysql/mariadb.cnf
[client]
default-character-set=utf8mb4
[mysql]
default-character-set=utf8mb4
[mysqld]

collation-server=utf8mb4_unicode_ci
init-connect='SET NAMES utf8mb4'
character-set-server=utf8mb4

[mariadb]

log_output=FILE
general_log=1
general_log_file=/var/log/mariadb/mariadb.log

[client-server]

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[server]

sort_buffer_size=10M
join_buffer_size=100M
join_buffer_space_limit=300M
join_cache_level=8
tmp_table_size=512M
max_heap_table_size=512M
key_buffer_size=200M
innodb_buffer_pool_size=512M
innodb_thread_concurrency=20
innodb_flush_log_at_trx_commit=0
innodb_lock_wait_timeout=300
max_allowed_packet=32M
max_connections=151
max_prepared_stmt_count=12800
table_open_cache=60000
table_open_cache_instances=4
table_definition_cache=60000
optimizer_switch='join_cache_incremental=on'
optimizer_switch='join_cache_hashed=on'
optimizer_switch='join_cache_bka=on'

EOF

if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
sleep 1
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}5. Настройка Базы             ${NC}"

[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
expect -c 2> /dev/null 1> /dev/null "
spawn \"mariadb\"
sleep 2
send \"create database KAV;\r\"
send \"create user 'ksc'@'localhost' identified by '12345678';\r\"
send \"grant usage privileges on *.* to 'ksc'@'localhost';\r\"
send \"grant select on mysql.* to 'ksc'@'localhost';\r\"
send \"grant show view on mysql.* to 'ksc'@'localhost';\r\"
send \"grant select on sys.* to 'ksc'@'localhost';\r\"
send \"grant show view on sys.* to 'ksc'@'localhost';\r\"
send \"grant process on *.* to 'ksc'@'localhost';\r\"
send \"grant super on *.* to 'ksc'@'localhost';\r\"
send \"alter user 'ksc'@'localhost' identified by '12345678';\r\"
send \"exit\r\"
expect eof"

if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}6. Настройка пользователя ksc ${NC}"
useradd ksc 2> /dev/null 1> /dev/null
expect -c 2> /dev/null 1> /dev/null "
spawn \"passwd ksc\r\"
send \"12345678\r\"
send \"12345678\r\"
expect eof"
groupadd kladmins 2> /dev/null 1> /dev/null
gpasswd -a ksc kladmins 2> /dev/null 1> /dev/null
usermod -g kladmins ksc 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"

	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"

fi

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}7. Установка KSCL             ${NC}"
dpkg -i /ksc64-*.deb 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}8. Постинсталл KSCL           ${NC}"
tmpfile_s=/tmp/tmpfiles.pstntl
echo "EULA_ACCEPTED=1
PP_ACCEPTED=1
KLSRV_UNATT_SERVERADDRESS=$KSC_IP
KLSRV_UNATT_DBMS_TYPE=mysql
KLSRV_UNATT_DBMS_INSTANCE=$KSC_IP
KLSRV_UNATT_DBMS_PORT=3306
KLSRV_UNATT_DB_NAME=kav
KLSRV_UNATT_DBMS_LOGIN=ksc
KLSRV_UNATT_DBMS_PASSWORD=12345678
KLSRV_UNATT_DBMS_KLADMINSGROUP=kladmins
KLSRV_UNATT_DBMS_KLSRVUSER=ksc
KLSRV_UNATT_DBMS_KLSRVCUSER=ksc
" > $tmpfile_s && cp $tmpfile_s /tmp/answers.txt
sudo /opt/kaspersky/ksc64/sbin/kladduser -n ksc -p 12345678 2> /dev/null 1> /dev/null
sudo KLAUTOANSWERS=/tmp/answers.txt /opt/kaspersky/ksc64/lib/bin/setup/postinstall.pl 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"

	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"

fi
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}9. Установка Web-console      ${NC}"
dpkg -i /ksc-web*.deb 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
if [ -f /etc/ksc-web-console-setup.json ]; then
sudo rm /etc/ksc-web-console-setup.json
sudo touch /etc/ksc-web-console-setup.json 2> /dev/null 1> /dev/null
else
sudo touch /etc/ksc-web-console-setup.json 2> /dev/null 1> /dev/null
fi
HOST_ARM=`hostname`
cat << EOF >> /etc/ksc-web-console-setup.json
{
 "address":\"$KSC_IP\",
 "port":8080,
 "defaultLangId":1049,
 "enableLog":true,
 "trusted":"$KSC_IP|13299|/var/opt/kaspersky/klnagent_srv/1093/cert/klserver.cer|$HOST_ARM",
 "acceptEula":true,
 "certPath":"/var/opt/kaspersky/klnagent_srv/1093/cert/klserver.cer"
}
EOF
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}10. Установка KLNAGENT64      ${NC}"
dpkg -i /klnagent*.deb 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}11. Постинсталл KLNAGENT64    ${NC}"
tmpfile_a=/tmp/tmpfilea.pstntl
#-----------------------------------------------AGENT
echo "EULA_ACCEPTED=Y
KLNAGENT_SERVER=$KSC_IP
KLNAGENT_PORT=14000
KLNAGENT_SSLPORT=13000
KLNAGENT_USESSL=Y
KLNAGENT_GW_MODE=1" > $tmpfile_a && cp $tmpfile_a /tmp/autoanswers.conf
KLAUTOANSWERS=/tmp/autoanswers.conf
sudo KLAUTOANSWERS=/tmp/autoanswers.conf /opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}12. Установка KESL            ${NC}"
dpkg -i /kesl_*.deb 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}13. Постинсталл KESL          ${NC}"
tmpfile_k=/tmp/tmpfilek.pstntl
#-----------------------------------------------KESL
echo "EULA_AGREED=yes
PRIVACY_POLICY_AGREED=yes
USE_KSN=yes
UPDATER_SOURCE=$KSC_IP
UPDATE_EXECUTE=no
CONFIGURE_SELINUX=yes
KERNEL_SRCS_INSTALL=yes
USE_GUI=yes" > $tmpfile_k && cp $tmpfile_k /tmp/autoinstall.ini
	sudo /opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall=/tmp/autoinstall.ini 2> /dev/null 1> /dev/null
	sudo systemctl start kesl 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}14. Установка KESL GUI        ${NC}"
dpkg -i /kesl-*.deb 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}15. Перезагрузка klnagent     ${NC}"
sudo systemctl restart klnagent64 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}16. Перезагрузка KSC          ${NC}"
sudo systemctl restart ksc 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}17. Перезагрузка KESL         ${NC}"
sudo systemctl restart kesl 2> /dev/null 1> /dev/null
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
echo ""
echo ""
echo ""
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
#							КОНЕЦ РАЗДЕЛА KASPERSKY
#===========================================================================

#===========================================================================
#							НАЧАЛО РАЗДЕЛА SSH
#===========================================================================
#send_keyssh			|		Генерация ключей SSH
#rem_keyssh				|		Удаление ключей SSH
#unblock_ssh_root		|		Разблокировка пользователя root по ssh
#block_ssh_root			|		Блокировка пользователя root по ssh
#===========================================================================
send_keyssh(){
clear
echo -e "${GREEN}${BOLD}Генерация ключей SSH, для подключения без пароля${NC}"
echo -e "${RED}${BOLD}ВНИМАНИЕ! После использования данной функции в своих целях, не забудьте удалить ключи!${NC}"
echo -e "${RED}${BOLD}ПРОВЕРЯЙТЕ ПРАВИЛЬНОСТЬ ВВОДА ПАРОЛЯ, ИНАЧЕ ДОСТУП ПО SSH БУДЕТ ЗАБЛОКИРОВАН!${NC}"
echo -e "${RED}${BOLD}ВЫ НЕСЕТЕ ОТВЕТСТВЕННОСТЬ ЗА БЕЗОПАСНОСТЬ!${NC}"
check_host() {
ping -c 1 $CURRENT_IP 2>&1 >> /dev/null

return $?
}
#------------------------------------------------
echo "_____________________________________________"
echo -e -n "${GREEN}${BOLD}Хотите проверить доступ сети к АРМ из файла /etc/hosts? [y/N]: ${NC}"
read hosts_ot
if [ -z $hosts_ot ]; then
    hosts_ot=n
fi
#------------------------------------------------------------
if [ $hosts_ot = "y" ] || [ $hosts_ot = "Y" ]; then

#------------------------------------------------------------
TEMP_IPS=$(mktemp)
grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "/etc/hosts" > "$TEMP_IPS" # Читаем файлик хостс и вытаскиваем только ип Создаем временный файлик и записываем туда айпишники
read -p "Введите имя пользователя ssh (например user): " INPUT_USER
read -p "Введите пароль: " pass_ssh
echo "_____________________________________________"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
else
read -p  "Введите начальный IP(например, 192.168.1.1):" BASE_IP
#-----------------------------------------------
#проверяем есть ли у айпишника разделение через "." 4 позиции
IFS='.' read -r -a ip_parts <<< "$BASE_IP"
if [ ${#ip_parts[@]} -ne 4 ]; then
    echo -e "${RED}${BOLD} ОШИБКА, МИЛОРД: Неверный формат IP-адресса${NC}"
    echo "ВЫ ВВЕЛИ:$ip_parts"
    exit 1
fi 
#-----------------------------------------------
read -p "Введите колличество машин для копирования, которые находятся в одной подсети: " ARM_COUNT
read -p "Введите имя пользователя ssh (например user): " INPUT_USER
read -p "Введите пароль: " pass_ssh
PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}."
START=${ip_parts[3]}
END=$((START+ ARM_COUNT-1))
echo "---------------------------------------------"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
fi
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Проверка ssh               ${NC}"
if [ $(dpkg-query -W -f='${Status}' ssh 2> /dev/null | grep -c "ok installed") -eq 0 ];
then
    sudo apt install ssh -y 2> /dev/null 1> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
else
    echo -e "${GREEN}${BOLD}[ ОК ]${NC}"
fi
sleep 1
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1.2 Проверка sshpass          ${NC}"
if [ $(dpkg-query -W -f='${Status}' sshpass 2> /dev/null | grep -c "ok installed") -eq 0 ];
then
    sudo apt install sshpass -y 2> /dev/null 1> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
else
    echo -e "${GREEN}${BOLD}[ ОК ]${NC}"
fi
sleep 1
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Генерация ключа            ${GREEN}${BOLD}"
if [ -f "/root/.ssh/id_ed25519" ] || [ -f "/root/.ssh/id_ed25519.pub" ]; then
echo -e -n "${YELLOW}${BOLD}[ ПЕРЕГЕНЕРАЦИЯ ]   ${GREEN}${BOLD}"
fi
echo -n "y" | sudo ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519 1> /dev/null 2> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
sleep 2
#---------------------------------------------------------
echo -e "${YELLOW}${BOLD}3. Рассылка ключа             ${NC}"
echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐"
#printf "│ %-33.33s │ %-18.18s │ %-47.47s │" "         АДРЕС АРМ         " "  СТАТУС   " "                  ВЫВОД                     "
printf "│ %-33.33s │ %-18.18s │ %-53.53s │" "АДРЕС АРМ" "СТАТУС" "ВЫВОД РАБОТЫ"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
if [ $hosts_ot = "y" ] || [ $hosts_ot = "Y" ]; then
check_ping() {
	local ip=$1
	ping -c 1 $ip 2>&1 >> /dev/null
    return $?
}
check_base_ip() {
	IFS='.' read -r -a ip_parts <<< "$ip" #Разделяем айпишник на партсы тобишь, первый парт это первые цифры до точки, след партс это следющие цифры до точки и т.д.
}
while read -r ip; do
check_base_ip  #Разделяем айпишник на партсы тобишь, первый парт это первые цифры до точки, след партс это следющие цифры до точки и т.д.
PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}."
CURRENT_IP="${PREFIX}${ip_parts[3]}"
check_host
	ko=$?
	if [ $ko = '0' ]; then
		dostup="Доступен"
			sudo sshpass -p "$pass_ssh" ssh-copy-id -o StrictHostKeyChecking=no $INPUT_USER@$CURRENT_IP 1> /dev/null 2> /dev/null
			if [ $? -eq 0 ]; then
				vivod="Выполнено"
				printf "├%-27.27s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD}│${GREEN}${BOLD} %-51.51s ${YELLOW}${BOLD}│\n"  "$CURRENT_IP" "$dostup" "$vivod"
			else
				vivod="Отказ"
				printf "├%-27.27s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD}│${GREEN}${BOLD} %-47.47s ${YELLOW}${BOLD}│\n"  "$CURRENT_IP" "$dostup" "$vivod"
			fi
	else
			dostup="Недоступен"
			printf "├%-27.27s│ ${RED}${BOLD}%-23.23s${YELLOW}${BOLD}│${RED}${BOLD} %-47.47s ${YELLOW}${BOLD}│\n"  "$CURRENT_IP" "$dostup" "Отказ"
	fi
done < "$TEMP_IPS"
else

for ((i=START;i<=END;i++)); do
    CURRENT_IP="${PREFIX}${i}"
check_host
	ko=$?
	if [ $ko = '0'  ]; then
		dostup="Доступен"
sudo sshpass -p "$pass_ssh" ssh-copy-id -o StrictHostKeyChecking=no $INPUT_USER@$CURRENT_IP 1> /dev/null 2> /dev/null
		if [ $? -eq 0 ]; then
			vivod="Выполнено"
		printf "├%-27.27s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD}│${GREEN}${BOLD} %-51.51s ${YELLOW}${BOLD}│\n"  "$CURRENT_IP" "$dostup" "$vivod"
			else
			vivod="Отказ"
		printf "├%-27.27s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD}│${GREEN}${BOLD} %-47.47s ${YELLOW}${BOLD}│\n"  "$CURRENT_IP" "$dostup" "$vivod"
		fi
			else
			dostup="Недоступен"
			printf "├%-27.27s│ ${RED}${BOLD}%-23.23s${YELLOW}${BOLD}│${RED}${BOLD} %-47.47s ${YELLOW}${BOLD}│\n"  "$CURRENT_IP" "$dostup" "Отказ"
		fi


done
fi
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
sudo apt remove sshpass -y 1> /dev/null 2> /dev/null
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
rem_keyssh(){
clear
echo -e "${GREEN}${BOLD}Удаления ключей SSH для без парольного подключения${NC}"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Удаление ключей ssh       ${NC}"
	sudo rm /root/.ssh/* 2> /dev/null 1> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
unblock_ssh_root(){
clear
echo -e "${GREEN}${BOLD}Разблокировка пользователя ROOT в подключении по ssh${NC}"
ST=`sshd -T | grep -E "permitrootlogin"`
echo -e -n "${YELLOW}${BOLD}Сейчас пользователь root для ssh: ${NC}"
if [ "$ST" = "permitrootlogin yes" ]; then
    echo -e "${RED}${BOLD}[ РАЗРЕШЕН ]${NC}"
    else
    echo -e "${GREEN}${BOLD}[ ЗАКРЫТ ]${NC}"
fi
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD} Разблокировка root           ${NC}"
	sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config  2> /dev/null 1> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
echo -e -n "${YELLOW}${BOLD} Перезагрузка сервиса SSHD    ${NC}"
	sudo systemctl restart sshd 2> /dev/null 1> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
block_ssh_root(){
clear
echo -e "${GREEN}${BOLD}Блокировка пользователя ROOT в подключении по ssh${NC}"
ST=`sshd -T | grep -E "permitrootlogin"`
echo -e -n "${YELLOW}${BOLD}Сейчас пользователь root для ssh: ${NC}"
if [ "$ST" = "permitrootlogin yes" ]; then
    echo -e "${RED}${BOLD}[ РАЗРЕШЕН ]${NC}"
    else
    echo -e "${GREEN}${BOLD}[ ЗАКРЫТ ]${NC}"
fi
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#---------------------------------------------------------
echo -e -n "${YELLOW}${BOLD} Блокировка root              ${NC}"
	sudo sed -i 's/^#*PermitRootLogin.*/#PermitRootLogin prohibit-password/' /etc/ssh/sshd_config  2> /dev/null 1> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
echo -e -n "${YELLOW}${BOLD} Перезагрузка сервиса SSHD    ${NC}"
	sudo systemctl restart sshd 2> /dev/null 1> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
install_ssh(){
	clear
	echo -e "${GREEN}${BOLD}Установка ssh${NC}"
	echo -e -n "${GREEN}${BOLD}Ожидайте...${NC}"
	sudo apt install ssh -y 2> /dev/null 1> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	sleep 5
	show_menu3
}
rem_ssh(){
	clear
	echo -e "${RED}${BOLD}Удаление ssh${NC}"
	echo -e -n "${GREEN}${BOLD}Ожидайте...${NC}"
	sudo apt purge ssh -y 2> /dev/null 1> /dev/null
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	sleep 5
	show_menu3
}
#===========================================================================
#							КОНЕЦ РАЗДЕЛА SSH
#===========================================================================

#===========================================================================
#Проверка связи с АРМ в локальной сети с удобным выводом
#===========================================================================
ping_arm() {
clear
LOG_FILE="ping_log$(date +%d-%m-%Y).log"
DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
echo "Start time :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
#------------------------------------------------------------
echo -e "┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐" >> $LOG_FILE 
printf "│ %-33.33s │ %-18.18s │ %-47.47s │" "АДРЕС АРМ" "СТАТУС" "ВЫВОД" >> $LOG_FILE
echo "" >> $LOG_FILE
echo -e "├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤" >> $LOG_FILE

echo -e "${GREEN}${BOLD}Проверка связи с АРМ ${NC}"
echo ""
echo -e -n "${GREEN}${BOLD}Хотите проверить доступ сети к АРМ из файла /etc/hosts? [y/N]: ${NC}"
read hosts_ot
if [ -z $hosts_ot ]; then
    hosts_ot=n
fi
#------------------------------------------------------------
if [ $hosts_ot = "y" ] || [ $hosts_ot = "Y" ]; then

#------------------------------------------------------------
TEMP_IPS=$(mktemp)
grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "/etc/hosts" > "$TEMP_IPS" # Читаем файлик хостс и вытаскиваем только ип Создаем временный файлик и записываем туда айпишники
#------------------------------------------------------------
check_ping() {
	local ip=$1
	ping -c 1 $ip 2>&1 >> /dev/null
    return $?
}
check_base_ip() {
	IFS='.' read -r -a ip_parts <<< "$ip" #Разделяем айпишник на партсы тобишь, первый парт это первые цифры до точки, след партс это следющие цифры до точки и т.д.
}
check_host(){
ping -c 1 $CURRENT_IP 2> /dev/null 1> /dev/null
return $?
}
#------------------------------------------------------------
echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐" 
#printf "│ %-33.33s │ %-18.18s │ %-47.47s │" "         АДРЕС АРМ         " "  СТАТУС   " "                  ВЫВОД                     "
printf "│ %-33.33s │ %-18.18s │ %-47.47s │" "АДРЕС АРМ" "СТАТУС" "ВЫВОД"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
	while read -r ip; do
check_base_ip  #Разделяем айпишник на партсы тобишь, первый парт это первые цифры до точки, след партс это следющие цифры до точки и т.д.
PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}."
CURRENT_IP="${PREFIX}${ip_parts[3]}"
check_host
ko=$?
	if [ $ko = '0'  ]; then
		printf "├%-27.27s│ ${GREEN}${BOLD}%-20.20s${YELLOW}${BOLD} │${GREEN}${BOLD} %-65.65s ${YELLOW}${BOLD}│\n"  "$CURRENT_IP" "Доступен" "Связь с АРМ есть, виден в сети"
		printf "├%-27.27s│ %-20.20s │ %-65.65s │\n"  "$CURRENT_IP" "Доступен" "Связь с АРМ есть, виден в сети" >> $LOG_FILE
		else
		printf "├%-27.27s│ ${RED}${BOLD}%-23.23s${YELLOW}${BOLD}│${RED}${BOLD} %-72.72s${YELLOW}${BOLD}│\n"  "$CURRENT_IP" "Недоступен" "АРМ выключен или отсутствует сеть"
		printf "├%-27.27s│ %-23.23s│ %-72.72s│\n"  "$CURRENT_IP" "Недоступен" "АРМ выключен или отсутствует сеть" >> $LOG_FILE
		fi
done < "$TEMP_IPS"
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
echo -e "└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘" >> $LOG_FILE
rm $TEMP_IPS
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
#----------------------------------------------------------------------------------------------------------
	else

    echo -e -n "${GREEN}${BOLD}Введите начальный IP(Например, 192.168.1.1): ${YELLOW}${BOLD}" 
    read BASE_IP
    echo -e -n "${GREEN}${BOLD}Введите количество машин которые находятся в одной подсети ${YELLOW}${BOLD}" 
    read ARM_COUNT
    echo -e "${NC}"
check_base_ip() {
IFS='.' read -r -a ip_parts <<< "$BASE_IP"
if [ ${#ip_parts[@]} -ne 4 ]; then
echo -e "${RED}${BOLD} ОШИБКА, МИЛОРД: Неверный формат IP-адресса${NC}"
echo "ВЫ ВВЕЛИ:$ip_parts"
exit 1
fi
}
#------------------------------------------------H
check_host(){
ping -c 1 $CURRENT_IP 2> /dev/null 1> /dev/null
return $?
}
#-------------------------------------------------
check_base_ip
PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}."
START=${ip_parts[3]}
END=$((START+ ARM_COUNT-1))
echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐"
#printf "│ %-33.33s │ %-18.18s │ %-47.47s │" "         АДРЕС АРМ         " "  СТАТУС   " "                  ВЫВОД                     "
printf "│ %-33.33s │ %-18.18s │ %-47.47s │" "АДРЕС АРМ" "СТАТУС" "ВЫВОД"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
for ((i=START;i<=END;i++)); do
    CURRENT_IP="${PREFIX}${i}"

check_host
	ko=$?
	if [ $ko = '0'  ]; then
		printf "├%-27.27s│ ${GREEN}${BOLD}%-20.20s${YELLOW}${BOLD} │${GREEN}${BOLD} %-65.65s ${YELLOW}${BOLD}│\n"  "$CURRENT_IP" "Доступен" "Связь с АРМ есть, виден в сети"
		printf "├%-27.27s│ %-20.20s │ %-65.65s │\n"  "$CURRENT_IP" "Доступен" "Связь с АРМ есть, виден в сети" >> $LOG_FILE
		else
		printf "├%-27.27s│ ${RED}${BOLD}%-23.23s${YELLOW}${BOLD}│${RED}${BOLD} %-72.72s${YELLOW}${BOLD}│\n"  "$CURRENT_IP" "Недоступен" "АРМ выключен или отсутствует сеть"
		printf "├%-27.27s│ %-23.23s│ %-72.72s│\n"  "$CURRENT_IP" "Недоступен" "АРМ выключен или отсутствует сеть" >> $LOG_FILE
		fi
done
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
echo -e "└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘" >> $LOG_FILE
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r

show_menu
fi
}

#===========================================================================
#							НАЧАЛО РАЗДЕЛА JACARTA
#===========================================================================
#admin_jacarta			|		Установка Администратора jacarta
#user_jacarta			|		Установка Агентов jacarta
#remove_jacarta			|		Удаление jacarta
#server_jacarta			|		Установка и настройка сервера jacarta
#===========================================================================
admin_jacarta(){
clear

	LOG_FILE="jacarta_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка администратора jacarta :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE

echo -e "${GREEN}${BOLD}Установка admin jacarta${NC}"
echo -e "${GREEN}${BOLD}Подробные логи установки, находятся в тойже директории что и скрипт.${NC}"
echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐"
printf "│ %-31.31s │ %-18.18s │ %-47.47s │" "Задача" "Статус" "Вывод"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
#---------------------------------------------------------------------------------------------------------------pcscd
if [ $(dpkg-query -W -f='${Status}' pcscd 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
    apt install pcscd -y 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-66.66s ${YELLOW}${BOLD} │\n"  "1. Установка pcscd libccid" "Выполнена" "Пакет был успешно установлен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-56.56s${YELLOW}${BOLD}│\n"  "1. Установка pcscd libccid" "Невыполнена" "Пакет не найдет"
	fi
else
		printf "├%-36.36s│ ${YELLOW}${BOLD}%-24.24s${YELLOW}${BOLD}│${GREEN}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "1. Установка pcscd libccid" "Невыполнена" "Пакет уже установлен"
fi
#---------------------------------------------------------------------------------------------------------------
if [ $(dpkg-query -W -f='${Status}' "libjckt*"  2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
    dpkg -i libjckt*.deb  1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-66.66s ${YELLOW}${BOLD} │\n"  "2. Установка libjckt*" "Выполнена" "Пакет был успешно установлен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-56.56s${YELLOW}${BOLD}│\n"  "2. Установка libjckt*" "Невыполнена" "Пакет не найдет"
	fi
else
		printf "├%-36.36s│ ${YELLOW}${BOLD}%-24.24s${YELLOW}${BOLD}│${GREEN}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "2. Установка libjctk*" "Невыполнена" "Пакет уже установлен"
fi
#----------------------------------------------------------------------------------------------------------------
if [ $(dpkg-query -W -f='${Status}' "jcsfadmin*"  2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
    dpkg -i jcsfadmin*.deb  1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-66.66s ${YELLOW}${BOLD} │\n"  "3. Установка jcsfadmin" "Выполнена" "Пакет был успешно установлен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-56.56s${YELLOW}${BOLD}│\n"  "3. Установка jcsfadmin" "Невыполнена" "Пакет не найдет"
	fi
else
		printf "├%-36.36s│ ${YELLOW}${BOLD}%-24.24s${YELLOW}${BOLD}│${GREEN}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "3. Установка jcsfadmin" "Невыполнена" "Пакет уже установлен"
fi
#----------------------------------------------------------------------------------------------------------------
if [ $(dpkg-query -W -f='${Status}' "jcsfkeyadmin*"  2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
    dpkg -i jcsfkeyadmin*.deb  1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-66.66s ${YELLOW}${BOLD} │\n"  "4. Установка jcsfkeyadmin" "Выполнена" "Пакет был успешно установлен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-56.56s${YELLOW}${BOLD}│\n"  "4. Установка jcsfkeyadmin" "Невыполнена" "Пакет не найдет"
	fi
else
		printf "├%-36.36s│ ${YELLOW}${BOLD}%-24.24s${YELLOW}${BOLD}│${GREEN}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "4. Установка jcsfkeyadmin" "Невыполнена" "Пакет уже установлен"
fi
#----------------------------------------------------------------------------------------------------------------
if [ $(dpkg-query -W -f='${Status}' "jcsfdiag"  2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
    dpkg -i jcsfdiag*.deb  1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-66.66s ${YELLOW}${BOLD} │\n"  "5. Установка jcsfdiag" "Выполнена" "Пакет был успешно установлен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-56.56s${YELLOW}${BOLD}│\n"  "5. Установка jcsfdiag" "Невыполнена" "Пакет не найдет"
	fi
else
		printf "├%-36.36s│ ${YELLOW}${BOLD}%-24.24s${YELLOW}${BOLD}│${GREEN}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "5. Установка jcsfdiag" "Невыполнена" "Пакет уже установлен"
fi
#----------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------
if [ $(dpkg-query -W -f='${Status}' "jcsfserverd*"  2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
    dpkg -i jcsfserverd*.deb  1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-66.66s ${YELLOW}${BOLD} │\n"  "6. Установка jcsfserverd" "Выполнена" "Пакет был успешно установлен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-56.56s${YELLOW}${BOLD}│\n"  "6. Установка jcsfserverd" "Невыполнена" "Пакет не найдет"
	fi
else
		printf "├%-36.36s│ ${YELLOW}${BOLD}%-24.24s${YELLOW}${BOLD}│${GREEN}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "6. Установка jcsfserverd" "Невыполнена" "Пакет уже установлен"
fi
#----------------------------------------------------------------------------------------------------------------

if [ $(dpkg-query -W -f='${Status}' "jcsfuser*"  2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
    dpkg -i jcsfuser*.deb  1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-66.66s ${YELLOW}${BOLD} │\n"  "7. Установка jcsfuser" "Выполнена" "Пакет был успешно установлен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-56.56s${YELLOW}${BOLD}│\n"  "7. Установка jcsfuser" "Невыполнена" "Пакет не найдет"
	fi
else
		printf "├%-36.36s│ ${YELLOW}${BOLD}%-24.24s${YELLOW}${BOLD}│${GREEN}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "7. Установка jcsfuser" "Невыполнена" "Пакет уже установлен"
fi
#----------------------------------------------------------------------------------------------------------------
printf "[Unit]
Discription=PC/SC Smart Card Daemon
##Requires=pcscd.socket

[Service]
ExecStart=/usr/sbin/pcscd --foreground
ExecReload=/usr/sbin/pcscd --hotplug
CapabilitiesParsec=PARSEC_CAP_PRIV_SOCK

[Install]
WantedBy=multi-user.target
##Also=pcscd.socket" > /lib/systemd/system/pcscd.service
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-47.47s ${YELLOW}${BOLD}│\n"  "8. Настройка pcscd.service" "Выполнена" "Убран --auto-exit"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-47.47s${YELLOW}${BOLD}│\n"  "8. Настройка pcscd.service" "Невыполнена" "Сервиса не существует"
	fi
#----------------------------------------------------------------------------------------------------------------
sudo systemctl daemon-reload 2>> $LOG_FILE
sudo systemctl disable pcscd.socket 2>> $LOG_FILE
sudo systemctl restart pcscd.service 2>> $LOG_FILE

sudo systemctl daemon-reload 2>> $LOG_FILE
sudo systemctl restart pcscd.service 2>> $LOG_FILE
sudo systemctl enable pcscd.service  2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-37.37s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-51.47s ${YELLOW}${BOLD}│\n"  "9. Перезапуск pcscd.service" "Выполнена" "Выполнены daemon,disable,restart,enable"
	else
		printf "├%-37.37s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-51.47s${YELLOW}${BOLD}│\n"  "9. Перезапуск pcscd.service" "Невыполнена" "Сервиса не существует"
	fi
#----------------------------------------------------------------------------------------------------------------
echo "/usr/sbin/pcscd
/opt/JaCartaSFGOSTSuite/jcsfserverd" >> /etc/parsec/privsock.conf
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-74.74s ${YELLOW}${BOLD}│\n"  "10.Настройка Parsec" "Выполнена" "Запускать сервиса в ненулевой сессии"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-74.74s${YELLOW}${BOLD}│\n"  "10.Настройка Parsec" "Невыполнена" "Нет прав"
	fi
#----------------------------------------------------------------------------------------------------------------
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
printf "│%-28.28s %-68.68s %-15.15s│"  "" "Будет выполнена Перезагрузка? [Y/n] : " "" ; read reb_otv
if [ -z $reb_otv ]; then
    reb_otv=y
fi
#------------------------------------------------------------
if [ $reb_otv = "y" ] || [ $reb_otv = "Y" ]; then
printf "│%-28.28s ${RED}${BOLD}%-68.68s${NC} %-1.1s${YELLOW}${BOLD}│\n"  "" "            ПЕРЕЗАГРУЗКА" ""
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
sleep 5
reboot
else
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
fi
}
#===========================================================================
user_jacarta(){
clear

	LOG_FILE="jacarta_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка пользователя jacarta :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE

echo -e "${GREEN}${BOLD}Установка user jacarta${NC}"
echo -e "${GREEN}${BOLD}Подробные логи установки, находятся в тойже директории что и скрипт.${NC}"
echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐"
printf "│ %-31.31s │ %-18.18s │ %-47.47s │" "Задача" "Статус" "Вывод"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
#---------------------------------------------------------------------------------------------------------------pcscd
if [ $(dpkg-query -W -f='${Status}' pcscd 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
    apt install pcscd -y 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-66.66s ${YELLOW}${BOLD} │\n"  "1. Установка pcscd libccid" "Выполнена" "Пакет был успешно установлен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-56.56s${YELLOW}${BOLD}│\n"  "1. Установка pcscd libccid" "Невыполнена" "Пакет не найдет"
	fi
else
		printf "├%-36.36s│ ${YELLOW}${BOLD}%-24.24s${YELLOW}${BOLD}│${GREEN}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "1. Установка pcscd libccid" "Невыполнена" "Пакет уже установлен"
fi
#---------------------------------------------------------------------------------------------------------------
if [ $(dpkg-query -W -f='${Status}' "libjckt*"  2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
    dpkg -i libjckt*.deb  1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-66.66s ${YELLOW}${BOLD} │\n"  "2. Установка libjckt*" "Выполнена" "Пакет был успешно установлен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-56.56s${YELLOW}${BOLD}│\n"  "2. Установка libjckt*" "Невыполнена" "Пакет не найдет"
	fi
else
		printf "├%-36.36s│ ${YELLOW}${BOLD}%-24.24s${YELLOW}${BOLD}│${GREEN}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "2. Установка libjctk*" "Невыполнена" "Пакет уже установлен"
fi

#----------------------------------------------------------------------------------------------------------------

if [ $(dpkg-query -W -f='${Status}' "jcsfuser*"  2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
    dpkg -i jcsfuser*.deb  1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-66.66s ${YELLOW}${BOLD} │\n"  "3. Установка jcsfuser" "Выполнена" "Пакет был успешно установлен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-56.56s${YELLOW}${BOLD}│\n"  "3. Установка jcsfuser" "Невыполнена" "Пакет не найдет"
	fi
else
		printf "├%-36.36s│ ${YELLOW}${BOLD}%-24.24s${YELLOW}${BOLD}│${GREEN}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "3. Установка jcsfuser" "Невыполнена" "Пакет уже установлен"
fi
#----------------------------------------------------------------------------------------------------------------
printf "[Unit]
Discription=PC/SC Smart Card Daemon
##Requires=pcscd.socket

[Service]
ExecStart=/usr/sbin/pcscd --foreground
ExecReload=/usr/sbin/pcscd --hotplug
CapabilitiesParsec=PARSEC_CAP_PRIV_SOCK

[Install]
WantedBy=multi-user.target
##Also=pcscd.socket" > /lib/systemd/system/pcscd.service
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-47.47s ${YELLOW}${BOLD}│\n"  "4. Настройка pcscd.service" "Выполнена" "Убран --auto-exit"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-47.47s${YELLOW}${BOLD}│\n"  "4. Настройка pcscd.service" "Невыполнена" "Сервиса не существует"
	fi
#----------------------------------------------------------------------------------------------------------------
sudo systemctl daemon-reload 2>> $LOG_FILE
sudo systemctl disable pcscd.socket 2>> $LOG_FILE
sudo systemctl restart pcscd.service 2>> $LOG_FILE

sudo systemctl daemon-reload 2>> $LOG_FILE
sudo systemctl restart pcscd.service 2>> $LOG_FILE
sudo systemctl enable pcscd.service  2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-37.37s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-51.47s ${YELLOW}${BOLD}│\n"  "5. Перезапуск pcscd.service" "Выполнена" "Выполнены daemon,disable,restart,enable"
	else
		printf "├%-37.37s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-51.47s${YELLOW}${BOLD}│\n"  "5. Перезапуск pcscd.service" "Невыполнена" "Сервиса не существует"
	fi
#----------------------------------------------------------------------------------------------------------------
echo "/usr/sbin/pcscd
/opt/JaCartaSFGOSTSuite/jcsfserverd" >> /etc/parsec/privsock.conf
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-73.73s ${YELLOW}${BOLD}│\n"  "6. Настройка Parsec" "Выполнена" "Запускать сервис в ненулевой сессии"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-74.74s${YELLOW}${BOLD}│\n"  "6. Настройка Parsec" "Невыполнена" "Нет прав"
	fi
#----------------------------------------------------------------------------------------------------------------
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
printf "│%-28.28s %-68.68s %-15.15s│"  "" "Будет выполнена Перезагрузка? [Y/n] : " "" ; read reb_otv
if [ -z $reb_otv ]; then
    reb_otv=y
fi
#------------------------------------------------------------
if [ $reb_otv = "y" ] || [ $reb_otv = "Y" ]; then
printf "│%-28.28s ${RED}${BOLD}%-68.68s${NC} %-1.1s${YELLOW}${BOLD}│\n"  "" "            ПЕРЕЗАГРУЗКА" ""
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
sleep 5
reboot
else
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
fi
}
#===========================================================================
remove_jacarta(){
clear
echo -e "${GREEN}${BOLD}Удаление jacarta${NC}"
echo -e "${GREEN}${BOLD}Удаление jcsfadmin jcsfkeyadmin jcsfserverd jcsfdiag jcsfuser pcscd${NC}"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
apt --purge remove -y jcsfadmin  2> /dev/null 1> /dev/null
apt --purge remove -y jcsfkeyadmin  2> /dev/null 1> /dev/null
apt --purge remove -y jcsfserverd  2> /dev/null 1> /dev/null
apt --purge remove -y jcsfdiag 2> /dev/null 1> /dev/null
apt --purge remove -y jcsfuser 2> /dev/null 1> /dev/null
apt --purge remove -y pcscd 2> /dev/null 1> /dev/null
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
server_jacarta(){
clear

	LOG_FILE="jacarta_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Настройка сервера jacarta :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
echo -e "${GREEN}${BOLD}Настройки сервера jacarta${NC}"
echo -e "${RED}${BOLD}Внимание! Перед настройкой сервера Jacarta, разместите контейнер формата [.kka]${NC}"
echo -e "${RED}${BOLD}В одной директории с скриптом,  ${NC}"
if [ -f *.kka ]; then
echo -e "${YELLOW}${BOLD}Укажите пароль от контейнера: "
read pass_contain
echo -e "${YELLOW}${BOLD}Укажите подсеть пример [192.168.1.0]: "
read podset
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
sleep 2
echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐"
printf "│ %-31.31s │ %-18.18s │ %-47.47s │" "Задача" "Статус" "Вывод"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
#---------------------------------------------------------------------------------------------------------------pcscd

	/opt/JaCartaSFGOSTSuite/jcsfserverd 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-33.33s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-48.48s ${YELLOW}${BOLD} │\n"  "1. Запуск jcsfserverd" "Выполнено" "Запущен"
		sleep 1
		/opt/JaCartaSFGOSTSuite/jcsfserverd
		sleep 1
	else
		printf "├%-33.33s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "1. Запуск jcsfserverd" "Невыполнено" "Неудалось запустить"
	fi
#---------------------------------------------------------------------------------------------------------------

    cp *.kka /usr/share/jcsfgost/containers 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-44.44s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-65.65s ${YELLOW}${BOLD} │\n"  "2. Копируем контейнер" "Выполнено" "Копирование прошло успешно"
	else
		printf "├%-44.44s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "2. Копируем контейнер" "Невыполнено" "Файл не найден или не хватает прав"
	fi
#----------------------------------------------------------------------------------------------------------------
	for file in *.kka; do
	name_containers="${file%.*}"
	done 1>> $LOG_FILE 2>> $LOG_FILE
	if [ -f /usr/share/jcsfgost/containers/*.kka ]; then
	echo "$name_containers=$pass_contain" >> /usr/share/jcsfgost/containers/containers.set
	fi
	chmod go-r /usr/share/jcsfgost/containers/containers.set 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-53.53s ${YELLOW}${BOLD} │\n"  "3. Настройка containers.set" "Выполнено" "Файл настроен"
	else
		printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "3. Настройка containers.set" "Невыполнено" "Не создан, отсутствует контейнер"
	fi
#----------------------------------------------------------------------------------------------------------------
	if [ -f /etc/jcsfgost/jcsfserverd/jcsfserverd.cfg ]; then
	sudo sed -i 's/^#*type=local.*/#type=local/' /etc/jcsfgost/jcsfserverd/jcsfserverd.cfg
	if [ $? -eq 0 ]; then
		printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-65.65s ${YELLOW}${BOLD}│\n"  "4. Настройка jcsfserverd.cfg" "Выполнено" "Строчка type=local закомментирована"
	else
	printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "4. Настройка jcsfserverd.cfg" "Невыполнено" "Файл не найден или не хватает прав"
	fi
	else
	printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "4. Настройка jcsfserverd.cfg" "Невыполнено" "Файл не найден или не хватает прав"
	fi
#----------------------------------------------------------------------------------------------------------------
	numberstr=5
	if [ -f /usr/share/jcsfgost/containers/jcsfssets.xml ]; then
	printf "├%-39.39s│ ${GREEN}${BOLD}%-23.23s${YELLOW}${BOLD} │${GREEN}${BOLD} %-63.63s ${YELLOW}${BOLD} │\n"  "5. Формирование jcsfssets.xml" "Выполняется" "Добавьте ip-adress разрешенных АРМ"
sed -i '/<\/whitelist>/d' /usr/share/jcsfgost/containers/jcsfssets.xml
IP=$podset
while [ 1 ]
do
KKK=`/usr/bin/fly-dialog --inputbox "Введите следующий адрес" $IP`
if [ "$KKK" = "" ]; then
    break
fi
((numberstr++))
printf "├%-27.27s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-63.63s ${YELLOW}${BOLD}│\n"  "$numberstr. $KKK" "Выполнено" "IP адресс добавлен в список"
echo '    <subnet netaddress="'$KKK'" mask="'255.255.255.0'"/>' >> /usr/share/jcsfgost/containers/jcsfssets.xml
IP=$KKK
done
echo "</whitelist>" >> /usr/share/jcsfgost/containers/jcsfssets.xml
else
printf "├%-39.39s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "5. Формирование jcsfssets.xml" "Невыполнено" "Файл не найден или не хватает прав"
fi
((numberstr++))
#----------------------------------------------------------------------------------------------------------------
sudo systemctl daemon-reload 1>> $LOG_FILE 2>> $LOG_FILE
sudo systemctl disable pcscd.socket 1>> $LOG_FILE 2>> $LOG_FILE
sudo systemctl restart pcscd.service 1>> $LOG_FILE 2>> $LOG_FILE

sudo systemctl daemon-reload 1>> $LOG_FILE 2>> $LOG_FILE
sudo systemctl restart pcscd.service 1>> $LOG_FILE 2>> $LOG_FILE
sudo systemctl enable pcscd.service  1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
		printf "├%-37.37s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-51.51s ${YELLOW}${BOLD}│\n"  "$numberstr. Перезапуск pcscd.service" "Выполнено" "Выполнены daemon,disable,restart,enable"
	else
		printf "├%-37.37s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-62.62s${YELLOW}${BOLD}│\n"  "$numberstr. Перезапуск pcscd.service" "Невыполнено" "Сервиса не существует"
	fi
#----------------------------------------------------------------------------------------------------------------
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
printf "│%-28.28s %-68.68s %-15.15s│"  "" "Будет выполнена Перезагрузка? [Y/n] : " "" ; read reb_otv
if [ -z $reb_otv ]; then
    reb_otv=y
fi
#------------------------------------------------------------
if [ $reb_otv = "y" ] || [ $reb_otv = "Y" ]; then
printf "│%-28.28s ${RED}${BOLD}%-68.68s${NC} %-1.1s${YELLOW}${BOLD}│\n"  "" "            ПЕРЕЗАГРУЗКА" ""
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
sleep 5
reboot
else
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
fi
else
echo -e "${YELLOW}${BOLD}Контейнер формата [.kka]:${RED}${BOLD} ОТСУТСВУЕТ ${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
fi
}
#===========================================================================
#							КОНЕЦ РАЗДЕЛА JACARTA
#===========================================================================

#===========================================================================
#Исправление ошибки агента при работе в 3 сессии
#===========================================================================
errordrweb_sesion(){
clear
echo -e "${GREEN}${BOLD}DrWeb - исправления${NC}"
echo -e "${GREEN}${BOLD}Если агент DrWeb не работает в несекретной сессии, то данный скрипт поможет исправить это!${NC}"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
if [ -f /etc/jcsfgost/jcsfserverd/jcsfserverd.cfg ]; then
	sudo sed -i 's/^#*type=local.*/#type=local/' /etc/jcsfgost/jcsfserverd/jcsfserverd.c
fi
}

#===========================================================================
#							НАЧАЛО РАЗДЕЛА DOMAIN
#===========================================================================
#install_ald_S			|		Установка сервера ALD
#remove_ald				|		Удаление ALD
#install_ald_C			|		Установка агента ALD
#install_ald_R			|		Установка резерва ALD
#remove_fipa			|		Удаление FreeIPA
#install_fipa_S			|		Установка сервера FreeIPA
#install_fipa_C			|		Установка клиента FreeIPA
#===========================================================================
#								ALD/LDAP-DOMAIN
#===========================================================================
install_ald_S(){
clear
export DEBIAN_FRONTEND=noninteractive
	LOG_FILE="ald_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка ALD-DOMAIN-SEVRER :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname`

echo -e "${GREEN}${BOLD}Установка Сервера Домена ALD${NC}"
echo -e "${RED}${BOLD}Внимание! Перед установкой убедитесь, что сеть и файл hosts настроены правильно.${NC}"
echo -e "${YELLOW}${BOLD}Укажите имя домена, в виде (my.domain)"
read domain_name
echo -e "${YELLOW}${BOLD}Укажите пароль администратора для LDAP"
read pass_ldap
echo -e "${YELLOW}${BOLD}Укажите пароль администратора для kerberos"
read pass_krbs
echo "K/M:$pass_krbs" >> /tmp/pass
echo -e "${YELLOW}${BOLD}Укажите пароль администратора для ald"
read pass_ald
echo "admin/admin:$pass_ald" >> /tmp/pass
chmod 0600 /tmp/pass

read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
echo -e "${RED}${BOLD}Возможны ошибки, до появления таблицы."
echo -e "${RED}${BOLD}Все в порядке это sssd шалит."
apt install sssd -y 1>> $LOG_FILE 2>> $LOG_FILE
sleep 2
clear
echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐"
printf "│ %-31.31s │ %-18.18s │ %-47.47s │" "Задача" "Статус" "Вывод"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
#-------------------------------------------------------------------------------------

apt install fly-admin-ald-server -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "1. fly-admin-ald-server" "Установлен" "Пакет был установлен"
	else
	printf "├%-27.27s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "1. fly-admin-ald-server" "Ошибка" "Не возможно установить пакет"
fi

#-------------------------------------------------------------------------------------

if [ $(dpkg-query -W -f='${Status}' ald-server-common 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
expect -c 1>> $LOG_FILE 2>> $LOG_FILE "
spawn sudo apt install ald-server -y
sleep 4
expect \"Пароль администратора: \"
send \"$pass_ldap\r\"
sleep 4
expect \"Повторите ввод пароля: \"
send \"$pass_ldap\r\"
expect \"Повторите ввоfд пароля: \"
send \"\r\"
expect eof"
if [ $? -eq 0 ]; then
		printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "2. ald-server-common" "Установлен" "Пакет был установлен"
	else
	printf "├%-27.27s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "2. ald-server-common" "Ошибка" "Не возможно установить пакет"
	fi
else
		printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "2. ald-server-common" "Установлен" "Пакет был установлен"
fi

#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
if [ -f /etc/ald/ald.conf ]

        then
        printf "├%-35.35s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-53.53s ${YELLOW}${BOLD}│\n"  "3. Проверка ald.conf" "Выполнено" "Файл имеется"
        else
        aldd
		printf "├%-35.35s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-53.53s ${YELLOW}${BOLD}│\n"  "3. Проверка ald.conf" "Выполнено" "Файл был сгенерирован"
fi
#-------------------------------------------------------------------------------------
sed -i "s/.*SERVER_ON=.*/SERVER_ON=1/g" /etc/ald/ald.conf
sed -i "s/.*CLIENT_ON=.*/CLIENT_ON=1/g" /etc/ald/ald.conf
sed -i "s/.*DOMAIN=.*/DOMAIN=.$domain_name/g" /etc/ald/ald.conf
sed -i "s/.*SERVER=.*/SERVER=$name_arm.$domain_name/g" /etc/ald/ald.conf
sed -i "s/.*NETWORK_FS_TYPE=.*/NETWORK_FS_TYPE=none/g" /etc/ald/ald.conf
if [ $? -eq 0 ]; then
	printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-63.63s ${YELLOW}${BOLD}│\n"  "4. Настройка ald.conf" "Выполнено" "Конфигурация настроена"
	else
	printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "4. Настройка ald.conf" "Ошибка" "Не возможно отредактировать файл"
fi
#-------------------------------------------------------------------------------------

ald-init init -f --pass-file=/tmp/pass 1>> $LOG_FILE 2>> $LOG_FILE
sudo rm /tmp/pass 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	printf "├%-40.40s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-68.68s ${YELLOW}${BOLD}│\n"  "5. Инициализация" "Выполнено" "Инициализация прошла успешно"
	else
	printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "5. Инициализация" "Ошибка" "Не возможно инициализациировать"
fi
#-------------------------------------------------------------------------------------
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
#-------------------------------------------------------------------------------------
ald-client -t | grep "Сервер ALD"
ald-client -t | grep "Клиент ALD"
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
remove_ald(){
	export DEBIAN_FRONTEND=noninteractive
echo -e "${RED}${BOLD}Удаление ald-домена"
sleep 2
apt autoremove --purge ald-server ald-server-common fly-admin-ald-server ald-client ald-client-common sssd krb5-user -y
echo -e "${RED}${BOLD}Удаление завершено${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
install_ald_C(){
clear
export DEBIAN_FRONTEND=noninteractive
	LOG_FILE="ald_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка ALD-DOMAIN-SEVRER :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname`

echo -e "${GREEN}${BOLD}Установка Клиента Домена ALD${NC}"
echo -e "${RED}${BOLD}Внимание! Перед установкой убедитесь, что сеть и файл hosts настроены правильно.${NC}"

echo -e "${YELLOW}${BOLD}Укажите имя АРМ контролера домена, в виде (arm01)"
read control_arm

echo -e "${YELLOW}${BOLD}Укажите имя домена, в виде (my.domain)"
read domain_name

echo -e "${YELLOW}${BOLD}Укажите пароль администратора домена"
read pass_a_ald

echo "admin/admin:$pass_a_ald" >> /tmp/pass
chmod 0600 /tmp/pass

read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
echo -e "${RED}${BOLD}Возможны ошибки, до появления таблицы."
echo -e "${RED}${BOLD}Все в порядке это sssd шалит."
apt install sssd -y 1>> $LOG_FILE 2>> $LOG_FILE
sleep 2
clear

echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐"
printf "│ %-31.31s │ %-18.18s │ %-47.47s │" "Задача" "Статус" "Вывод"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
#-------------------------------------------------------------------------------------
apt install ald-client-common -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "1. ald-client-common" "Установлен" "Пакет был установлен"
	else
	printf "├%-27.27s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "1. ald-client-common" "Ошибка" "Не возможно установить пакет"
fi
#-------------------------------------------------------------------------------------
apt install fly-admin-ald-client -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "2. fly-admin-ald-client" "Установлен" "Пакет был установлен"
	else
	printf "├%-27.27s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "2. fly-admin-ald-client" "Ошибка" "Не возможно установить пакет"
fi
#-------------------------------------------------------------------------------------
sed -i "s/.*SERVER_ON=.*/SERVER_ON=0/g" /etc/ald/ald.conf
if [ $? -eq 0 ]; then
	printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-63.63s ${YELLOW}${BOLD}│\n"  "3. Настройка ald.conf" "Выполнено" "Конфигурация настроена"
	else
	printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "3. Настройка ald.conf" "Ошибка" "Не возможно отредактировать файл"
fi
#-------------------------------------------------------------------------------------
ald-client join -f -v --pass-file=/tmp/pass $control_arm.$domain_name 1>> $LOG_FILE 2>> $LOG_FILE
sudo rm /tmp/pass 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	printf "├%-40.40s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-68.68s ${YELLOW}${BOLD}│\n"  "4. Инициализация" "Выполнено" "Инициализация прошла успешно"
	else
	printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "4. Инициализация" "Ошибка" "Не возможно инициализациировать"
fi
#-------------------------------------------------------------------------------------
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
#-------------------------------------------------------------------------------------
ald-client -t | grep "Клиент ALD"
#-------------------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
install_ald_R(){
clear
export DEBIAN_FRONTEND=noninteractive
	LOG_FILE="ald_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка ALD-DOMAIN-SEVRER :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname`

echo -e "${GREEN}${BOLD}Установка Сервера Домена ALD${NC}"
echo -e "${RED}${BOLD}Внимание! Перед установкой убедитесь, что сеть и файл hosts настроены правильно.${NC}"
echo -e "${YELLOW}${BOLD}Укажите имя АРМ контролера домена, в виде (arm01)"
read control_arm
echo -e "${YELLOW}${BOLD}Укажите имя домена, в виде (my.domain)"
read domain_name
echo -e "${YELLOW}${BOLD}Укажите пароль администратора для LDAP"
read pass_ldap
echo -e "${YELLOW}${BOLD}Укажите пароль администратора для kerberos"
read pass_krbs
echo "K/M:$pass_krbs" >> /tmp/pass
echo -e "${YELLOW}${BOLD}Укажите пароль администратора для ald"
read pass_ald
echo "admin/admin:$pass_ald" >> /tmp/pass
chmod 0600 /tmp/pass

read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
echo -e "${RED}${BOLD}Возможны ошибки, до появления таблицы."
echo -e "${RED}${BOLD}Все в порядке это sssd шалит."
apt install sssd -y 1>> $LOG_FILE 2>> $LOG_FILE
sleep 2
clear
echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐"
printf "│ %-31.31s │ %-18.18s │ %-47.47s │" "Задача" "Статус" "Вывод"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
#-------------------------------------------------------------------------------------
apt install fly-admin-ald-server -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "1. fly-admin-ald-server" "Установлен" "Пакет был установлен"
	else
	printf "├%-27.27s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "1. fly-admin-ald-server" "Ошибка" "Не возможно установить пакет"
fi

#-------------------------------------------------------------------------------------

if [ $(dpkg-query -W -f='${Status}' ald-server-common 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
expect -c 1>> $LOG_FILE 2>> $LOG_FILE "
spawn sudo apt install ald-server -y
sleep 4
expect \"Пароль администратора: \"
send \"$pass_ldap\r\"
sleep 4
expect \"Повторите ввод пароля: \"
send \"$pass_ldap\r\"
expect \"Повторите ввоfд пароля: \"
send \"\r\"
expect eof"
if [ $? -eq 0 ]; then
		printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "2. ald-server-common" "Установлен" "Пакет был установлен"
	else
	printf "├%-27.27s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "2. ald-server-common" "Ошибка" "Не возможно установить пакет"
	fi
else
		printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "2. ald-server-common" "Установлен" "Пакет был установлен"
fi
#-------------------------------------------------------------------------------------
if [ -f /etc/ald/ald.conf ]

        then
        printf "├%-35.35s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-53.53s ${YELLOW}${BOLD}│\n"  "3. Проверка ald.conf" "Выполнено" "Файл имеется"
        else
        aldd
		printf "├%-35.35s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-53.53s ${YELLOW}${BOLD}│\n"  "3. Проверка ald.conf" "Выполнено" "Файл был сгенерирован"
fi
#-------------------------------------------------------------------------------------
sed -i "s/.*SERVER_ID=.*/SERVER_ID=2/g" /etc/ald/ald.conf
sed -i "s/.*SERVER_ON=.*/SERVER_ON=1/g" /etc/ald/ald.conf
sed -i "s/.*CLIENT_ON=.*/CLIENT_ON=1/g" /etc/ald/ald.conf
sed -i "s/.*DOMAIN=.*/DOMAIN=.$domain_name/g" /etc/ald/ald.conf
sed -i "s/.*SERVER=.*/SERVER=$control_arm.$domain_name/g" /etc/ald/ald.conf
sed -i "s/.*NETWORK_FS_TYPE=.*/NETWORK_FS_TYPE=none/g" /etc/ald/ald.conf
if [ $? -eq 0 ]; then
	printf "├%-36.36s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-63.63s ${YELLOW}${BOLD}│\n"  "4. Настройка ald.conf" "Выполнено" "Конфигурация настроена"
	else
	printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "4. Настройка ald.conf" "Ошибка" "Не возможно отредактировать файл"
fi
#-------------------------------------------------------------------------------------

ald-init init --slave -f --pass-file=/tmp/pass 1>> $LOG_FILE 2>> $LOG_FILE
sudo rm /tmp/pass 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	printf "├%-40.40s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-68.68s ${YELLOW}${BOLD}│\n"  "5. Инициализация" "Выполнено" "Инициализация прошла успешно"
	else
	printf "├%-36.36s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "5. Инициализация" "Ошибка" "Не возможно инициализациировать"
fi
#-------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
#-------------------------------------------------------------------------------------
ald-client -t | grep "Клиент ALD"
#-------------------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
#								FreeIPA-DOMAIN
#===========================================================================
remove_fipa(){
clear
export DEBIAN_FRONTEND=noninteractive

echo -e "${RED}${BOLD}======================================================${NC}"
echo -e "${RED}${BOLD}ВНИМАНИЕ! ЗАПУЩЕН ПРОЦЕСС ПОЛНОГО УДАЛЕНИЯ FREEIPA${NC}"
echo -e "${RED}${BOLD}Все данные домена, пользователи и политики будут стерты!${NC}"
echo -e "${RED}${BOLD}======================================================${NC}"
read -p "Вы уверены, что хотите продолжить? [y/N]: " confirm
confirm=${confirm:-n}

if [ "${confirm,,}" != "y" ]; then
    echo -e "${GREEN}Удаление отменено.${NC}"
    sleep 2
    return
fi

LOG_FILE="fripa_uninstall_log$(date +%d-%m-%Y).log"
echo "--- Запуск удаления FreeIPA: $(date) ---" > "$LOG_FILE"

# Функция-помощник для вывода красивого статуса [ OK ] или [ ОТКАЗ ]
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${BOLD}[ OK ]${NC}"
    else
        echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
    fi
}

echo -e "\n${YELLOW}${BOLD}Начинаем процесс удаления...${NC}\n"
sleep 1

#-------------------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Деинсталляция FreeIPA сервера             ${NC}"
sudo ipa-server-install --uninstall -U >> "$LOG_FILE" 2>&1
check_status

#-------------------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Очистка кэша и конфигурации SSSD          ${NC}"
sudo systemctl stop sssd >> "$LOG_FILE" 2>&1
sudo rm -rf /var/lib/sss/db/* /var/lib/sss/mc/* >> "$LOG_FILE" 2>&1
sudo rm -f /etc/sssd/sssd.conf >> "$LOG_FILE" 2>&1
check_status

#-------------------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Восстановление оригинального /etc/hosts   ${NC}"
if [ -f /etc/hosts.bak ]; then
    sudo mv /etc/hosts.bak /etc/hosts
    check_status
else
    echo -e "${YELLOW}${BOLD}[ ПРОПУЩЕНО ]${NC}"
fi

#-------------------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Восстановление оригинального имени хоста  ${NC}"
if [ -f /etc/hostname.bak ]; then
    sudo mv /etc/hostname.bak /etc/hostname
    sudo hostname -F /etc/hostname >> "$LOG_FILE" 2>&1
    check_status
else
    echo -e "${YELLOW}${BOLD}[ ПРОПУЩЕНО ]${NC}"
fi

#-------------------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}5. Сброс сетевых настроек DNS                ${NC}"
rm -f /etc/resolv.conf
if systemctl is-active --quiet NetworkManager; then
    sudo systemctl restart NetworkManager >> "$LOG_FILE" 2>&1
    check_status
else
    echo "nameserver 77.88.8.8" > /etc/resolv.conf
    check_status
fi

#-------------------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}6. Полное удаление пакетов из системы        ${NC}"
sudo apt-get purge -y astra-freeipa-server fly-admin-freeipa-server sssd >> "$LOG_FILE" 2>&1
sudo apt-get autoremove -y >> "$LOG_FILE" 2>&1
check_status

#-------------------------------------------------------------------------------------
echo -e "\n${GREEN}${BOLD}========================================${NC}"
echo -e "${GREEN}${BOLD}   УДАЛЕНИЕ ДОМЕНА ПОЛНОСТЬЮ ЗАВЕРШЕНО  ${NC}"
echo -e "${GREEN}${BOLD}========================================${NC}"
echo -e "${YELLOW}Рекомендуется перезагрузить сервер для применения всех изменений PAM.${NC}\n"

read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
install_fipa_S(){
clear
export DEBIAN_FRONTEND=noninteractive
	LOG_FILE="fripa_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка freeIPA-DOMAIN-SEVRER :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname`

echo -e "${GREEN}${BOLD}Установка Сервера Домена FreeIPA${NC}"
echo -e "${RED}${BOLD}Внимание! Перед установкой убедитесь, что сеть и файл hosts настроены правильно.${NC}"
echo -e "${YELLOW}${BOLD}Укажите имя домена, в виде (my.domain)"
read domain_name
echo -e "${YELLOW}${BOLD}Укажите пароль администратора для FreeIPA"
read pass_fripa
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
echo -e "${RED}${BOLD}Возможны ошибки, до появления таблицы."
echo -e "${RED}${BOLD}Все в порядке это sssd шалит."
cp /etc/hostname /etc/hostname.bak
cp /etc/hosts /etc/hosts.bak
sudo DEBIAN_FRONTEND=noninteractive apt install -y sssd 1>> $LOG_FILE 2>> $LOG_FILE 
sleep 4
clear
echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐"
printf "│ %-31.31s │ %-18.18s │ %-47.47s │" "Задача" "Статус" "Вывод"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
#-------------------------------------------------------------------------------------
if [ $(dpkg-query -W -f='${Status}' astra-freeipa-server 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
apt install astra-freeipa-server -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "1. astra-freeipa-server" "Установлен" "Пакет был установлен"
	else
	printf "├%-27.27s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "1. astra-freeipa-server" "Ошибка" "Не возможно установить пакет"
fi
else
	printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "1. astra-freeipa-server" "Установлен" "Пакет был установлен"
fi
#-------------------------------------------------------------------------------------

if [ $(dpkg-query -W -f='${Status}' fly-admin-freeipa-server 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
apt install fly-admin-freeipa-server -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
		printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "2. fly-admin-freeipa-server" "Установлен" "Пакет был установлен"
	else
	printf "├%-27.27s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "2. fly-admin-freeipa-server" "Ошибка" "Не возможно установить пакет"
	fi
else
		printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "2. fly-admin-freeipa-server" "Установлен" "Пакет был установлен"
fi

#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------

echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
#-------------------------------------------------------------------------------------
echo -e "${RED}${BOLD}Внимание! Установка продолжается, выполняется Инициализация${NC}"
sudo astra-freeipa-server -d "$domain_name" -p "$pass_fripa" -y 1>> $LOG_FILE 2>> $LOG_FILE
#-------------------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}Инициализация прошла успешно!${NC}"
if [ -f /etc/resolv.conf ]
        then
        sudo rm /etc/resolv.conf 1>> $LOG_FILE 2>> $LOG_FILE
        echo "search $domain_name
nameserver 127.0.0.1 " >> /etc/resolv.conf
        else
        echo "search $domain_name
nameserver 127.0.0.1 " >> /etc/resolv.conf
fi
echo -e "${GREEN}${BOLD}Автоматический переход https://$name_arm.$domain_name ${NC}"
sleep 2
sudo firefox https://$name_arm.$domain_name
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
install_fipa_C(){
clear
export DEBIAN_FRONTEND=noninteractive
	LOG_FILE="fripa_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка freeIPA-DOMAIN-CLIENT :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname`

echo -e "${GREEN}${BOLD}Установка Клиента Домена FreeIPA${NC}"
echo -e "${RED}${BOLD}Внимание! Перед установкой убедитесь, что сеть и файл hosts настроены правильно.${NC}"
echo -e "${RED}${BOLD}Так же убедитесь, что время и дата на этом АРМ совпадает с датой и временем Сервера FreeIPA${NC}"
echo -e "${YELLOW}${BOLD}Укажите имя домена, в виде (my.domain)"
read domain_name
echo -e "${YELLOW}${BOLD}Укажите пароль администратора для FreeIPA"
read pass_fripa
echo -e "${YELLOW}${BOLD}Укажите адресс сервера FreeIPA"
read ipadr_fripa
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
echo -e "${RED}${BOLD}Возможны ошибки, до появления таблицы."
echo -e "${RED}${BOLD}Все в порядке это sssd шалит."
cp /etc/hostname /etc/hostname.bak
cp /etc/hosts /etc/hosts.bak
sudo apt install sssd -y 1>> $LOG_FILE 2>> $LOG_FILE
sleep 4
clear
echo -e "${YELLOW}${BOLD}┌⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┬⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┐"
printf "│ %-31.31s │ %-18.18s │ %-47.47s │" "Задача" "Статус" "Вывод"
echo ""
echo -e "${YELLOW}${BOLD}├⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┼⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┤"
if [ $(dpkg-query -W -f='${Status}' astra-freeipa-client 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
apt install astra-freeipa-client -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "1. astra-freeipa-client" "Установлен" "Пакет был установлен"
	else
	printf "├%-27.27s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-61.61s${YELLOW}${BOLD}│\n"  "1. astra-freeipa-client" "Ошибка" "Не возможно установить пакет"
fi
else
	printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "1. astra-freeipa-client" "Установлен" "Пакет был установлен"
fi
#-------------------------------------------------------------------------------------
if [ $(dpkg-query -W -f='${Status}' fly-admin-freeipa-client 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
apt install fly-admin-freeipa-client -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
		printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "2. fly-admin-freeipa-client" "Установлен" "Пакет был установлен"
	else
	printf "├%-27.27s│ ${RED}${BOLD}%-24.24s${YELLOW}${BOLD}│${RED}${BOLD} %-71.71s${YELLOW}${BOLD}│\n"  "2. fly-admin-freeipa-client" "Ошибка" "Не возможно установить пакет"
	fi
else
		printf "├%-27.27s│ ${GREEN}${BOLD}%-22.22s${YELLOW}${BOLD} │${GREEN}${BOLD} %-60.60s ${YELLOW}${BOLD}│\n"  "2. fly-admin-freeipa-client" "Установлен" "Пакет был установлен"
fi
#-------------------------------------------------------------------------------------
if [ -f /etc/resolv.conf ]
        then
        sudo rm /etc/resolv.conf 1>> $LOG_FILE 2>> $LOG_FILE
        echo "search $domain_name
nameserver $ipadr_fripa" >> /etc/resolv.conf
        printf "├%-31.31s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-61.61s ${YELLOW}${BOLD}│\n"  "3. Файл resolv.conf" "Выполнено" "Файл сконфигурирован"
        else
        echo "search $domain_name
nameserver $ipadr_fripa" >> /etc/resolv.conf
		printf "├%-31.31s│ ${GREEN}${BOLD}%-21.21s${YELLOW}${BOLD} │${GREEN}${BOLD} %-61.61s ${YELLOW}${BOLD}│\n"  "3. Файл resolv.conf" "Выполнено" "Файл сконфигурирован"
fi
echo -e "${YELLOW}${BOLD}└⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┴⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺⸺┘${NC}"
#-------------------------------------------------------------------------------------
echo -e "${RED}${BOLD}Внимание! Установка продолжается, выполняется Инициализация${NC}"
sleep 1
[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
expect -c 1>> $LOG_FILE 2>> $LOG_FILE "
set timeout 180
spawn sudo astra-freeipa-client -d $domain_name -u admin -px
sleep 4
expect \"Введите пароль администратора домена\"
send \"$pass_fripa\r\"
sleep 4
expect \"Введите парольd еще раз: \"
send \"\r\"
sleep 10
exp_continue
expect eof"
#-------------------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}Инициализация прошла успешно!${NC}"
echo -e "${GREEN}${BOLD}Перезагрузите АРМ!${NC}"
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
#							КОНЕЦ РАЗДЕЛА DOMAIN
#===========================================================================

#===========================================================================
#						НАЧАЛО РАЗДЕЛА ASTRA-OPTI
#===========================================================================
#opti_1_reset			|	 Настройка DNS сервера
#opti_1_server			|	 Удаление DNS сервера

#opti_2_server			|	 Настройка NTP/CHRONY сервера
#opti_2_client			|	 Настройка NTP/CHRONY клиента

#opti_3					|	 Настройка общей директории SAMBA

#opti_4_client			|	 Инструкция для подключение клиентов ThunderBird
#opti_4_remove			|	 Удаление сервера ThunderBird
#opti_4_server			|	 Установка сервера ThunderBird

#opti_5_remove			|	 Удаление Zabbix
#opti_5_server			|	 Установка сервера Zabbix
#opti_5_client			|	 Установка клиента Zabbix

#opti_7_rem			|	 Удаление NFS
#opti_7_srv			|	 Установка сервера NFS
#opti_7_cli			|	 Установка клиента NFS

#===========================================================================
#									DNS
#===========================================================================
opti_1_reset(){
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
sudo rm -r /etc/bind/zones
sudo cp /etc/bind/named.conf.options.bak.bak /etc/bind/named.conf.options
sudo cp /etc/bind/named.conf.local.bak.bak /etc/bind/named.conf.local
sudo rm /etc/bind/named.conf.local.bak.bak
sudo rm /etc/bind/named.conf.options.bak.bak
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
opti_1_server(){
clear
#----------------------------------------------------------------------------
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Настройка DNS :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname -s`
	domain_name=`dnsdomainname`
#----------------------------------------------------------------------------
IFS='.' read -r -a ip_parts <<< "$ip_adr"
if [ ${#ip_parts[@]} -ne 4 ]; then
echo -e "${RED}${BOLD} ОШИБКА, МИЛОРД: Неверный формат IP-адресса${NC}"
echo "ВЫ ВВЕЛИ:$ip_parts"
exit 1
fi
PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.${ip_parts[3]}"
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}Установка Сервера DNS${NC}"
echo -e "${RED}${BOLD}Внимание! Перед установкой убедитесь, что сеть и домен настроены правильно.${NC}"
echo -e "${YELLOW}${BOLD}Ваш адресс, ${GREEN}${BOLD}$ip_adr${NC}"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Настройка named.conf.options ${NC}"
sudo cp /etc/bind/named.conf.options /etc/bind/named.conf.options.bak.bak 1>> $LOG_FILE 2>> $LOG_FILE
sudo sed -i "s/.*dnssec-validation.*/dnssec-validation False;/g" /etc/bind/named.conf.options 1>> $LOG_FILE 2>> $LOG_FILE
sudo sed -i '24,25d' /etc/bind/named.conf.options 1>> $LOG_FILE 2>> $LOG_FILE
sudo echo "forwardes {
	8.8.8.8;
};
listen-on {
	127.0.0.1;
	$ip_adr;
};
};" >> /etc/bind/named.conf.options
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Настройка named.conf.local ${NC}"
sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak.bak 1>> $LOG_FILE 2>> $LOG_FILE
sudo echo '
zone "'$domain_name'" {
	type master;
	file "'/etc/bind/zones/db.$domain_name'";
};

zone "'${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]}.in-addr.arpa'" {
	type master;
	file "'/etc/bind/zones/db.${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]}'";
};' >> /etc/bind/named.conf.local
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Работаем с базами ${NC}"
sudo mkdir /etc/bind/zones 1>> $LOG_FILE 2>> $LOG_FILE
sudo touch /etc/bind/zones/db.$domain_name 1>> $LOG_FILE 2>> $LOG_FILE
sudo chmod 644 /etc/bind/zones/db.$domain_name 1>> $LOG_FILE 2>> $LOG_FILE
sudo touch /etc/bind/zones/db.${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]} 1>> $LOG_FILE 2>> $LOG_FILE
sudo chmod 644 /etc/bind/zones/db.${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]} 1>> $LOG_FILE 2>> $LOG_FILE
#----------------------------------------------------------------------------
sudo echo ";
; BIND data file for local loopback interface
;
$"TTL"	604800
@	IN	SOA	$name_arm.$domain_name. admin.$domain_name. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
; name servers - NS records
@	IN	NS	$name_arm.$domain_name.
; name servers
$name_arm.$domain_name.	IN	A	$ip_adr" >> /etc/bind/zones/db.$domain_name
#----------------------------------------------------------------------------
sudo echo ";
; BIND data file for local loopback interface
;
$"TTL"	604800
@	IN	SOA	$name_arm.$domain_name. admin.$domain_name. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
; name servers
@	IN	NS	$name_arm.$domain_name.
; PTR Records
211 IN PTR $name_arm.$domain_name.	; $ip_adr" >> /etc/bind/zones/db.${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]}
#----------------------------------------------------------------------------


	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Введите IP-адресса (Через пробел):${GREEN}${BOLD}"
read -r list_ip
ips=($list_ip)
echo -e "${YELLOW}${BOLD}5. Введите hostname для каждого IP:${GREEN}${BOLD}"
declare -A ip_hostnames
numberstr="5"
for ip in "${ips[@]}"; do
((numberstr++))
echo -n -e "${YELLOW}${BOLD}$numberstr. HOSTNAME для ${GREEN}${BOLD}$ip: ${GREEN}"
read hostname_list
ip_hostnames["$ip"]=$hostname_list
done
for ip in "${!ip_hostnames[@]}"; do
echo "${ip_hostnames[$ip]}.$domain_name.	IN	A	$ip" >> /etc/bind/zones/db.$domain_name
echo "96	IN	PTR	${ip_hostnames[$ip]}.$domain_name.	; $ip" >> /etc/bind/zones/db.${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]}
done
((numberstr++))
#----------------------------------------------------------------------------
echo -n -e "${YELLOW}${BOLD}$numberstr. Проверка db.$domain_name${GREEN}${BOLD}"
sudo named-checkzone $domain_name /etc/bind/zones/db.$domain_name 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
((numberstr++))
#----------------------------------------------------------------------------
echo -n -e "${YELLOW}${BOLD}$numberstr. Проверка db.${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]}${NC}"
sudo named-checkzone ${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]}.in-addr-arpa /etc/bind/zones/db.${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]} 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
((numberstr++))
#----------------------------------------------------------------------------
echo -n -e "${YELLOW}${BOLD}$numberstr. Перезапуск службы bind9${NC}"
sudo systemctl restart bind9 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
#								NTP / CHRONY
#===========================================================================
opti_2_server(){
clear
#----------------------------------------------------------------------------
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Настройка NTP :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname -s`
	domain_name=`dnsdomainname`
	IFS='.' read -r -a ip_parts <<< "$ip_adr"
	PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.${ip_parts[3]}"
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}Установка Сервера NTP${NC}"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
if ipa --version 2>>$LOG_FILE 1>> $LOG_FILE || systemctl is-active ipa 2>>$LOG_FILE 1>> $LOG_FILE; then
echo -e -n "${RED}${BOLD}ЗАМЕСТО NTP БУДЕТ УСТАНОВЛЕН CHRONY ${NC}"
echo -e  "${RED}${BOLD}ТАК КАК ВЫ ИСПОЛЬЗУЙТЕ ЕПП FREEIPA ${NC}"
#----------------------------------------------------------------------------

echo -e -n "${YELLOW}${BOLD}1. Установка пакета chrony	${NC}"
sudo apt install chrony -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------

echo -e -n "${YELLOW}${BOLD}2. Остановка службы chronyd	 	${NC}"
sudo systemctl stop chronyd 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------

echo -e -n "${YELLOW}${BOLD}3. Конфигурация chrony.conf	 	${NC}"
sudo echo "allow
local stratum 8" > /etc/chrony/chrony.conf 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------

echo -e -n "${YELLOW}${BOLD}4. Отключение запросов по Ipv6	${NC}"
sudo echo 'DAEMON_OPTS="-F 1 -4"' >> /etc/default/chrony 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------

echo -e -n "${YELLOW}${BOLD}5. Автозапуск службы chronyd	${NC}"
sudo systemctl enable chronyd 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------

echo -e -n "${YELLOW}${BOLD}6. Запуск службы chronyd		${NC}"
sudo systemctl start chronyd 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------

echo -e -n "${YELLOW}${BOLD}7. Обновление конфигурации chorny	${NC}"
sudo chronyc reload sources 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu




else
#----------------------------------------------------------------------------

echo -e -n "${YELLOW}${BOLD}1. Установка пакета fly-admin-ntp ${NC}"
if [ $(dpkg-query -W -f='${Status}' fly-admin-ntp 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
sudo apt install fly-admin-ntp -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
else
		echo -e "${GREEN}${BOLD}[ Пропущен ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Создаем ntp.conf.bak ${NC}"
sudo cp /etc/ntp.conf /etc/ntp.conf.bak 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Редактируем ntp.conf ${NC}"
sudo rm /etc/ntp.conf 1>> $LOG_FILE 2>> $LOG_FILE
sudo touch /etc/ntp.conf 1>> $LOG_FILE 2>> $LOG_FILE
sudo chmod 644 /etc/ntp.conf 1>> $LOG_FILE 2>> $LOG_FILE
echo "
driftfile /ver/lib/ntp/ntp.drift

server 127.127.1.1 mode 0 prefer
fudge 127.127.1.1 stratum 10
restrict ${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.0 mask 255.255.255.0 nomodify notrap
" >> /etc/ntp.conf
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Автозапуск ntp ${NC}"
sudo systemctl enable ntp 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
echo -e -n "${YELLOW}${BOLD}4.1 Попытка перенастройки ntp ${NC}"
sudo systemctl unmask ntp.service 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	    fi
echo -e -n "${YELLOW}${BOLD}4.2 Автозапуск ntp ${NC}"
sudo systemctl enable ntp 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	    fi
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}5. Перезапуск ntp ${NC}"
sudo systemctl restart ntp 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
fi
}
#===========================================================================
opti_2_client(){
clear
#----------------------------------------------------------------------------
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Настройка NTP :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname -s`
	domain_name=`dnsdomainname`
	IFS='.' read -r -a ip_parts <<< "$ip_adr"
	PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.${ip_parts[3]}"
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}Установка Сервера NTP${NC}"
echo -e -n "${GREEN}${BOLD}Укажите Сервера NTP: ${NC}"
read serv_ntp
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
if ipa --version 1>> $LOG_FILE 2>> $LOG_FILE || systemctl is-active ipa 1>> $LOG_FILE 2>> $LOG_FILE; then
echo -e  "${RED}${BOLD}ЗАМЕСТО NTP БУДЕТ УСТАНОВЛЕН CHRONY ${NC}"
echo -e  "${RED}${BOLD}ТАК КАК ВЫ ИСПОЛЬЗУЙТЕ ЕПП FREEIPA ${NC}"

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Установка пакета crhony		${NC}"
sudo apt install chrony -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Остановка службы chronyd		${NC}"
sudo systemctl stop chronyd 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Удаление внешних СЕВ			${NC}"
sudo sed -i '/^pool.*server\|^server.*pool/d' /etc/chrony/chrony.conf 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Конфигурация chrony.conf		${NC}"
sudo echo "server $serv_ntp iburst" > /etc/chrony/chrony.conf 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}5. Автозапуск службы chronyd		${NC}"
sudo systemctl enable chronyd 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}6. Запуск службы chronyd		${NC}"
sudo systemctl start chronyd 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}7. Обновление конфигурации		${NC}"
sudo chronyc reload sources 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu

else
echo -e -n "${YELLOW}${BOLD}1. Установка пакета fly-admin-ntp ${NC}"
if [ $(dpkg-query -W -f='${Status}' fly-admin-ntp 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
sudo apt install fly-admin-ntp -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
else
		echo -e "${GREEN}${BOLD}[ Пропущен ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Создаем ntp.conf.bak ${NC}"
sudo cp /etc/ntp.conf /etc/ntp.conf.bak 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Редактируем ntp.conf ${NC}"
sudo rm /etc/ntp.conf 1>> $LOG_FILE 2>> $LOG_FILE
sudo touch /etc/ntp.conf 1>> $LOG_FILE 2>> $LOG_FILE
sudo chmod 644 /etc/ntp.conf 1>> $LOG_FILE 2>> $LOG_FILE
echo "logconfig +clockall
driftfile /ver/lib/ntp/ntp.drift
statistics clockstats loopstats peerstats

server $serv_ntp minpoll 6 maxpoll 10 version 4 prefer
restrict 127.0.0.1
" >> /etc/ntp.conf
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Автозапуск ntp ${NC}"
sudo systemctl enable ntp 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
echo -e -n "${YELLOW}${BOLD}4.1 Попытка перенастройки ntp ${NC}"
sudo systemctl unmask ntp.service 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	    fi
echo -e -n "${YELLOW}${BOLD}4.2 Автозапуск ntp ${NC}"
sudo systemctl enable ntp 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	    fi
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}5. Перезапуск ntp ${NC}"
sudo systemctl restart ntp 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
fi
}
#===========================================================================
#						Настройка общей директории SAMBA
#===========================================================================
opti_3(){
clear
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Настройка общий директории :$(date +"$DATE_FORMAT")" >> $LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname -s`
	domain_name=`dnsdomainname`
	IFS='.' read -r -a ip_parts <<< "$ip_adr"
	PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.${ip_parts[3]}"
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}Установка общий директории${NC}"
echo -e -n "${YELLOW}${BOLD}Укажите название директории учитывая ее расположение ${GREEN}${BOLD}(например, /srv/share или /share)${YELLOW}${BOLD}: "
read NAME_SHARE
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Установка пакета samba ${NC}"
if [ $(dpkg-query -W -f='${Status}' samba 2>> $LOG_FILE | grep -c "ok installed") -eq 0 ];
then
sudo apt install samba -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
else
		echo -e "${GREEN}${BOLD}[ Пропущен ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Создание директории ${NC}"

sudo mkdir -p $NAME_SHARE 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Установка прав ${NC}"

chmod 777 $NAME_SHARE 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Проверка конфигурации ${NC}"
if [ -f /etc/samba/smb.conf ]; then
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak 1>> $LOG_FILE 2>> $LOG_FILE
sudo rm /etc/samba/smb.conf 1>> $LOG_FILE 2>> $LOG_FILE
sudo touch /etc/samba/smb.conf 1>> $LOG_FILE 2>> $LOG_FILE
else
sudo touch /etc/samba/smb.conf 1>> $LOG_FILE 2>> $LOG_FILE
fi
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}5. Конфигурация ${NC}"
echo "[global]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = astra-linux
security = user
map to guest = bad user
dns proxy = no
log file = /var/log/samba/log.%m
max log size = 1000
socket options = TCP_NODELAY SO_RVCBUF=8192 SO_SNDBUF=8192
preferred master = no
local master = no

[OBMEN]
path = $NAME_SHARE
browseable = yes
writable = yes
guest ok = yes
read only = no
create mask = 0775
directory mask = 0775

" > /etc/samba/smb.conf
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}6. Перезапуск служб ${NC}"
sudo systemctl unmask smbd 1>> $LOG_FILE 2>> $LOG_FILE
sudo systemctl enable smbd 1>> $LOG_FILE 2>> $LOG_FILE
sudo systemctl restart smbd 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}============================================${NC}"
echo -e "${YELLOW}${BOLD}Для подключения используйте:${NC}"
echo -e "${YELLOW}${BOLD}Windows: ${GREEN}${BOLD}\\\\$ip_adr\\$NAME_SHARE ${NC}"
echo -e "${YELLOW}${BOLD}Linux: ${GREEN}${BOLD}smb://$ip_adr/$NAME_SHARE ${NC}"
echo -e "${GREEN}${BOLD}============================================${NC}"
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
#								ThunderBird
#===========================================================================
opti_4_client(){
clear
echo -e "${YELLOW}${BOLD}----------------------------------------------------------------------------"
echo -e "${YELLOW}${BOLD}		  Настройка THUNDERBIRD на клиентской машине
  Данная странница является лишь инструкции, так как установка и настройка клиента ${GREEN}${BOLD}ThunderBird${YELLOW}${BOLD}
производится руками в приложении!
 1. Запустите АРМ клиента.
 2. Зайдите доступным вам доменным пользователем.
 3. Запустите приложение: ${GREEN}${BOLD}ПУСК -> Сети -> Почта ThunderBird${YELLOW}${BOLD}
 4. В открывшемся окне входа, ОБЯЗАТЕЛЬНО введите:
    4.1 ${GREEN}${BOLD}Полное имя. ${YELLOW}${BOLD}
    Пример: ${GREEN}${BOLD}Иван Иванов${YELLOW}${BOLD}
    4.2 ${GREEN}${BOLD}Адрес электронной почты${YELLOW}${BOLD} (Где укажите логин доменого пользователя до @ после укажите
    имя домена)
    Пример: ${GREEN}${BOLD}ivan@my.domain ${YELLOW}${BOLD}
 5. Нажмите кнопку ${RED}${BOLD}[Продолжить]${YELLOW}${BOLD}
 6. Должна появится желтая плашка с текстом ${YELLOW}[ThunderBird не удалось найти настройки для вашей
 учетной записи почты]${YELLOW}${BOLD}
А ниже дополнительные настройки ${GREEN}${BOLD}[Параметры сервера]${YELLOW}${BOLD}
 7. Сервер входящий почты
 ├⸺Протокл:  ${GREEN}${BOLD}IMAP${YELLOW}${BOLD}
 ├⸺Имя сервера:  ${GREEN}${BOLD}(Укажите имя сервера почты).my.domain${YELLOW}${BOLD}
 ├⸺Порт:  ${GREEN}${BOLD}143${YELLOW}${BOLD}
 ├⸺Защита соединения:  ${GREEN}${BOLD}Нет${YELLOW}${BOLD}
 ├⸺Метод аунтентификации:  ${GREEN}${BOLD}Kerberos / GSSAPI${YELLOW}${BOLD}
 └⸺Имя пользователя:  ${GREEN}${BOLD}ivan@my.domain${YELLOW}${BOLD}
 8. Сервер исходящей почты
 ├⸺Имя сервера:  ${GREEN}${BOLD}(Укажите имя сервера почты).my.domain${YELLOW}${BOLD}
 ├⸺Порт:  ${GREEN}${BOLD}25${YELLOW}${BOLD}
 ├⸺Защита соединения:  ${GREEN}${BOLD}Нет${YELLOW}${BOLD}
 ├⸺Метод аунтентификации:  ${GREEN}${BOLD}Kerberos / GSSAPI${YELLOW}${BOLD}
 └⸺Имя пользователя:  ${GREEN}${BOLD}ivan@my.domain${YELLOW}${BOLD}
 9. Нажмите кнопку ${RED}${BOLD}[Перетестировать]${YELLOW}${BOLD}
 10.Дождитесь зеленный плашки с текстом ${GREEN}${BOLD}[При проверке указанного сервера были найдены
 следующие настройки:]${YELLOW}${BOLD}
 11.Нажмите кнопку ${RED}${BOLD}[Готово]${YELLOW}${BOLD}
 12.Появится окно ${GREEN}${BOLD}[ Внимание! ...]${YELLOW}${BOLD}
 13.Ставим флаг ${RED}${BOLD}(Я понимаю риски)${YELLOW}${BOLD} -> жмем кнопку ${RED}${BOLD}[Подтвердить]${YELLOW}${BOLD}
  На данном этапе настройка закончена, попытайтесь отправить тестовое письмо другому
пользователю, и проверьте что оно пришло!"
echo -e "${YELLOW}${BOLD}----------------------------------------------------------------------------"
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu

}
#===========================================================================
opti_4_remove(){
#----------------------------------------------------------------------------
	clear
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Удаление exim4 и dovecot :$(date +"$DATE_FORMAT")" >>$LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname -s`
	domain_name=`dnsdomainname`
	domain_name_up=$(echo "$domain_name" | tr '[:lower:]' '[:upper:]')
	IFS='.' read -r -a ip_parts <<< "$ip_adr"
	PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.${ip_parts[3]}"
echo -e "${GREEN}${BOLD}Удаление почтового сервиса"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
echo -e "${NC}"
sudo apt purge --autoremove -y exim4-daemon-heavy dovecot-imapd dovecot-gssapi
[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
expect -c "
spawn sudo kinit admin
sleep 1
expect \"Password for admin@H$domain_name_up: \"
send \"12345678\r\"
expect eof"
sudo ipa service-del imap/$name_arm.$domain_name@$domain_name_up
sudo ipa service-del smtp/$name_arm.$domain_name@$domain_name_up
sudo ald-admin service-del imap/$name_arm.$domain_name
sudo ald-admin service-del smtp/$name_arm.$domain_name
sudo rm -f /var/lib/dovecot/dovecot.keytab
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
opti_4_server(){
clear
	sudo touch options_install_log$(date +%d-%m-%Y).log
	chmod 777 options_install_log$(date +%d-%m-%Y).log
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Настройка exim4 и dovecot для работы с thunderbird :$(date +"$DATE_FORMAT")" >> $LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname -s`
	domain_name=`dnsdomainname`
	domain_name_up=$(echo "$domain_name" | tr '[:lower:]' '[:upper:]')
	IFS='.' read -r -a ip_parts <<< "$ip_adr"
	PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.${ip_parts[3]}"
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}Настройка exim4 и dovecot для работы с thunderbird${NC}"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Установка пакетов сервеной части Почты			${NC}"
sudo apt install exim4-daemon-heavy dovecot-imapd dovecot-gssapi -y 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Конфигурация файла 10-master.conf				${NC}"
sleep 1
sudo sed -i '105s/.*/  unix_listener auth-client {/' /etc/dovecot/conf.d/10-master.conf 1>> $LOG_FILE 2>> $LOG_FILE
sudo sed -i '105a\	mode = 0600' /etc/dovecot/conf.d/10-master.conf 1>> $LOG_FILE 2>> $LOG_FILE
sudo sed -i '106a\	user = Debian-exim' /etc/dovecot/conf.d/10-master.conf 1>> $LOG_FILE 2>> $LOG_FILE
sudo sed -i '107a\  }' /etc/dovecot/conf.d/10-master.conf 1>> $LOG_FILE 2>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Атоматическая конфигурация exim4				${NC}"
[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
expect -c 1>> $LOG_FILE 2>> $LOG_FILE "
spawn sudo dpkg-reconfigure exim4-config
sleep 1
expect \"Общий тип почтовой конфигурации: \"
send \"4\r\"
sleep 1
expect \"Почтовое имя системы: \"
send \"$domain_name\r\"
sleep 1
expect \"IP-адреса, с которых следует ожидать входящие соединения SMTP: \"
send \"$ip_adr\r\"
sleep 1
expect \"Другие места назначения, для которых должна приниматься почта: \"
send \"$domain_name\r\"
sleep 1
expect \"Машины, для которых доступна релейная передача почты: \"
send \"${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.0/24\r\"
sleep 1
expect \"Сокращать количество DNS-запросов до минимума (дозвон по требованию)?* \"
send \"нет\r\"
sleep 1
expect \"Метод доставки локальной почты: \"
send \"2\r\"
sleep 1
expect \"Разделить конфигурацию на маленькие файлы?* \"
send \"нет\r\"
sleep 1
expect eof"
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. ОПРЕДЕЛЕНИЕ ДОМЕНА:						${NC}"
sleep 2
if ipa --version 2>>$LOG_FILE 1>> $LOG_FILE || systemctl is-active ipa 2>>$LOG_FILE 1>> $LOG_FILE; then
	echo -e "${GREEN}${BOLD}[ FreeIPA ]${NC}"
	echo ""
	echo -e "${YELLOW}${BOLD}-------------------------------------------------------------------------------${NC}"
	echo -e "${YELLOW}${BOLD}			Начинаем настройку под домен ${RED}${BOLD}FreeIPA ${NC}"
	echo -e "${YELLOW}${BOLD}-------------------------------------------------------------------------------${NC}"
	sleep 1
	#----------------------------------------------------------------------------
	echo -e "${YELLOW}${BOLD}5. Добавление служб принципалов ${NC}"
	[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
expect -c 1>> $LOG_FILE 2>> $LOG_FILE "
spawn sudo kinit admin
sleep 1
expect \"Password for admin@$domain_name_up: \"
send \"12345678\r\"
expect eof"
	echo -e -n "${YELLOW}${BOLD}	5.1 imap						${NC}"
	sudo ipa service-add imap/$name_arm.$domain_name@$domain_name_up 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ] ${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ] ${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}	5.2 smtp						${NC}"
	sudo ipa service-add smtp/$name_arm.$domain_name@$domain_name_up 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}	5.3 Обратная зона DNS					${NC}"
	sudo ipa dnszone-add ${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]}.in-addr.arpa. 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}	5.4 Добавление PTR записи				${NC}"
	sudo ipa dnsrecord-add ${ip_parts[2]}.${ip_parts[1]}.${ip_parts[0]}.in-addr.arpa. 1 --ptr-rec=$name_arm@$domain_name 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}	5.5 Добавление MX записи				${NC}"
sudo ipa dnsrecord-add episod.ocr. @ --mx-rec="15 server1.episod.ocr." 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi

	#----------------------------------------------------------------------------
	echo -e "${YELLOW}${BOLD}6. Получение таблицы ключей ${NC}"
	[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
expect -c 1>> $LOG_FILE 2>> $LOG_FILE "
spawn sudo kinit admin
sleep 1
expect \"Password for admin@$domain_name_up: \"
send \"12345678\r\"
expect eof "
	echo -e -n "${YELLOW}${BOLD}	6.1 imap						${NC}"
	sudo ipa-getkeytab --principal=imap/$name_arm.$domain_name@$domain_name_up --keytab=/var/lib/dovecot/dovecot.keytab 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}	6.2 smtp						${NC}"
	sudo ipa-getkeytab --principal=smtp/$name_arm.$domain_name@$domain_name_up --keytab=/var/lib/dovecot/dovecot.keytab 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	#----------------------------------------------------------------------------
	echo -e "${YELLOW}${BOLD}7. Проверка таблицы ключей ${NC}${GREEN}${BOLD}"
	echo ""
	sudo klist -k /var/lib/dovecot/dovecot.keytab
	echo ""
	sudo klist -k /var/lib/dovecot/dovecot.keytab 1>> $LOG_FILE 2>> $LOG_FILE
	#----------------------------------------------------------------------------
	echo -e -n "${YELLOW}${BOLD}8. Выдача прав на чтение ключа Kerberos				${NC}"
	sudo setfacl -m u:dovecot:x /var/lib/dovecot 1>> $LOG_FILE 2>> $LOG_FILE
	sudo setfacl -m u:dovecot:r /var/lib/dovecot/dovecot.keytab 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	#----------------------------------------------------------------------------
	echo -e -n "${YELLOW}${BOLD}9. Изменении  протокола в 10-master.conf			${NC}"
	sudo sed -i '/protocols =*/a\protocols = imap' /etc/dovecot/dovecot.conf 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	#----------------------------------------------------------------------------
	echo -e -n "${YELLOW}${BOLD}10. Конфигурация  10-auth.conf					${NC}"
	sudo sed -i "s/.*#disable_plaintext_auth = yes*/disable_plaintext_auth = yes/g" /etc/dovecot/conf.d/10-auth.conf 1>> $LOG_FILE 2>> $LOG_FILE
	sudo sed -i "s/.*#auth_gssapi_hostname =*/auth_gssapi_hostname = $name_arm.$domain_name/g" /etc/dovecot/conf.d/10-auth.conf 1>> $LOG_FILE 2>> $LOG_FILE
	sudo sed -i '/#auth_krb5_keytab =/a\auth_krb5_keytab =/var/lib/dovecot/dovecot.keytab' /etc/dovecot/conf.d/10-auth.conf 1>> $LOG_FILE 2>> $LOG_FILE
	sudo sed -i "s/.*auth_mechanisms = plain*/auth_mechanisms = gssapi/g" /etc/dovecot/conf.d/10-auth.conf 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	#----------------------------------------------------------------------------
	echo -e -n "${YELLOW}${BOLD}11. Перезапуск службы dovecot					${NC}"
	sudo systemctl restart dovecot 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	#----------------------------------------------------------------------------
	echo -e -n "${YELLOW}${BOLD}12. Настройка авторизации через kerberos			${NC}"
	sudo rm /etc/exim4/conf.d/auth/30_exim4-dovecot* 1>> $LOG_FILE 2>> $LOG_FILE
	sudo echo "dovecot_gssapi:
driver = dovecot
publick_name = GSSAPI
server_socket = /var/run/dovecot/auth-client
server_set_id = auth1" >> /etc/exim4/conf.d/auth/33_exim4-dovecot-kerberos-ipa
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	#----------------------------------------------------------------------------
	echo -e -n "${YELLOW}${BOLD}13. Остановка службы exim4					${NC}"
	sudo systemctl stop exim4 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	#----------------------------------------------------------------------------
	echo -e -n "${YELLOW}${BOLD}14. Запуск службы exim4						${NC}"
	sudo systemctl start exim4 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	#----------------------------------------------------------------------------
	echo -e -n "${YELLOW}${BOLD}15. Автостарт службы exim4					${NC}"
	sudo systemctl enable exim4 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi


echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
	#----------------------------------------------------------------------------
elif grep -q "ldap" /etc/sssd/sssd.conf 1>> $LOG_FILE 2>> $LOG_FILE || \
	 grep -1 "ldap" /etc/nsswitch.conf 1>> $LOG_FILE 2>> $LOG_FILE; then
	echo -e "${GREEN}${BOLD}[ ALD/LDAP ]${NC}"
	echo ""
	echo -e "${YELLOW}${BOLD}-------------------------------------------------------------------------------${NC}"
	echo -e "${YELLOW}${BOLD}			Начинаем настройку под домен ${RED}${BOLD}ALD/LDAP  ${NC}"
	echo -e "${YELLOW}${BOLD}-------------------------------------------------------------------------------${NC}"
	sleep 1
	echo -e -n "${YELLOW}${BOLD}5. Добавление служб принципалов imap				${NC}"
	[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
	expect -c 1>> $LOG_FILE 2>> $LOG_FILE"
spawn sudo ald-admin service-add imap/$name_arm.$domain_name
sleep 1
expect \"Введите пароль администратора ALD: \"
send \"12345678\r\"
expect eof"

	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}6. Выдача группы mac принципалу imap				${NC}"
	[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
	expect -c 1>> $LOG_FILE 2>> $LOG_FILE"
spawn sudo ald-admin sgroup-svc-add imap/$name_arm.$domain_name --sgroup=mac
sleep 1
expect \"Введите пароль администратора ALD: \"
send \"12345678\r\"
expect eof"

	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}7. Выдача группы mail принципалу imap				${NC}"
	[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
	expect -c 1>> $LOG_FILE 2>> $LOG_FILE"
spawn sudo ald-admin sgroup-svc-add imap/$name_arm.$domain_name --sgroup=mail
sleep 1
expect \"Введите пароль администратора ALD: \"
send \"12345678\r\"
expect eof"

	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}8. Создания файла ключа Kerberos imap				${NC}"
	[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
	expect -c 1>> $LOG_FILE 2>> $LOG_FILE"
spawn sudo ald-client update-svc-keytab imap/$name_arm.$domain_name --ktfile="/var/lib/dovecot/dovecot.keytab"
sleep 1
expect \"Введите пароль администратора ALD: \"
send \"12345678\r\"
expect eof"

	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}9. Добавление служб принципалов smtp				${NC}"
	[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
	expect -c 1>> $LOG_FILE 2>> $LOG_FILE"
spawn sudo ald-admin service-add smtp/$name_arm.$domain_name
sleep 1
expect \"Введите пароль администратора ALD: \"
send \"12345678\r\"
expect eof"

	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}10. Выдача группы mac принципалу smtp				${NC}"
	[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
	expect -c 1>> $LOG_FILE 2>> $LOG_FILE"
spawn sudo ald-admin sgroup-svc-add smtp/$name_arm.$domain_name --sgroup=mac
sleep 1
expect \"Введите пароль администратора ALD: \"
send \"12345678\r\"
expect eof"

	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}11. Выдача группы mail принципалу smtp				${NC}"
	[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
	expect -c 1>> $LOG_FILE 2>> $LOG_FILE"
spawn sudo ald-admin sgroup-svc-add smtp/$name_arm.$domain_name --sgroup=mail
sleep 1
expect \"Введите пароль администратора ALD: \"
send \"12345678\r\"
expect eof"

	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}12. Создания файла ключа Kerberos smtp				${NC}"
	[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
	expect -c 1>> $LOG_FILE 2>> $LOG_FILE"
spawn sudo ald-client update-svc-keytab smtp/$name_arm.$domain_name --ktfile="/var/lib/dovecot/dovecot.keytab"
sleep 1
expect \"Введите пароль администратора ALD: \"
send \"12345678\r\"
expect eof"

	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}13. Выдача прав на чтение файла ключа				${NC}"

	sudo setfacl -m u:dovecot:x /var/lib/dovecot
	sudo setfacl -m u:dovecot:x /var/lib/dovecot/dovecot.keytab
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}14. Конфигурация файла 10-master.conf				${NC}"
	sudo sed -i '/protocols =*/a\protocols = imap' /etc/dovecot/conf.d/10-master.conf 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}15. Конфигурация файла 10-auth.conf				${NC}"
	sudo sed -i "s/.*#disable_plaintext_auth = yes.*/disable_plaintext_auth = yes/g" /etc/dovecot/conf.d/10-auth.conf
	sudo sed -i "s/.*#auth_gssapi_hostname =*./auth_gssapi_hostname = $name_arm.$domain_name/g" /etc/dovecot/conf.d/10-auth.conf
	sudo sed -i '/#auth_krb5_keytab =/a\auth_krb5_keytab =/var/lib/dovecot/dovecot.keytab' /etc/dovecot/conf.d/10-auth.conf
	sudo sed -i "s/.*auth_mechanisms = plain*./auth_mechanisms = gssapi/g" /etc/dovecot/conf.d/10-auth.conf
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}16. Перезапуск службы dovecot					${NC}"
	sudo systemctl restart dovecot
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	echo -e -n "${YELLOW}${BOLD}17. Настройка авторизации через kerberos			${NC}"
	sudo echo "dovecot_gssapi:
driver = dovecot
publick_name = GSSAPI
server_socket = /var/run/dovecot/auth-client
server_set_id = "$"auth1" >> /etc/exim4/conf.d/auth/33_exim4-dovecot-kerberos-ipa
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi

	echo -e -n "${YELLOW}${BOLD}18. Удаление старой PAM аунтентификации				${NC}"
	if [ -f /etc/exim4/conf.d/auth/05_dovecot_login ]; then
	sudo rm /etc/exim4/conf.d/auth/05_dovecot_login
		if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi
	else
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	fi

	echo -e -n "${YELLOW}${BOLD}19. Конфигурация файла 10-master.conf				${NC}"
	sudo sed -i '/acl_check_rcpt:/a\deny' /etc/dovecot/conf.d/10-master.conf 1>> $LOG_FILE 2>> $LOG_FILE
	sudo sed -i '/deny/a\	message = "Auth required"' /etc/dovecot/conf.d/10-master.conf 1>> $LOG_FILE 2>> $LOG_FILE
	sudo sed -i '/message = "Auth required"/a\	hosts = *:+relay_from_hosts' /etc/dovecot/conf.d/10-master.conf 1>> $LOG_FILE 2>> $LOG_FILE
	sudo sed -i '/hosts = *:+relay_from_hosts/a\	!authenticated = *' /etc/dovecot/conf.d/10-master.conf 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi

	echo -e -n "${YELLOW}${BOLD}20. Перезагружаем службу exim4					${NC}"
	sudo systemctl reload exim4 1>> $LOG_FILE 2>> $LOG_FILE
	if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
	fi


else
	echo -e "${RED}${BOLD}[ Не определено ]${NC}"
	echo ""
	echo -e "${YELLOW}${BOLD}-------------------------------------------------------------------------------${NC}"
	echo -e "${RED}${BOLD}			Настройка отменена, отсутствует домен  ${NC}"
	echo -e -n "${RED}${BOLD}			Выполнить удаление настроек и уст. пакетов? [Y/n] ${NC}"
	read ot2
if [ -z $ot2 ]; then
    ot2=y
fi
if [ $ot2 = "n" ] || [ $ot2 = "N" ]; then
	echo -e "${YELLOW}${BOLD}-------------------------------------------------------------------------------${NC}"
	echo "[ERROR] ОТМЕНА УСТАНОВКИ, ОТСУТСВУЕТ ДОМЕН ЛИБО СКРИПТ НЕ СМОГ ЕГО ОПРЕДЕЛИТЬ !!!!!!!!!!!!!" > $LOG_FILE
	echo "[WARN] ВЫПОЛНИТЕ УДАЛЕНИЕ, ВЫБРАВ 3 ПУНКТ В УСТАНОВКЕ THUNDERBIRD
УСТАНОВИТЕ ДОМЕН И ПОВТОРИТЕ ПОПЫТКУ УСТАНОВКИ THUNDERBIRD" > $LOG_FILE

else
	echo -e "${YELLOW}${BOLD}-------------------------------------------------------------------------------${NC}"
opti_4_remove
fi
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
fi
}
#===========================================================================
#									Zabbix
#===========================================================================
opti_5_remove(){
sudo apt purge --autoremove -y zabbix-server-pgsql zabbix-frontend-php php-pgsql
sudo apt purge --autoremove -y zabbix-agent
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
opti_5_server(){
clear
	sudo touch options_install_log$(date +%d-%m-%Y).log
	chmod 777 options_install_log$(date +%d-%m-%Y).log
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка ZABBIX server:$(date +"$DATE_FORMAT")" >> $LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname -s`
	domain_name=`dnsdomainname`
	domain_name_up=$(echo "$domain_name" | tr '[:lower:]' '[:upper:]')
	IFS='.' read -r -a ip_parts <<< "$ip_adr"
	PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.${ip_parts[3]}"
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}Настройка ZABBIX server${NC}"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Проверка en_US.UTF-8 локали			${NC}"

sudo sed -i "s/^#\s*\(en_US.UTF-8 UTF-8\)/\1/" /etc/locale.gen 2>> $LOG_FILE 1>> $LOG_FILE

if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Установка en_US.UTF-8 локали			${NC}"

sudo locale-gen en_US.UTF-8 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Обновление локали				${NC}"
sudo update-locale en_US.UTF-8 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Установка пакетов ZABBIX			${NC}"
sudo apt install zabbix-server-pgsql zabbix-frontend-php php-pgsql -y 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}5. Назначение меток безопасности		${NC}"
sudo pdpl-user -l 0:0 postgres 2>> $LOG_FILE 1>> $LOG_FILE

sudo pdpl-user -i 63 postgres 2>> $LOG_FILE 1>> $LOG_FILE

sudo pdpl-user -l 0:0 zabbix 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}6. Разграничение доуступа к БД			${NC}"
sudo setfacl -d -m u:postgres:r /etc/parsec/{macdb,capdb} 2>> $LOG_FILE 1>> $LOG_FILE
sudo setfacl -R -m u:postgres:r /etc/parsec/{macdb,capdb} 2>> $LOG_FILE 1>> $LOG_FILE
sudo setfacl -m u:postgres:rx /etc/parsec/{macdb,capdb} 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}7. Конфигурация apache2				${NC}"
	sudo sed -i "s/.*;date.timezone.*/#date.timezone;/g" /etc/php/*/apache2/php.ini 2>> $LOG_FILE 1>> $LOG_FILE
	sudo sed -i '/#date.timezone;/a\date.timezone = Europe/Moscow' /etc/php/*/apache2/php.ini 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}8. Перезапуск apache2				${NC}"
sudo systemctl reload apache2 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}9. Конфигурация ph_hba.conf			${NC}"
	sudo sed -i '/# TYPE  DATABASE        USER            ADDRESS                 METHOD/a\local	zabbix	zabbix	 	trust' /etc/postgresql/*/main/pg_hba.conf 2>> $LOG_FILE 1>> $LOG_FILE
	sudo sed -i '/# IPv4 local connections:/a\host	zabbix	zabbix	127.0.0.1/32	trust' /etc/postgresql/*/main/pg_hba.conf 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}10. Перезапуск POSTGRESQL			${NC}"
	sudo systemctl restart postgresql 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}11. Создание и конфигурация БД			${NC}"
[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
expect -c 2>> $LOG_FILE 1>> $LOG_FILE "
spawn sudo -u postgres psql
sleep 2
send \"CREATE DATABASE ZABBIX;\r\"
sleep 1
send \"CREATE USER zabbix WITH ENCRYPTED PASSWORD '12345678';\r\"
sleep 1
send \"GRANT ALL ON DATABASE zabbix to zabbix;\r\"
sleep 1
send \"ALTER DATABASE zabbix OWNER TO zabbix;\r\"
sleep 1
send \"exit\r\"
expect eof"
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}12. Копирование БД				${NC}"
zcat /usr/share/zabbix-server-pgsql/{schema,images,data}.sql.gz | psql -h localhost zabbix zabbix 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}13. Включение web-сайта				${NC}"
sudo a2enconf zabbix-frontend-php 2>> $LOG_FILE 1>> $LOG_FILE
sudo systemctl reload apache2 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}14. Настройка web-интерфейса			${NC}"
gunzip -c /usr/share/doc/zabbix-server-pgsql/create.sql.gz > create.sql 2>> $LOG_FILE 1>> $LOG_FILE
psql -U zabbix -d zabbix -f create.sql 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}15. Конфигурация zabbix.conf.php		${NC}"
sudo cp /usr/share/zabbix/conf/zabbix.conf.php.example /etc/zabbix/zabbix.conf.php 2>> $LOG_FILE 1>> $LOG_FILE
sudo chown www-data:www-data /etc/zabbix/zabbix.conf.php 2>> $LOG_FILE 1>> $LOG_FILE

	sudo sed -i 's/MYSQL/POSTGRESQL/g' /etc/zabbix/zabbix.conf.php 2>> $LOG_FILE 1>> $LOG_FILE
	sudo sed -i "s/.*PASSWORD*.*/""/g" /etc/zabbix/zabbix.conf.php 2>> $LOG_FILE 1>> $LOG_FILE
	echo "$""DB['PASSWORD']			= '12345678';" >> /etc/zabbix/zabbix.conf.php
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
	echo -e -n "${YELLOW}${BOLD}16. Перезапуск apache2				${NC}"
	sudo systemctl reload apache2 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}17. Перезапуск zabbix-server			${NC}"
	sudo systemctl enable zabbix-server 2>> $LOG_FILE 1>> $LOG_FILE
	sudo systemctl start zabbix-server 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi

#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}18. Установка zabbix-agent			${NC}"
	sudo apt install zabbix-agent -y 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}19. Перезапуск zabbix-agent			${NC}"
	sudo systemctl restart zabbix-agent 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}20. Завершение установки			${NC}"
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
echo -e "${YELLOW}${BOLD}Автоматический переход на web-сайт ${GREEN}${BOLD}http:///127.0.0.1/zabbix${NC}"
	firefox http:///127.0.0.1/zabbix 2>> $LOG_FILE 1>> $LOG_FILE
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
opti_5_client(){
clear
sudo touch options_install_log$(date +%d-%m-%Y).log
	chmod 777 options_install_log$(date +%d-%m-%Y).log
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка ZABBIX client:$(date +"$DATE_FORMAT")" >> $LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
echo -e "${GREEN}${BOLD}Настройка ZABBIX Client${NC}"
echo -e -n "${YELLOW}${BOLD}Укажите адресс сервера ZABBIX: "
read ip_zabbix
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Установка zabbix-agent			${NC}"
	sudo apt install zabbix-agent -y 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Конфигурация файла				${NC}"
sudo sed -i "s/.Server=127.0.0.1*/Server=$ip_zabbix/g" /etc/zabbix/zabbix_agentd.conf 2>> $LOG_FILE 1>> $LOG_FILE
sudo sed -i "s/.# ListenPort=10051*/ListenPort=10051/g" /etc/zabbix/zabbix_agentd.conf 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Перезапуск zabbix-agent			${NC}"
	sudo systemctl restart zabbix-agent 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
echo -e "${YELLOW}${BOLD}----------------------------------------------------------------------------"
echo -e "${YELLOW}${BOLD}4.Действия в WEB-интерфейсе сервера zabbix:
	a. Перейти в ${GREEN}${BOLD}\"Мониторинг\"${YELLOW}${BOLD} → ${GREEN}${BOLD}\"Узлы сети\"${YELLOW}${BOLD} → ${GREEN}${BOLD}\"Создать узел сети\"${YELLOW}${BOLD}:
	b. В открывшейся форме указать:
	  i. В поле ${GREEN}${BOLD}\"Имя узла сети\"${YELLOW}${BOLD} — краткое имя добавляемого узла.
	  ii. В поле ${GREEN}${BOLD}\"Шаблоны\"${YELLOW}${BOLD} — шаблон Linux by Zabbix agent (и иные шаблоны,
	  если используются).
	  iii. В поле ${GREEN}${BOLD}\"Группы\"${YELLOW}${BOLD} — название Linux Servers
	  iv. Выбрать ссылку ${GREEN}${BOLD}\"${YELLOW}${BOLD}Добавить\".
	  v. Выбрать интерфейс ${GREEN}${BOLD}\"Агент\"${YELLOW}${BOLD} и указать IP-адрес добавляемого узла.
	  vi. Нажать кнопку ${GREEN}${BOLD}\"Добавить\"${YELLOW}${BOLD}."
echo -e "${YELLOW}${BOLD}----------------------------------------------------------------------------"
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
#									PXE
#===========================================================================
opti_6(){
clear
	sudo touch options_install_log$(date +%d-%m-%Y).log
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка PXE BOOT server:$(date +"$DATE_FORMAT")" >> $LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
FILE="${1:-/etc/apt/sources.list}"
TARGET="netinst/pxelinux.0"
VALID=""
ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	name_arm=`hostname -s`
	domain_name=`dnsdomainname`
	domain_name_up=$(echo "$domain_name" | tr '[:lower:]' '[:upper:]')
	IFS='.' read -r -a ip_parts <<< "$ip_adr"
	PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.${ip_parts[3]}"
#----------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}Установка Сервера PXE boot${NC}"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#----------------------------------------------------------------------------
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Установка пакета isc-dhcp-server		${NC}"
	sudo apt install -y isc-dhcp-server 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Настройка интерфейса isc-dhcp-server		${NC}"
	sudo sed -i 's/^#*INTERFACESv4="".*/INTERFACESv4="eth0"/' /etc/default/isc-dhcp-server 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Настройка конфигурации dhcpd.conf		${NC}"
	echo "
authoritative;
option domain-name \"example.com\";
option domain-name-servers 8.8.8.8;

next-server $ip_adr;
option architecture code 93 = unsigned integer 16 ;
if option architecture = 00:07 {
  filename \"debian-installer/amd64/grub/x86_64-efi/core.efi\";
} elsif option architecture = 00:09 {
  filename \"debian-installer/amd64/grub/x86_64-efi/core.efi\";
} else {
  filename \"pxelinux.0\";
}

subnet ${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.0 netmask 255.255.255.0 {
	range ${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.200 ${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.220;
	option broadcast-address ${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.255;
	option routers $ip_adr;
	option subnet-mask 255.255.255.0;
}" > /etc/dhcp/dhcpd.conf
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Установка пакета apache2			${NC}"
sudo apt-get install apache2 -y 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}5. Удаление станд. стр. index.html		${NC}"
sudo rm /var/www/html/index.html 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}6. Создание директории /www/*/astra		${NC}"
sudo mkdir -p /var/www/html/astra 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}7. Создание директории /tftp/pxelinux.cfg	${NC}"
sudo mkdir -p /srv/tftp/pxelinux.cfg 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------EFI-------------------------
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}8. Подготовка файлов EFI			${NC}"
sudo apt install grub-efi-amd64-bin -y 2>> $LOG_FILE 1>> $LOG_FILE
sudo mkdir -p /srv/tftp/debian-installer/amd64/grub 2>> $LOG_FILE 1>> $LOG_FILE
sudo grub-mknetdir --net-directory=/srv/tftp --subdir=/debian-installer/amd64/grub 2>> $LOG_FILE 1>> $LOG_FILE
sudo mkdir -p /srv/tftp/ce 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}9. AstraMode off - apache2			${NC}"
sudo sed -i 's/^#*# AstraMode on.*/AstraMode off/' /etc/apache2/apache2.conf 2>> $LOG_FILE 1>> $LOG_FILE
sudo sed -i 's/^#*AstraMode on.*/AstraMode off/' /etc/apache2/apache2.conf 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}10. Установка пакета tftpd-hpa			${NC}"
sudo apt-get install tftpd-hpa -y 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}11. Настройка tftpd-hpa				${NC}"
sudo echo "TFTP_USERNAME=\"tftp\"
TFTP_DIRECTORY=\"/srv/tftp\"
TFTP_ADDRESS=\"0.0.0.0:69\"
TFTP_OPTIONS=\"--secure --create\"" > /etc/default/tftpd-hpa
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}12. Установка пакета syslinux-common		${NC}"
sudo apt-get install syslinux-common 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}13. Копирование netinst				${NC}"
VALID="$(grep "^deb file://" "$FILE" | sed 's/^deb file:\/\///' | awk '{print $1}' | while read p; do [[ -f "$p/$TARGET" ]] && cp $p/netinst/* /srv/tftp/ -r 2>> $LOG_FILE 1>> $LOG_FILE && break; done)"
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}14. Копирование ldlinux.c32			${NC}"
VALID="$(grep "^deb file://" "$FILE" | sed 's/^deb file:\/\///' | awk '{print $1}' | while read p; do [[ -f "$p/$TARGET" ]] && cp $p/isolinux/ldlinux.c32 /srv/tftp/ -r 2>> $LOG_FILE 1>> $LOG_FILE && break; done)"
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}15. Копирование libcom32.c32			${NC}"
sudo cp /usr/lib/syslinux/modules/bios/libcom32.c32 /srv/tftp/ 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}16. Копирование libutil.c32			${NC}"
sudo cp /usr/lib/syslinux/modules/bios/libutil.c32 /srv/tftp/ 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}17. Копирование menu.c32			${NC}"
sudo cp /usr/lib/syslinux/modules/bios/menu.c32 /srv/tftp/ 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}18. Копирование vesamenu.c32			${NC}"
sudo cp /usr/lib/syslinux/modules/bios/vesamenu.c32 /srv/tftp/ 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}19. Создаем конфиг default			${NC}"
sudo echo "DEFAULT vesamenu.c32
PROMPT 0
TIMEOUT 50
MENU TITLE ASTRA Linux 1.7.5 PXE Boot Menu

MENU COLOR border       30;44   #40ffffff #a0000000 std
MENU COLOR title        1;36;44 #9033ccff #a0000000 std
MENU COLOR sel          7;37;40 #e0ffffff #20ffffff all
MENU COLOR unsel        37;44   #50ffffff #a0000000 std
MENU COLOR help         37;40   #c0ffffff #a0000000 std

LABEL astra_x86_http
    MENU LABEL ^1. ASTRA Linux 1.7.5 x86-64 (HTTP Install)
    KERNEL linux
    APPEND initrd=initrd.gz auto=true priority=critical debian-installer/locale=ru_RU astra-license/license=true url=http://$ip_adr/preseed.cfg interfaces=auto ipv6.disable=1 network-console/enable=false netcfg/dhcp_timeout=60

LABEL local
    MENU LABEL ^2. Boot from local drive
    LOCALBOOT 0
" > /srv/tftp/pxelinux.cfg/default
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------EFI-------------------------
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}20. Создаем конфиг grub.cfg			${NC}"
sudo echo "if loadfont \$prefix/fonts/unicode.pf2 ; then
  set gfxpayload=keep
  insmod efi_gop
  insmod efi_uga
  insmod video_bochs
  insmod video_cirrus
  insmod gfxterm
  insmod png
fi

if background_image /isolinux/splash.png; then
  set color_normal=light-gray/black
  set color_highlight=white/black
else
  set menu_color_normal=cyan/blue
  set menu_color_highlight=white/blue
fi

set timeout=5
insmod play
play 960 440 1 0 4 440 1

menuentry 'Установка Astra Linux SE 1.7' {

    linux   /ce/linux modprobe.blacklist=evbug auto=true priority=critical debian-installer/locale=ru console-keymaps-at/keymap=ru astra-install=1 hostname=astra domain=example.com astra-license/license=true url=tftp://$ip_adr/ce/preseed.cfg interface=auto
    initrd  /ce/initrd.gz
}
" > /srv/tftp/debian-installer/amd64/grub/grub.cfg
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------EFI-------------------------
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}21. Копирование vmlinuz				${NC}"
VALID="$(grep "^deb file://" "$FILE" | sed 's/^deb file:\/\///' | awk '{print $1}' | while read p; do [[ -f "$p/$TARGET" ]] && cp $p/install.amd/vmlinuz /srv/tftp/ce/ -r 2>> $LOG_FILE 1>> $LOG_FILE && break; done)"
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------EFI-------------------------
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}22. Копирование initrd.gz			${NC}"
VALID="$(grep "^deb file://" "$FILE" | sed 's/^deb file:\/\///' | awk '{print $1}' | while read p; do [[ -f "$p/$TARGET" ]] && cp $p/install.amd/initrd.gz /srv/tftp/ce/ -r 2>> $LOG_FILE 1>> $LOG_FILE && break; done)"
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ ОК ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}23. Копирование репозитория			${NC}"
VALID="$(grep "^deb file://" "$FILE" | sed 's/^deb file:\/\///' | awk '{print $1}' | while read p; do [[ -f "$p/$TARGET" ]] && cp $p/* /var/www/html/astra -r 2>> $LOG_FILE 1>> $LOG_FILE && break; done)"
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}24. Удаление старoй версии репозитория		${NC}"
#Здесь что то было, но теперь нету, поэтому все ОК
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}25. Обновление sources.list			${NC}"
echo "
deb file:///var/www/html/astra 1.7_x86-64 main contrib non-free" >> /etc/apt/sources.list
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}26. Обновление репозитория			${NC}"
sudo apt-get update 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}27. Конфигурация файла preseed.cfg		${NC}"
	echo "# Если вы выберете ftp, то mirror/country string устанавливать не нужно.
d-i mirror/protocol string http
d-i mirror/http/hostname string $ip_adr
d-i mirror/http/directory string /astra/
#------------------------------
# Выключить показ надоедливого диалога с WEP ключом.
d-i netcfg/wireless_wep string
#------------------------------
# настройка языка и страны согласно локали.
d-i mirror/country string manual
d-i debian-installer/locale string ru_RU
d-i debian-installer/locale select ru_RU.UTF-8
d-i debian-installer/language string ru
d-i debian-installer/country string RU
d-i debian-installer/keymap string ru
#------------------------------
# Выбор клавиатуры.
d-i console-tools/archs select at
d-i console-keymaps-at/keymap select ru
d-i console-setup/toggle string Alt+Shift
d-i console-setup/layoutcode string ru
d-i keyboard-configuration/toggle select Alt+Shift
d-i keyboard-configuration/layoutcode string ru
d-i keyboard-configuration/xkb-keymap select ru
d-i languagechooser/language-name-fb select Russian
d-i countrychooser/country-name select Russia
#------------------------------
# Настрйока сетевого интерфейса
d-i netcfg/enable boolean false
d-i netcfg/choose_interface select auto
d-i netcfg/dhcp_failed note
d-i netcfg/dhcp_options select Configure network manually
d-i netcfg/get_nameservers string $ip_adr
d-i netcfg/get_ipaddress string ${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.101
d-i netcfg/get_netmask string 255.255.255.0
d-i netcfg/get_gateway string $ip_adr
d-i netcfg netcfg/get_ipaddress string ${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.10
d-i netcfg/confirm_static boolean true
d-i netcfg/get_hostname string client1
d-i netcfg/get_hostname seen true
#------------------------------
# Выбор компонентов репозитория
d-i apt-setup/non-free boolean true
d-i apt-setup/contrib boolean true
d-i apt-setup/services-select none
#------------------------------
# Настройка часов
d-i clock-setup/utc boolean true
d-i time/zone string Europe/Moscow
d-i clock-setup/ntp boolean false
#------------------------------
# Разметка диска
#d-i partman-auto/init_automatically_partition \\
#     select Авто - использовать наибольшее свободное место
d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string regular
d-i partman-auto/purge_lvm_from_device boolean true
d-i partman-lvm/confirm boolean true
#------------------------------
#------------------------------
# Для режима legacy bios
d-i partman-auto/expert_recipe string myroot :: \\
        512 16384 512 ext2 \\
                \$primary{ } \$bootable{ } \\
                method{ format } format{ } use_filesystem{ } filesystem{ ext2 } mountpoint{ /boot } .\\
        8192 10000 1000000000 ext4 \\
                method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ / } .\\
        2048 16384 2048 ext4 \\
                method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /tmp } options/noexec{ noexec } options/nodev{ nodev } options/nosuid{ nosuid } .\\
        500 8192 -1 ext4 \\
                method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /home } .
d-i partman-auto/choose_recipe select myroot

# Для режима UEFI
# Автоматическая разметка
#d-i partman-auto/choose_recipe select /lib/partman/recipes-amd64-efi/30atomic
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
#d-i partman-auto/choose_recipe select atomic
d-i partman-auto-crypto/erase_disks boolean true
d-i partman-basicfilesystems/no_swap boolean false
d-i partman-target/mount_failed	boolean true
d-i partman-partitioning/unknown_label boolean true
d-i partman-auto/purge_lvm_from_device string true
d-i partman-lvm/vgdelete_confirm boolean true
d-i partman/confirm_write_new_label string true
d-i partman-lvm/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i base-installer/kernel/image string linux-image-generic
d-i passwd/make-user boolean true
#------------------------------
# Учетная запись и пароль пользоватедя
d-i passwd/root-login boolean true
d-i passwd/root-password password 12345678
d-i passwd/root-password-again password 12345678
# Учетная запись и пароль
d-i passwd/user-fullname string obi
d-i passwd/username string obi
d-i passwd/user-password password 12345678
d-i passwd/user-password-again password 12345678
d-i debian-installer/allow_unauthenticated string true
#------------------------------
# Выбор ПО для установки
tasksel tasksel/first multiselect Base packages, Fly desktop
tasksel tasksel/astra-feat-setup multiselect
#------------------------------
# Выбор уровня защищености ОС
d-i astra-additional-setup/os-check select Maximum security level Smolensk
#------------------------------
# Выбор парамтров ОС
d-i astra-additional-setup/additional-settings-smolensk multiselect Enable Mandatory Integrity Control, Enable Mandatory Access Control, Disable ptrace capability
tripwire tripwire/use-localkey boolean false
tripwire tripwire/use-sitekey boolean false
tripwire tripwire/installed note ok
portsentry portsentry/warn_no_block note ok
astra-license astra-license/license boolean true
krb5-config krb5-config/kerberos_servers string
libnss-ldapd libnss-ldapd/ldap-base string
libnss-ldapd libnss-ldapd/ldap-uris string
libnss-ldapd libnss-ldapd/nsswitch multiselect services
ald-client ald-client/make_config boolean false
ald-client ald-client/manual_configure false
astra-feat-setup astra-feat-setup/feat multiselect kiosk mode false
astra-feat-setup astra-feat-setup/feat multiselect Служба ALD false
d-i console-cyrillic/switch select \"Клавиша Menu\"
d-i console-cyrillic/toggle select Control+Shift
d-i samba-common/dhcp boolean false
d-i samba-common/workgroup string testgroup1
popularity-contest popularity-contest/participate boolean false
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
#------------------------------
# GRUB
d-i grub-installer/password password 12345678
d-i grub-installer/password-again password 12345678
grub-installer grub-installer/password-mismatch error
# Не показывать последнее сообщение о том, что установка завершена.
d-i finish-install/reboot_in_progress note
d-i finish-install/exit/poweroff boolean true

# запуска команд в целевой системе.
" > /var/www/html/preseed.cfg
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}28. Включение модуля rewrite			${NC}"
sudo a2enmod rewrite 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}29. Включение модуля headers			${NC}"
sudo a2enmod headers 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}30. Перезапуск apache2				${NC}"
sudo systemctl restart apache2 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}31. Автозапуск isc-dhcp-server			${NC}"
sudo systemctl enable isc-dhcp-server 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}32. Автозапуск tftpd-hpa			${NC}"
sudo systemctl enable tftpd-hpa 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}33. Автозапуск apache2				${NC}"
sudo systemctl enable apache2 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}34. Перезапуск isc-dhcp-server			${NC}"
sudo systemctl restart isc-dhcp-server 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}35. Перезапуск tftpd-hpa			${NC}"
sudo systemctl restart tftpd-hpa 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}36. Перезапуск apache2				${NC}"
sudo systemctl restart apache2 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}37. Обновление прав 755 /preseed.cfg		${NC}"
sudo chmod 755 /var/www/html/preseed.cfg 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------EFI-------------------------
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}38. Обновление прав 755 /debian-installer	${NC}"
sudo chmod -R 755 /srv/tftp/debian-installer 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ ОК ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------EFI-------------------------
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}39. Обновление прав 644 vmlinuz			${NC}"
sudo chmod 644 /srv/tftp/ce/vmlinuz 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ ОК ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------EFI-------------------------
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}40. Обновление прав 644 initrd.gz		${NC}"
sudo chmod 644 /srv/tftp/ce/initrd.gz 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ ОК ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}41. Разрешение порта 80/tcp			${NC}"
sudo ufw allow 80/tcp 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}42. Разрешение порта 69/udp			${NC}"
sudo ufw allow 69/udp 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}43. Разрешение порта 67/udp			${NC}"
sudo ufw allow 67/udp 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#--------------------------------------------------------
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
#									NFS
#===========================================================================
opti_7_rem(){
clear
sudo touch options_install_log$(date +%d-%m-%Y).log
	chmod 777 options_install_log$(date +%d-%m-%Y).log
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Удаление NFS:$(date +"$DATE_FORMAT")" >> $LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE

	SHARED_DIR="/srv/nfs/shared"
	MOUNT_POINT="/network_disk"
echo -e "${RED}${BOLD}Вы уверенны что хотите удалить NFS?${NC}"
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
echo -e -n "${RED}${BOLD}УДАЛЕНИЕ NFS 			${NC}"
	#sudo rm -r $SHARED_DIR 2>> $LOG_FILE 1>> $LOG_FILE

	sudo sed -i "\|$MOUNT_POINT|d" /etc/fstab 2>> $LOG_FILE 1>> $LOG_FILE
	sudo apt purge -y nfs-kernel-server 2>> $LOG_FILE 1>> $LOG_FILE
	sudo apt purge -y nfs-common 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e "${YELLOW}${BOLD}----------------------------------------------------------------------------"
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}

#===========================================================================
opti_7_svr(){
clear
sudo touch options_install_log$(date +%d-%m-%Y).log
	chmod 777 options_install_log$(date +%d-%m-%Y).log
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка NFS server:$(date +"$DATE_FORMAT")" >> $LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	IFS='.' read -r -a ip_parts <<< "$ip_adr"
	PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.0/24"

	SHARED_DIR="/srv/nfs/shared"


echo -e "${GREEN}${BOLD}Настройка Network File Sever (Серверная часть)${NC}"
echo -e -n "${YELLOW}${BOLD}Использовать для разграничение доступа эту подсеть ${GREEN}${BOLD}[$PREFIX] ${YELLOW}${BOLD}(Y/n): "
read op_1
if [ -z $op_1 ]; then
    op_1=y
fi
#------------------------------------------------------------
if [ $op_1 = "y" ] || [ $op_1 = "Y" ]; then
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
else
echo -e -n "${YELLOW}${BOLD}Укажите подсеть вручную (например, ${GREEN}${BOLD}192.168.1.0/24${YELLOW}${BOLD}): "
read PREFIX
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Установка пакет nfs-kernel-server		${NC}"
	sudo apt install nfs-kernel-server -y 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Создание общей директории: ${GREEN}$SHARED_DIR	${NC}"
	sudo mkdir -p "$SHARED_DIR" 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD} 2.1. Настройка владельца: ${GREEN}nobody:nogroup	${NC}"
	sudo chown nobody:nogroup "$SHARED_DIR" 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD} 2.2. Настройка прав доступа: ${GREEN}777		${NC}"
	sudo chmod 777 "$SHARED_DIR" 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Настройка доступа для сети: ${GREEN}$PREFIX	${NC}"
	sudo sed -i "\|$SHARED_DIR|d" /etc/exports 2>> $LOG_FILE 1>> $LOG_FILE
	sudo echo "$SHARED_DIR	$PREFIX(rw,sync,no_subtree_check)" >> /etc/exports
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Применение настроек				${NC}"
	sudo exportfs -a 2>> $LOG_FILE 1>> $LOG_FILE
	sudo systemctl restart nfs-kernel-server 2>> $LOG_FILE 1>> $LOG_FILE
	sudo systemctl enable nfs-kernel-server 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e "${YELLOW}${BOLD}----------------------------------------------------------------------------"
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
opti_7_cli(){
clear
sudo touch options_install_log$(date +%d-%m-%Y).log
	chmod 777 options_install_log$(date +%d-%m-%Y).log
	LOG_FILE="options_install_log$(date +%d-%m-%Y).log"
	DATE_FORMAT="%d-%m-%Y %H:%M:%S"
	echo "#===========================================================================" >> $LOG_FILE
	echo "Установка NFS client:$(date +"$DATE_FORMAT")" >> $LOG_FILE
	echo "#===========================================================================" >> $LOG_FILE
	ip_adr=`ifconfig | grep inet | head -1 | sed 's/\:/ /' | awk '{print $2}'`
	IFS='.' read -r -a ip_parts <<< "$ip_adr"
	PREFIX="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.0/24"

	SHARED_DIR="/srv/nfs/shared"
	MOUNT_POINT="/network_disk"

echo -e "${GREEN}${BOLD}Настройка Network File Sever (Клиентская часть)${NC}"
echo -e -n "${YELLOW}${BOLD}Введите IP-ADDRESS сервера NFS ${GREEN}${BOLD}: "
read serv_1
read -p "Нажимет ENTER, если хотите продолжить... CTRL-C для отмены"
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}1. Установка пакет nfs-common			${NC}"
	sudo apt install nfs-common -y 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}2. Cоздание директории подключения $MOUNT_POINT${NC}"
	sudo mkdir "$MOUNT_POINT" 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}3. Настройка fstab				${NC}"
	sudo sed -i "\|$MOUNT_POINT|d" /etc/fstab 2>> $LOG_FILE 1>> $LOG_FILE
	sudo echo "$serv_1:$SHARED_DIR	$MOUNT_POINT nfs defaults,_netdev,x-systemd.automount,x-systemd.requires=network-online.target	0	0" >> /etc/fstab
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e -n "${YELLOW}${BOLD}4. Применение настроек				${NC}"
	sudo mount -a 2>> $LOG_FILE 1>> $LOG_FILE
	sudo systemctl daemon-reload 2>> $LOG_FILE 1>> $LOG_FILE
if [ $? -eq 0 ]; then
	    echo -e "${GREEN}${BOLD}[ OK ]${NC}"
	else
	    echo -e "${RED}${BOLD}[ ОТКАЗ ]${NC}"
fi
#----------------------------------------------------------------------------
echo -e "${YELLOW}${BOLD}----------------------------------------------------------------------------"
echo -e "${GREEN}${BOLD}======================${NC}"
echo -e "${GREEN}${BOLD}ОПЕРАЦИЯ ЗАВЕРШЕНА${NC}"
echo -e "${GREEN}${BOLD}======================${NC}"
read -p "Нажмите Enter, чтобы вернуться в меню..." -n 1 -r
show_menu
}
#===========================================================================
#						КОНЕЦ РАЗДЕЛА ASTRA-OPTI
#===========================================================================

#===========================================================================
show_menu #Основная команда для запуска начального меню, не трогать!
#===========================================================================
