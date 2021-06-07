#!/bin/bash

if [[ "$FRONTEND" == "" ]]; then
    echo "Please tell your frontend host (or IP:PORT) with -e FRONTEND. e.g. http://demo.syzoj.org"
    echo "This host should be proxy_pass-ed to container:2001."
    exit 1
fi

if [[ "$MINIO_ENDPOINT_USER" == "" || "$MINIO_ENDPOINT_JUDGE" == "" ]]; then
    echo "Please tell your MinIO endpoint for user and judge with -e MINIO_ENDPOINT_USER and -e MINIO_ENDPOINT_JUDGE"
    echo "The hosts should be proxy_pass-ed to http://container:2003 and the HTTP Host header should be '127.0.0.1:2003'."
    exit 1
fi

if [[ "$SITE_NAME" == "" ]]; then
    echo "Please tell your site name with -e SITE_NAME. e.g. Demo"
    exit 1
fi

if [[ "$ADMIN_USERNAME" == "" ]]; then
    echo "Please tell your admin username with -e ADMIN_USERNAME."
    exit 1
fi

if [[ "$ADMIN_EMAIL" == "" ]]; then
    echo "Please tell your admin email with -e ADMIN_EMAIL."
    exit 1
fi

if [[ "$ADMIN_PASSWORD" == "" ]]; then
    echo "Please tell your admin password with -e ADMIN_PASSWORD."
    exit 1
fi

if [[ "$MINIO_ACCESS_KEY" == "" ]]; then
    echo "Please tell your MinIO access key with -e MINIO_ACCESS_KEY."
    exit
fi

if [[ "$MINIO_SECRET_KEY" == "" ]]; then
    echo "Please tell your MinIO secret key with -e MINIO_SECRET_KEY."
    exit
fi

# Start MinIO
cd
./minio server ./minio-data --address :2003 &
while ! ./mc config host add minio http://127.0.0.1:2003 "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY"; do sleep 1; done
while ! ./mc mb -p minio/syzoj-ng-files; do sleep 1; done

# Start MySQL
mysqld_safe &
while ! mysqladmin ping --silent; do
    sleep 1
done

# Start Redis
redis-server --protected-mode no &
while ! redis-cli ping | grep PONG; do
    sleep 1
done

# Update
cd ~/syzoj-ng
while ! git fetch; do sleep 1; done
git reset --hard origin/master
yarn

if [ "$MAIL_TRANSPORT" = "" ]; then
	MAIL_ENABLED="false"
else
	MAIL_ENABLED="true"
fi

if [ "$TELEGRAM_BOT_TOKEN" = "" ]; then
	TELEGRAM_BOT_TOKEN="null"
fi

if [ "$TELEGRAM_SEND_TO" = "" ]; then
	TELEGRAM_SEND_TO="null"
fi

# Make config
cat > config.yaml <<EOF
server:
  hostname: 0.0.0.0
  port: 2002
  trustProxy: ["loopback", "linklocal", "uniquelocal"]
  clusters: 0
services:
  database:
    type: mariadb
    host: 127.0.0.1
    port: 3306
    username: syzoj-ng
    password: syzoj-ng
    database: syzoj-ng
  minio:
    endpoint: http://127.0.0.1:2003
    endpointForUser: "$MINIO_ENDPOINT_USER"
    endpointForJudge: "$MINIO_ENDPOINT_JUDGE"
    accessKey: "$MINIO_ACCESS_KEY"
    secretKey: "$MINIO_SECRET_KEY"
    bucket: syzoj-ng-files
  redis: redis://127.0.0.1:6379
  mail:
    address: "$MAIL_ADDRESS"
    transport: "$MAIL_TRANSPORT"
security:
  crossOrigin:
    enabled: true
    whiteList:
      - "$FRONTEND"
  sessionSecret: "$MINIO_SECRET_KEY"
  maintainceKey: "$(echo $(dd if=/dev/urandom | base64 -w0 | dd bs=1 count=20 2>/dev/null))"
  recaptcha:
    secretKey: ${RECAPTCHA_SECRET:=null}
    useRecaptchaNet: true
    proxyUrl: null
  rateLimit:
    maxRequests: 200
    durationSeconds: 10
