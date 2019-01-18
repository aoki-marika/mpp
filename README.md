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

* Make sure you've run MPP at least once so it can create the database.
* Download the latest dump from `Info/` on Madokami, extract it, and convert it using [mysql2sqlite](https://github.com/dumblob/mysql2sqlite).
* Run `ruby utils/config.rb /path/to/madokami.sqlite db/environment.sqlite`, `environment` being either `development` or `production`.
