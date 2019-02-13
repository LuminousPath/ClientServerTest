Thanks to www.kenney.nl for sprites

# Running

## GameServer

1. Please make sure to have MongoDB installed and running at `localhost:27017` (uses default `admin` and password)
2. Run rails execution from `./GameServer`
```bundle exec rails s```
3. browse to `http://0.0.0.0:3000`

## GameClient

1. Please make sure Rails is version `2.6.1`
2. Change directory to `./GameClient`
3. Run bundle execution
```bundle exec ruby main.rb```
4. Play!
5. Check your scores at `http://0.0.0.0:3000`

# やり方

## GameServer

1. MongoDBをインストールして、`localhost:27017`で実行しているのを確認して　（規定な`admin`とパソワードを利用しています）
2. `./GameServer`からrailsのサーバーを実行して

```bundle exec rails s```

3. `http://0.0.0.0:3000`にブラウズして

## GameClient

1. Railsのバージョンは`2.6.1`を確認して
2. `./GameClient`にディレクトリを変更して
3. バンドルを実行して

```bundle exec ruby main.rb```

4. 遊んで！
5. `http://0.0.0.0:3000`でスコアを確認できる