preference:
  siteName: "$SITE_NAME"
  security:
    recaptchaEnabled: ${RECAPTCHA_ENABLED:=false}
    recaptchaKey: ${RECAPTCHA_KEY:=null}
    requireEmailVerification: $MAIL_ENABLED
    allowUserChangeUsername: true
    allowEveryoneCreateProblem: true
    allowNonPrivilegedUserEditPublicProblem: true
    allowOwnerManageProblemPermission: false
    allowOwnerDeleteProblem: true
    allowEveryoneCreateDiscussion: true
    discussionDefaultPublic: true
    discussionReplyDefaultPublic: true
  pagination:
    homepageUserList: 20
    homepageProblemList: 5
    problemSet: 50
    searchProblemsPreview: 7
    submissions: 10
    submissionStatistics: 10
    userList: 30
    userAuditLogs: 10
    discussions: 10
    searchDiscussionsPreview: 7
    discussionReplies: 40
    discussionRepliesHead: 20
    discussionRepliesMore: 20
  misc:
    appLogo: ${APP_LOGO:=default}
    googleAnalyticsId: ${GA_ID:=null}
    gravatarCdn: ${GRAVATAR_CDN:=https://gravatar.loli.net}
    redirectLegacyUrls: false
    legacyContestsEntryUrl: null
    homepageUserListOnMainView: true
    sortUserByRating: false
    renderMarkdownInUserBio: false
    discussionReactionEmojis: [👍, 👎, 😄, 😕, ❤️, 🤔, 🤣, 🌿, 🍋, 🕊️]
    discussionReactionAllowCustomEmojis: true
  serverSideOnly:
    discussionReactionCustomEmojisBlacklist: /(\uD83C[\uDDE6-\uDDFF]){2}/
resourceLimit:
  problemTestdataFiles: 40
  problemTestdataSize: 134217728
  problemAdditionalFileFiles: 40
  problemAdditionalFileSize: 134217728
  problemSamplesToRun: 10
  problemTestcases: 20
  problemTimeLimit: 2000
  problemMemoryLimit: 512
  submissionFileSize: 10485760
queryLimit:
  problemSet: 100
  submissions: 10
  submissionStatistics: 10
  searchUser: 10
  searchGroup: 10
  userList: 100
  userAuditLogs: 20
  discussions: 20
  discussionReplies: 50
judge:
  limit:
    compilerMessage: 524288
    outputSize: 104857600
    dataDisplay: 128
    dataDisplayForSubmitAnswer: 128
    stderrDisplay: 5120
eventReport:
  telegramBotToken: ${TELEGRAM_BOT_TOKEN:=null}
  telegramApiRoot: ${TELEGRAM_API_ROOT:=null}
  sentTo: ${TELEGRAM_SEND_TO:=null}
  proxyUrl: ${TELEGRAM_PROXY_URL:=null}
vendor:
  ip2region: null
EOF

# Setup admin user
HASHED_PASSWORD=$(mkfifo /tmp/admin-password; echo -n "$ADMIN_PASSWORD" > /tmp/admin-password & node -e "require('/root/syzoj-ng/node_modules/bcrypt').hash(fs.readFileSync('/tmp/admin-password').toString('utf-8'), 10).then(res => console.log(res))"; rm /tmp/admin-password)
mysql <<EOF
USE syzoj-ng;
UPDATE user SET username = '$ADMIN_USERNAME' WHERE id = 1;
UPDATE user SET email = '$ADMIN_EMAIL' WHERE id = 1;
UPDATE user_auth SET password = '$HASHED_PASSWORD' WHERE userId = 1;
EOF

# Start
NODE_ENV=production SYZOJ_NG_CONFIG_FILE=./config.yaml yarn start &

# Update
cd ~/syzoj-ng-app
while ! git fetch; do sleep 1; done
git reset --hard origin/master
yarn

# Start
yarn build
serve -s build -l tcp://0.0.0.0:2001
