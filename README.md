Thanks to www.kenney.nl for sprites

# Running

Requires `ruby 2.6.1`, `bundler`, and `MongoDB`

1. Make sure Ruby is installed and running. You can download ruby from [ruby-lang.org](https://www.ruby-lang.org/en/)
2. Make sure bundler is installed

```gem install bundler```

3. Make sure MongoDB is installed. You can download MongoDB from [Mongodb.com](https://www.mongodb.com/download-center)

## GameServer

1. Please make sure to have MongoDB installed and running at `localhost:27017` (uses default `admin` and password)
2. Run rails execution from `./GameServer`

```bundle exec rails s```

3. browse to `http://0.0.0.0:3000`

## GameClient

1. Please make sure Ruby is installed and version `2.6.1`
2. Change directory to `./GameClient`
3. If running locally, change main.rb `GlobalConfig.config.url` to `http://0.0.0.0:3000`
4. Run bundle execution

```bundle exec ruby main.rb```

5. Play!
6. Check your scores at `http://0.0.0.0:3000`

# 実行方法

`ruby 2.6.1`, `bundler`, `MongoDB`は必要

1. Rubyをインストールしたのを確認して。 [ruby-lang.org](https://www.ruby-lang.org/en/)からダウンロードできます。
2. bundlerはインストールしたのを確認して

```gem install bundler```

3. MongoDBはインストールしたのを確認して。[Mongodb.com](https://www.mongodb.com/download-center)からダウンロードできます。

## GameServer

1. MongoDBをインストールして、`localhost:27017`で実行しているのを確認して　（規定な`admin`とパソワードを利用しています）
2. `./GameServer`からrailsのサーバーを実行して

```bundle exec rails s```

3. `http://0.0.0.0:3000`にブラウズして

## GameClient

1. Rubyがインストールした事、バージョンは`2.6.1`を確認して
2. `./GameClient`にディレクトリを変更して
3. ロカル環境で実行したら、`main.rb`の`Globalconfig.config.url`を`http://0.0.0.0:3000`に変更して
3. バンドルを実行して

```bundle exec ruby main.rb```

4. 遊んで！
5. `http://0.0.0.0:3000`でスコアを確認できる
