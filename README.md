# MPP (Madokami++)
A third party API for [Madokami](https://manga.madokami.al/) that aims to extend functionality and provide a more tailored experience.

## Dependencies
* `bundler`
* `sinatra`
* `sqlite3`
* `sequel`

## Running
`-E production` is optional and used for running in production mode.

```
git clone https://github.com/aoki-marika/mpp
cd mpp
bundle install
rackup [-E production]
```

## Importing metadata

* Download the latest dump from `Info/` on Madokami, extract it, and convert it using [mysql2sqlite](https://github.com/dumblob/mysql2sqlite).
* Place it in `db/madokami.sqlite`
* Delete any existing MPP database in `db/`.
* Run MPP.

The database will import once the MPP database is created.
