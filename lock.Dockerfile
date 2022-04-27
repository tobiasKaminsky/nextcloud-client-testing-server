FROM ghcr.io/nextcloud/continuous-integration-shallow-server:latest

ENV EVAL=true

RUN BRANCH="master" /usr/local/bin/initnc.sh

RUN su www-data -c "OC_PASS=user1 php /var/www/html/occ user:add --password-from-env --display-name='User One' user1"
RUN su www-data -c "OC_PASS=user2 php /var/www/html/occ user:add --password-from-env --display-name='User Two' user2"
RUN su www-data -c "OC_PASS=user3 php /var/www/html/occ user:add --password-from-env --display-name='User Three' user3"
RUN su www-data -c "php /var/www/html/occ user:setting user2 files quota 1G"
RUN su www-data -c "php /var/www/html/occ group:add users"
RUN su www-data -c "php /var/www/html/occ group:adduser users user1"
RUN su www-data -c "php /var/www/html/occ group:adduser users user2"

RUN su www-data -c "git clone -b master https://github.com/nextcloud/text.git /var/www/html/apps/text/"
RUN su www-data -c "php /var/www/html/occ app:enable -f text"

RUN su www-data -c "git clone -b enh/collaborative-lock https://github.com/nextcloud/files_lock.git /var/www/html/apps/files_lock/"
RUN su www-data -c "php /var/www/html/occ app:enable -f files_lock"


ENTRYPOINT /usr/local/bin/run.sh