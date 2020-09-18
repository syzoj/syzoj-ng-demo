#!/bin/bash

if [[ "$FRONTEND" == "" ]]; then
    echo "Please tell your frontend host (or IP:PORT) with -e FRONTEND. e.g. http://demo.syzoj.org"
    echo "This host should be proxy_pass-ed to container:2001."
    exit 1
fi

if [[ "$BACKEND" == "" ]]; then
    echo "Please tell your backend host (or IP:PORT) with -e BACKEND. e.g. http://demo.syzoj.org"
    echo "This host should be proxy_pass-ed to container:2002."
    exit 1
fi

if [[ "$MINIO_ENDPOINT" == "" || "$MINIO_PORT" == "" || "$MINIO_SSL" == "" ]]; then
    echo "Please tell your MinIO host (or IP:PORT) with -e MINIO_ENDPOINT and -e MINIO_PORT."
    echo "The MINIO_ENDPOINT:MINIO_PORT should be proxy_pass-ed to container:2003."
    echo "MINIO_SSL is true means the MinIO endpoint is a HTTPS host, false means HTTP."
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

# Determine whether to enable cross origin or not
CROSS_ORIGIN="true"
if [[ "$FRONTEND" == "$BACKEND" ]]; then
    CROSS_ORIGIN="false"
fi

# Update
cd ~/syzoj-ng
git fetch
git reset --hard origin/master
yarn

if [ $MAIL_TRANSPORT = "" ]; then
	MAIL_ENABLED="false"
else
	MAIL_ENABLED="true"
fi

# Make config
cat > config.yaml <<EOF
server:
  hostname: 0.0.0.0
  port: 2002
  trustProxy: ["loopback", "linklocal", "uniquelocal"]
services:
  database:
    type: mariadb
    host: 127.0.0.1
    port: 3306
    username: syzoj-ng
    password: syzoj-ng
    database: syzoj-ng
  minio:
    endPoint: "$MINIO_ENDPOINT"
    port: $MINIO_PORT
    useSSL: $MINIO_SSL
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
  sessionSecret: "$(echo $(dd if=/dev/urandom | base64 -w0 | dd bs=1 count=20 2>/dev/null))"
  maintainceKey: "$(echo $(dd if=/dev/urandom | base64 -w0 | dd bs=1 count=20 2>/dev/null))"
preference:
  siteName: "$SITE_NAME"
  requireEmailVerification: $MAIL_ENABLED
  allowUserChangeUsername: true
  allowEveryoneCreateProblem: true
  allowNonAdminEditPublicProblem: true
  allowOwnerManageProblemPermission: false
  allowOwnerDeleteProblem: true
resourceLimit:
  problemTestdataFiles: 40
  problemTestdataSize: 134217728
  problemAdditionalFileFiles: 40
  problemAdditionalFileSize: 134217728
  problemTestcases: 20
  problemTimeLimit: 2000
  problemMemoryLimit: 512
  submissionFileSize: 10485760
queryLimit:
  problemSetProblemsTake: 100
  submissionsTake: 10
  submissionStatisticsTake: 10
  searchUserTake: 10
  searchGroupTake: 10
  userListUsersTake: 100
  userAuditLogsTake: 20
vendor:
  ip2region: /opt/ip2region/ip2region.db
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
SYZOJ_NG_CONFIG_FILE=./config.yaml yarn start &

# Update
cd ~/syzoj-ng-app
git fetch
git reset --hard origin/master
yarn

# Make config
cat > config.yaml <<EOF
siteName: "$SITE_NAME"
apiEndpoint: "$BACKEND"
crossOrigin: $CROSS_ORIGIN
EOF

# Start
if [[ "$ENV" == "production" ]]; then
	SYZOJ_NG_APP_CONFIG_FILE=./config.yaml GENERATE_SOURCEMAP=false yarn build
	serve -s build -l tcp://0.0.0.0:2001
else
	SYZOJ_NG_APP_CONFIG_FILE=./config.yaml yarn start
fi
