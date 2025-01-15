FROM ghcr.io/nextcloud/continuous-integration-shallow-server:latest

ARG BRANCH="master"
ARG BRANCH_MAIN="main"

ENV EVAL=true

RUN BRANCH="$BRANCH" /usr/local/bin/initnc.sh

RUN apt-key adv --fetch-keys https://packages.sury.org/php/apt.gpg
RUN apt-get update && apt-get install -y composer

RUN mkdir /var/www/.nvm /var/www/.npm; touch /var/www/.bashrc; chown -R 33:33 /var/www/.nvm /var/www/.npm /var/www/.bashrc
RUN su www-data -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash"
RUN su www-data -c "source ~/.bashrc; nvm install node"
RUN /usr/local/bin/initnc.sh
RUN su www-data -c "php /var/www/html/occ log:manage --level warning"
RUN su www-data -c "OC_PASS=user1 php /var/www/html/occ user:add --password-from-env --display-name='User One' user1"
RUN su www-data -c "OC_PASS=user2 php /var/www/html/occ user:add --password-from-env --display-name='User Two' user2"
RUN su www-data -c "OC_PASS=user3 php /var/www/html/occ user:add --password-from-env --display-name='User Three' user3"
RUN su www-data -c "OC_PASS=test php /var/www/html/occ user:add --password-from-env --display-name='Test@Test' test@test"
RUN su www-data -c "OC_PASS=test php /var/www/html/occ user:add --password-from-env --display-name='Test Spaces' 'test test'"
RUN su www-data -c "php /var/www/html/occ user:setting user2 files quota 1G"
RUN su www-data -c "php /var/www/html/occ group:add users"
RUN su www-data -c "php /var/www/html/occ group:adduser users user1"
RUN su www-data -c "php /var/www/html/occ group:adduser users user2"
RUN su www-data -c "php /var/www/html/occ group:adduser users test"
RUN su www-data -c "git clone --depth 1 -b $BRANCH https://github.com/nextcloud/activity.git /var/www/html/apps/activity/"
RUN su www-data -c "php /var/www/html/occ app:enable activity"
RUN su www-data -c "git clone --depth 1 -b $BRANCH_MAIN https://github.com/nextcloud/text.git /var/www/html/apps/text/"
RUN su www-data -c "php /var/www/html/occ app:enable text"
RUN su www-data -c "git clone --depth 1 -b $BRANCH https://github.com/nextcloud/end_to_end_encryption/  /var/www/html/apps/end_to_end_encryption/"
RUN su www-data -c "php /var/www/html/occ app:enable end_to_end_encryption"
RUN su www-data -c "git clone --depth 1 -b $BRANCH https://github.com/nextcloud/password_policy/  /var/www/html/apps/password_policy/"
RUN su www-data -c "php /var/www/html/occ app:enable password_policy"
RUN su www-data -c "git clone --depth 1 -b $BRANCH https://github.com/nextcloud/external/  /var/www/html/apps/external/"
RUN su www-data -c "cd /var/www/html/apps/external; composer install --no-dev"
RUN su www-data -c "php /var/www/html/occ app:enable external"
RUN su www-data -c 'php /var/www/html/occ config:app:set external sites --value="{\"1\":{\"id\":1,\"name\":\"Nextcloud\",\"url\":\"https:\/\/www.nextcloud.com\",\"lang\":\"\",\"type\":\"link\",\"device\":\"\",\"icon\":\"external.svg\",\"groups\":[],\"redirect\":false},\"2\":{\"id\":2,\"name\":\"Forum\",\"url\":\"https:\/\/help.nextcloud.com\",\"lang\":\"\",\"type\":\"link\",\"device\":\"\",\"icon\":\"external.svg\",\"groups\":[],\"redirect\":false}}"'
RUN su www-data -c "git clone --depth 1 -b $BRANCH_MAIN https://github.com/nextcloud/files_lock.git /var/www/html/apps/files_lock/"
RUN su www-data -c "php /var/www/html/occ app:enable -f files_lock"
RUN su www-data -c "git clone --depth 1 -b $BRANCH https://github.com/nextcloud/groupfolders.git /var/www/html/apps/groupfolders/"
RUN su www-data -c "php /var/www/html/occ app:enable -f groupfolders"
RUN su www-data -c "php /var/www/html/occ groupfolders:create groupfolder"
RUN su www-data -c "php /var/www/html/occ groupfolders:group 1 users"
RUN su www-data -c "git clone --depth 1 -b $BRANCH https://github.com/nextcloud/notifications.git /var/www/html/apps/notifications/"
RUN su www-data -c "php /var/www/html/occ app:enable -f notifications"
RUN su www-data -c "php /var/www/html/occ notification:generate test -d test"
RUN su www-data -c "git clone --depth 1 -b $BRANCH https://github.com/nextcloud/photos.git /var/www/html/apps/photos/"
RUN su www-data -c "cd /var/www/html/apps/photos; composer install --no-dev"
RUN su www-data -c "php /var/www/html/occ app:enable -f photos"
# RUN su www-data -c "git clone --depth 1 -b $BRANCH https://github.com/nextcloud/assistant.git /var/www/html/apps/assistant/"
# RUN su www-data -c "cd /var/www/html/apps/assistant; source ~/.bashrc; composer install --no-dev"
# RUN su www-data -c "php /var/www/html/occ app:enable -f assistant"
RUN su www-data -c "php /var/www/html/occ app:enable -f testing"

ENTRYPOINT /usr/local/bin/run.sh
