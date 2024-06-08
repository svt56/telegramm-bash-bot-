# telegramm-bash-bot-
telegram bash is a feedback bot.
##
All messages are written to the "log" table database "bot.bd" (sqlite3). The person who wrote receives a response that the message has been accepted, the newsletter is sent to the users specified in the "tbl" table of the database "bot.bd ". It is planned to send messages to users by keywords that will be in the "tlg" table.
the token is stored in the ttk file.
## Schema database "bot.bd"
> CREATE TABLE prava <br />
(<br />
id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,<br />
tlg INTEGER,<br />
admin INTEGER<br />
);<br />
##
> CREATE TABLE log<br />
(<br />
message_id INTEGER NOT NULL PRIMARY KEY,<br />
from_id INTEGER,<br />
from_user TEXT,<br />
first_name TEXT,<br />
is_bot TEXT,<br />
language_code TEXT,<br />
datte INTEGER,<br />
daate TEXT,<br />
tiime TEXT,<br />
message TEXT,<br />
photo TEXT,<br />
photo_unique_id  TEXT,<br />
latitude TEXT,<br />
longitude TEXT,<br />
document_file_name  TEXT,<br />
document_mime_type   TEXT,<br />
document_file_id      TEXT,<br />
document_file_unique_id   TEXT,<br />
document_file_size         INTEGER<br />
<br />);<br />
