FROM ubuntu:bionic

SHELL ["/bin/bash", "-c"]
RUN \
    # Configure APT
    sed -i 's#archive.ubuntu.com#mirrors.tuna.tsinghua.edu.cn#g' /etc/apt/sources.list && \
    sed -i 's#ports.ubuntu.com#mirrors.tuna.tsinghua.edu.cn#g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y curl git vim build-essential && \
    echo "deb [arch=amd64,arm64,ppc64el] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.4/ubuntu bionic main" > /etc/apt/sources.list.d/mariadb.list && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    echo "deb https://deb.nodesource.com/node_13.x bionic main" > /etc/apt/sources.list.d/nodesource.list && \
    curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xF1656F24C74CD1D8' | apt-key add && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    # Install packages
    apt-get update && \
    apt-get install -y mariadb-server nodejs yarn && \
    yarn global add serve
RUN \
    # Download MinIO
    cd && \
    ([[ $(uname -m) == "aarch64" ]] && curl https://dl.min.io/server/minio/release/linux-arm64/minio -o minio || true) && \
    ([[ $(uname -m) == "x86_64" ]] && curl https://dl.min.io/server/minio/release/linux-amd64/minio -o minio || true) && \
    ([[ $(uname -m) == "aarch64" ]] && curl https://dl.min.io/client/mc/release/linux-arm64/mc -o mc || true) && \
    ([[ $(uname -m) == "x86_64" ]] && curl https://dl.min.io/client/mc/release/linux-amd64/mc -o mc || true) && \
    chmod +x minio mc && \
    mkdir minio-data
RUN \
    # Download code
    cd && \
    git clone https://github.com/syzoj/syzoj-ng && \
    git clone https://github.com/syzoj/syzoj-ng-app && \
    git clone https://github.com/syzoj/syzoj-ng-demo && \
    # Install NPM packages
    cd ~/syzoj-ng && yarn && \
    cd ~/syzoj-ng-app && yarn && \
    # Create database
    cd ~/syzoj-ng-demo && \
    bash -c "mysqld_safe &" && \
    while ! mysqladmin ping --silent; do sleep 1; done && \
    echo 'CREATE DATABASE `syzoj-ng` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; GRANT ALL PRIVILEGES ON `syzoj-ng`.* TO "syzoj-ng"@"localhost" IDENTIFIED BY "syzoj-ng";' | mysql && \
    mysql syzoj-ng < demo.sql

CMD cd /root/syzoj-ng-demo && git pull && bash start.sh
