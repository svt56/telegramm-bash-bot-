#!/bin/bash
token=$(cat ttk) #токен харинтся в файле ttk
url="https://api.telegram.org/bot$token/sendMessage"
#функция получения списка получателей сообщений
function admin {
# Выполняем запрос в БД и сохраняем результат в массив
  mapfile -t id < <(sqlite3 bot.bd "SELECT tlg from prava where admin=1")
}
#схема базы данных tlg
#CREATE TABLE prava
#(
#id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
#tlg INTEGER,
#admin INTEGER
#);
# Функция отправки сообщения ВСЕМ администраторам
function sendtlg {
 admin #получаем список получателей сообщений
if [ -z "$2" ]
   then
   for i in ${!id[@]};do
   curl -s -X POST $url -d chat_id=${id[$i]} -d text="$1" # указать если нужен запрет пересыла сообщений от бота -d protect_content="1"
   done
else
   for i in ${!id[@]};do
   curl -s -X POST $url -d chat_id=${id[$i]} -d text="$1" -d reply_to_message_id="$2" # указать если нужен запрет пересыла сообщений от бота -d protect_content="1"
   done
fi
}
# Функция отправки сообщения обратившемуся
function send_a {
curl -s -X POST $url -d chat_id="$2" -d text="$1" -d protect_content="1" -d reply_to_message_id="$3"
}


#Функция записи данных в базу
function writelog {
#Получение значений для ввода в базу данных
 sends=$(curl -s https://api.telegram.org/bot$token/getUpdates?offset={-1})
 message_id=$(echo $sends | jq .result[].message.message_id)
 from_id=$(echo $sends | jq .result[].message.from.id)
 from_user=$(echo $sends | jq .result[].message.from.username)
  if [[ "$from_user" = "null" ]]; then from_user=0; fi
 first_name=$(echo $sends | jq .result[].message.from.first_name)
 is_bot=$(echo $sends | jq .result[].message.from.is_bot)
 language_code=$(echo $sends | jq .result[].message.from.language_code)
 datte=$(echo $sends | jq .result[].message.date)
 daate=$(date +"%Y-%m-%d" -d @$(echo $sends | jq .result[].message.date))
 tiime=$(date +"%H:%M:%S" -d @$(echo $sends | jq .result[].message.date))
 message=$(echo $sends | jq .result[].message.text)
    message=${message:1}
    message=${message::-1}
 photo=$(echo $sends | jq .result[].message.photo[-1].file_id)
  if [[ "$photo" = "null" ]]; then photo=0; fi
 photo_unique_id=$(echo $sends | jq .result[].message.photo[-1].file_unique_id)
  if [[ "$photo_unique_id" = "null" ]]; then photo_unique_id=0; fi
 latitude=$(echo $sends | jq .result[].message.location.latitude)
  if [[ "$latitude" = "null" ]]; then latitude=0; fi
 longitude=$(echo $sends | jq .result[].message.location.longitude)
  if [[ "$longitude" = "null" ]]; then longitude=0; fi
 document_file_name=$(echo $sends | jq .result[].message.document.file_name)
  if [[ "$document_file_name" = "null" ]]; then document_file_name=0; fi
 document_mime_type=$(echo $sends | jq .result[].message.document.mime_type)
  if [[ "$document_mime_type" = "null" ]]; then document_mime_type=0; fi
 document_file_id=$(echo $sends | jq .result[].message.document.file_id)
  if [[ "$document_file_id" = "null" ]]; then document_file_id=0; fi
 document_file_unique_id=$(echo $sends | jq .result[].message.document.file_unique_id)
  if [[ "$document_file_unique_id" = "null" ]]; then document_file_unique_id=0; fi
 document_file_size=$(echo $sends | jq .result[].message.document.mime_file_size)
  if [[ "$document_file_size" = "null" ]]; then document_file_size=0; fi
 jsonn=${sends//\"/|}
#Вводим данные в БД
sqlite3 bot.bd "INSERT INTO log VALUES ("$message_id", "$from_id", "$from_user", "$first_name", "$is_bot", "$language_code", \
 "$datte", \"${daate}\", \"${tiime}\", \"${message}\", "$photo", "$photo_unique_id",  "$latitude", "$longitude", \
\"${document_file_name}\", \"${document_mime_type}\",  "$document_file_id", "$document_file_unique_id", "$document_file_size");"
#Схема базы данных
#CREATE TABLE log
#(
#message_id INTEGER NOT NULL PRIMARY KEY,
#from_id INTEGER,
#from_user TEXT,
#first_name TEXT,
#is_bot TEXT,
#language_code TEXT,
#datte INTEGER,
#daate TEXT,
#tiime TEXT,
#message TEXT,
#photo TEXT,
#photo_unique_id  TEXT,
#latitude TEXT,
#longitude TEXT,
#document_file_name  TEXT,
#document_mime_type   TEXT,
#document_file_id      TEXT,
#document_file_unique_id   TEXT,
#document_file_size         INTEGER
#);
}
#Функция обработки нового сообщения
function new_mess {
         writelog
#Обработка спецальных команд
case "$message" in
  "/start")
    send_a "Привет" $from_id $message_id
    return
    ;;
esac
#Ответ на принятое сообщение
    send_a "принято" $from_id $message_id
      if [[ "$from_user" = "0" ]]; then from_user="не указано"; fi
      from_user=${from_user:1}; from_user=${from_user::-1}
#Обработка сообщения
#Отправить сообщения согласно словаря
#Получаем словарь для каждого пользователя
declare -A filtr
admin
num_rows=${!id[@]}
mapfile -t id < <(sqlite3 bot.bd "SELECT filtr from prava where admin=${id[$i]}")

num_columns=${!id[@]}
for ((i=1;i<=num_rows;i++)) do
    for ((j=1;j<=num_columns;j++)) do
        filtr[$i,$j]=$RANDOM
    done
done
#Отправить сообщение всем администраторам
#sendtlg "Получено%20сообщение%20от%20$first_name%20(id%20$from_id%20,%20username @$from_user),%20содеражние:%0A$message"
}

#получаем номер последнего сообщения
OFFSET=$(curl -s https://api.telegram.org/bot$token/getUpdates?offset={-1} | jq .result[].message.message_id)

#проверяем наличие нового сообщения
while true
 do
  sleep 2
  message_id=$(curl -s https://api.telegram.org/bot$token/getUpdates?offset={-1} | jq .result[].message.message_id)
  if [ ! $message_id == $OFFSET ]
   then
    #Получаем сообщение
    new_mess
    OFFSET=$message_id
  fi
done
