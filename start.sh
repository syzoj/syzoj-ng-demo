#!/bin/bash

if [[ "$FRONTEND" == "" ]]; then
	echo "Please tell your frontend host (or IP:PORT) with -e FRONTEND. e.g. http://demo.syzoj.org"
	exit 1
fi

if [[ "$BACKEND" == "" ]]; then
	echo "Please tell your backend host (or IP:PORT) with -e BACKEND. e.g. http://demo.syzoj.org"
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

# Start MySQL
mysqld_safe &
while ! mysqladmin ping --silent; do
	sleep 1
done

# Determine whether to enable cross origin or not
CROSS_ORIGIN="true"
if [[ "$FRONTEND" == "$BACKEND" ]]; then
	CROSS_ORIGIN="false"
fi

# Update
cd ~/syzoj-ng
git pull
yarn

# Make config
cat > config.json <<EOF
{
    "server": {
        "hostname": "0.0.0.0",
        "port": 2002
    },
    "database": {
        "type": "mariadb",
        "host": "127.0.0.1",
        "port": 3306,
        "username": "syzoj-ng",
        "password": "syzoj-ng",
        "database": "syzoj-ng"
    },
    "security": {
        "crossOrigin": {
            "enabled": true,
            "whiteList": [
                "$FRONTEND"
            ]
        },
	"sessionSecret": "$(echo $(dd if=/dev/urandom | base64 -w0 | dd bs=1 count=20 2>/dev/null))"
    },
    "preference": {
        "allowUserChangeUsername": true
    },
    "queryLimit": {
        "problemSetProblemsTake": 100
    }
}
EOF

# Setup admin user
HASHED_PASSWORD=$(mkfifo /tmp/admin-password; echo -n "$ADMIN_PASSWORD" > /tmp/admin-password & node -e "require('/root/syzoj-ng/node_modules/bcrypt').hash(fs.readFileSync('/tmp/admin-password').toString('utf-8'), 10).then(res => console.log(res))"; rm /tmp/admin-password)
mysql <<EOF
USE syzoj-ng;
UPDATE user SET username = '$ADMIN_USERNAME' WHERE id = 1;
UPDATE user SET email = '$ADMIN_USERNAME' WHERE id = 1;
UPDATE user_auth SET password = '$HASHED_PASSWORD' WHERE userId = 1;
EOF

# Start
SYZOJ_NG_CONFIG_FILE=./config.json yarn start &

# Update
cd ~/syzoj-ng-app
git pull
yarn

# Make config
cat > config.json <<EOF
{
    "siteName": "$SITE_NAME",
    "apiEndpoint": "$BACKEND/api",
    "crossOrigin": $CROSS_ORIGIN
}
EOF

# Build and start
SYZOJ_NG_APP_CONFIG_FILE=./config.json yarn build
serve -s build -l tcp://0.0.0.0:2001
