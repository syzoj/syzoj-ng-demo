# SYZOJ NG Demo

Here is a simple dockerized SYZOJ NG. Everything is done with the simple and stupid way.

This is only for demo. Do NOT use it on production. I'll publish a dockerized production version when appropriate.

```bash
docker run --name=demo \
           # You can mount data directories to access outside
           # But you need a copy of mysql's initial data directory of this image
           # --rm \
           # -v /root/data/minio:/root/minio-data \
           # -v /root/data/mysql:/var/lib/mysql \
           # -v /root/data/redis:/var/lib/redis \
           -e ENV=production \
           # (Optional) by default "SYZOJ"
           -e SITE_NAME="<your site name here>" \
           # (Optional) by default SYZOJ logo
           -e APP_LOGO="https://your.logo.url/logo.png_or.svg" \
           # The frontend URL you'll access it
           # It should be the same in Nginx
           -e FRONTEND=https://demo.syzoj.org \
           # It should be accessable by user and proxy_pass-ed to http://container_ip:2003
           # with http "Host" header set to 127.0.0.1:2003.
           -e MINIO_ENDPOINT_USER=https://demo.syzoj.org/minio \
           # It should be accessable by judge clients and proxy_pass-ed to http://container_ip:2003
           # with http "Host" header set to 127.0.0.1:2003.
           -e MINIO_ENDPOINT_JUDGE=https://demo.syzoj.org/minio \
           # If you are caring about the demo site's security, use secure keys
           -e MINIO_ACCESS_KEY=minioadmin \
           -e MINIO_SECRET_KEY=this_is_secret \
           # Your login user to the demo website
           -e ADMIN_USERNAME=yourusername \
           -e ADMIN_EMAIL=your@email.com \
           -e ADMIN_PASSWORD=yourpassword \
           # The email address for mailing (for registering verification and resetting password)
           -e MAIL_ADDRESS=no-reply@demo.syzoj.org \
           -e MAIL_TRANSPORT=smtps://user:pass@smtp.server \
           # The prebuilt image (or the image you built yourself)
           menci/syzoj-ng-demo
```

For more environment variables see the make config part in `start.sh`.

```nginx
map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
}

server {
        server_name demo.syzoj.org;
        listen 80;

        # listen 443 ssl;
        # SSL configuration here

        # For MinIO
        ignore_invalid_headers off;
        client_max_body_size 0;
        proxy_buffering off;

        # Frontend
        location / {
                proxy_read_timeout 300s;
                proxy_send_timeout 300s;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                proxy_set_header Accept-Encoding "";

                # There're some configuable items for frontend. See syzoj-ng-app's docs.
                # For, example:
                # sub_filter '__default_title__'    '"<your site name here>"';
                # sub_filter_once on;

                add_header Access-Control-Allow-Origin "https://demo.syzoj.org";

                # 172.20.0.2 is your docker container's IP. Same for below.
                proxy_pass http://172.20.0.2:2001;
        }

        # Backend
        location ~ (api|docs|docs-json) {
                proxy_read_timeout 300s;
                proxy_send_timeout 300s;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

                proxy_pass http://172.20.0.2:2002;
        }

        # MinIO
        location /minio/ {
                proxy_set_header Host "127.0.0.1:2003"; # This is important
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_connect_timeout 300;
                proxy_http_version 1.1;
                proxy_set_header Connection "";
                chunked_transfer_encoding off;

                proxy_pass http://172.20.0.2:2003/;
        }
}
```

For adavnced usages please see [syzoj-ng](https://github.com/syzoj/syzoj-ng) and [syzoj-ng-app](https://github.com/syzoj/syzoj-ng-app)'s docs.

Now you can login into your demo site with your admin account. Click the **server icon** on the footer of the page to go to "Judge Machine" management page. Add a judge machine and get its key with clicking the **key** icon. Then deploy [syzoj-ng-judge](https://github.com/syzoj/syzoj-ng-judge) with the key.
