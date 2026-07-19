# Bookers2

## 1. アプリ概要

読んだ本の感想やタグを投稿・共有できる、SNS要素を備えた読書記録アプリです。本の投稿・お気に入り・コメントに加え、ユーザー同士のフォロー機能やグループ機能、相互フォロー限定のメッセージ機能を備えています。

## 2. 主な機能一覧

- ユーザー登録・ログイン・ログアウト（`has_secure_password` によるパスワード認証）
- パスワードリセット（メール経由のトークン再設定）
- ユーザープロフィール編集・プロフィール画像アップロード
- ユーザーマイページ（投稿冊数の日別グラフ表示、日付選択による内訳確認）
- 本の投稿・編集・削除・詳細表示
- 本の評価スコア（score）登録・スコア順/新着順/週間お気に入り数順での並び替え
- 本の閲覧数カウント（View）
- 本のお気に入り登録・解除（Favorite）
- 週間お気に入りランキング表示
- 本へのコメント投稿・削除
- タグ付け（新規タグの自動作成含む）
- 本のタイトル／ユーザー名／タグ名によるキーワード検索（完全一致・前方一致・後方一致・部分一致）
- ユーザーフォロー・アンフォロー機能
- フォロー中一覧・フォロワー一覧表示
- 相互フォロー間のダイレクトメッセージ機能（1対1の会話表示・送信）
- グループ作成・編集・削除
- グループへの参加・退会
- グループオーナー権限の管理（オーナーは退会不可、オーナー譲渡機能あり）
- グループメンバーへの一斉メール送信
- グループ画像アップロード（未設定時はデフォルト画像を自動添付）

## 3. 使用技術

- **Ruby**: 3.3.6
- **Rails**: 8.0.5系
- **データベース**: SQLite3
- **主要gem**
  - `bcrypt` （パスワードハッシュ化）
  - `image_processing` （Active Storage画像バリアント生成）
  - `solid_cache` / `solid_queue` / `solid_cable` （DBベースのキャッシュ・ジョブ・Action Cable）
  - `turbo-rails` / `stimulus-rails` （Hotwire）
  - `importmap-rails` （JavaScriptのESM importmap管理）
  - `jbuilder` （JSON API構築）
  - `net-smtp` （メール送信）
  - `dotenv-rails` （開発・テスト環境の環境変数管理）
  - `kamal` （Dockerコンテナデプロイ）
  - 開発・テスト: `rspec-rails`, `factory_bot_rails`, `faker`, `capybara`, `brakeman`, `rubocop-rails-omakase`, `web-console`, `debug`
- **フロントエンド**
  - Bootstrap 5.3.0（CDN読み込み）
  - Chart.js 4.5.0（CDN読み込み、投稿冊数グラフ表示）
  - Hotwire（Turbo Streams / Turbo Drive、Stimulusコントローラ）
  - raty-js（星評価UI、importmap経由でpin）

## 4. セットアップ手順

```bash
# 1. リポジトリをクローン
git clone <このリポジトリのURL>
cd bookers2

# 2. Rubyのバージョンを合わせる（rbenv等を利用している場合）
rbenv install 3.3.6   # 未インストールの場合
rbenv local 3.3.6

# 3. 依存gemのインストール
bundle install

# 4. 環境変数ファイルの準備（詳細は「5. 環境変数の設定について」を参照）
touch .env
# .env に、以下の内容を追記してください
# GMAIL_USER_NAME=あなたのGmailアドレス
# GMAIL_PASSWORD=Googleアプリパスワード(16桁)

# 5. データベースの作成・マイグレーション
bin/rails db:create
bin/rails db:migrate

# 6. サーバーの起動
bin/rails server
# http://localhost:3000 にアクセス
```

テストを実行する場合:

```bash
bundle exec rspec
```

## 5. 環境変数の設定について

`.env`（`dotenv-rails` により開発・テスト環境で読み込み）で以下の環境変数を管理しています。値は各自のものを設定してください（実際の値はリポジトリに含めていません）。

| 変数名 | 用途 |
|---|---|
| `GMAIL_USER_NAME` | パスワードリセットメールやグループ一斉送信メールの送信に使用するGmailアカウントのユーザー名（アドレス） |
| `GMAIL_PASSWORD` | 上記Gmailアカウントの認証に使用するパスワード（Googleアプリパスワードの利用を推奨） |

これらは `config/environments/development.rb` の `config.action_mailer.smtp_settings` で読み込まれ、SMTP（`smtp.gmail.com:587`）経由でのメール送信に利用されます。本番環境ではRails credentials（`config/credentials.yml.enc`）やKamalのsecrets管理など、`.env` 以外の方法での管理を推奨します。

## 6. ER図（モデルの関連図）

```
User
 ├─ has_many :books                        (1人のユーザーは複数の本を投稿)
 ├─ has_many :favorites                    (お気に入り)
 ├─ has_many :book_comments                (本へのコメント)
 ├─ has_many :sessions                     (ログインセッション)
 ├─ has_many :active_relationships / following   (フォローしている relationships / users)
 ├─ has_many :passive_relationships / followers  (フォローされている relationships / users)
 ├─ has_many :sent_messages / received_message   (送受信メッセージ)
 ├─ has_many :owned_groups                 (オーナーのグループ)
 ├─ has_many :group_users → groups         (参加しているグループ)
 └─ has_one_attached :profile_image

Book
 ├─ belongs_to :user
 ├─ belongs_to :tag (optional)
 ├─ has_many :favorites
 ├─ has_many :book_comments
 └─ has_many :views

Favorite
 ├─ belongs_to :user
 └─ belongs_to :book

BookComment
 ├─ belongs_to :user
 └─ belongs_to :book

View
 └─ belongs_to :book

Tag
 └─ has_many :books

Relationship（フォロー関係の中間テーブル）
 ├─ belongs_to :follower  (User)
 └─ belongs_to :followed  (User)

Message
 ├─ belongs_to :sender    (User)
 └─ belongs_to :recipient (User)
     ※相互フォロー関係にあるユーザー間のみ送信可能

Group
 ├─ belongs_to :owner (User)
 ├─ has_many :group_users → members (User)
 └─ has_one_attached :group_image

GroupUser（ユーザーとグループの中間テーブル）
 ├─ belongs_to :user
 └─ belongs_to :group

Session
 └─ belongs_to :user
```

関係の概要図:

```
User 1───N Book 1───N Favorite N───1 User
                 └──N BookComment N───1 User
                 └──N View

User N───N User            （Relationship: follower/followed によるフォロー関係）
User N───N User            （Message: sender/recipient、相互フォロー限定）
User N───N Group           （GroupUser 中間テーブル、Group.owner は User）
```
