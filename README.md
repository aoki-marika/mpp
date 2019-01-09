# MPP (Madokami++)
A third party API for [Madokami](https://manga.madokami.al/) that aims to extend functionality and make a more tailored experience.

## Dependencies
* `sinatra`
* `sqlite3`
* `sequel`

## Running
* Development:

```
git clone https://github.com/aoki-marika/mpp
cd mpp
bundle install
sequel -e development config/database.yml -m db/migrations
rackup
```

* Production:

```
git clone https://github.com/aoki-marika/mpp
cd mpp
bundle install
sequel -e production config/database.yml -m db/migrations
rackup -E production
```
