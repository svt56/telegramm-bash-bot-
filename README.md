# telegramm-bash-bot-
telegram bash is a feedback bot.
All messages are written to the "log" table database "bot.bd" (sqlite3). The person who wrote receives a response that the message has been accepted, the newsletter is sent to the users specified in the "tbl" table of the database "bot.bd ". It is planned to send messages to users by keywords that will be in the "tlg" table.
the token is stored in the ttk file.
Schema database "bot.bd"
CREATE TABLE prava
(
id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
tlg INTEGER,
admin INTEGER
);
CREATE TABLE log
(
message_id INTEGER NOT NULL PRIMARY KEY,
from_id INTEGER,
from_user TEXT,
first_name TEXT,
is_bot TEXT,
language_code TEXT,
datte INTEGER,
daate TEXT,
tiime TEXT,
message TEXT,
photo TEXT,
photo_unique_id  TEXT,
latitude TEXT,
longitude TEXT,
document_file_name  TEXT,
document_mime_type   TEXT,
document_file_id      TEXT,
document_file_unique_id   TEXT,
document_file_size         INTEGER
);
