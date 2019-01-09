# Madokami (rename pending)
A third party API for [Madokami](https://manga.madokami.al/).

## Dependencies
* `sinatra`
* `sqlite3`
* `sequel`

## Running
* Development:

```
git clone https://github.com/aoki-marika/madokami
cd madokami
bundle install
sequel -e development config/database.yml -m db/migrations
rackup
```

* Production:

```
git clone https://github.com/aoki-marika/madokami
cd madokami
bundle install
sequel -e production config/database.yml -m db/migrations
rackup -E production
```
