FROM ghcr.io/nextcloud/continuous-integration-shallow-server-php7.4:1


ARG BRANCH="master"

ENV EVAL=true

RUN BRANCH="$BRANCH" /usr/local/bin/initnc.sh

RUN su www-data -c "OC_PASS=user1 php /var/www/html/occ user:add --password-from-env --display-name='User One' user1"
RUN su www-data -c "OC_PASS=user2 php /var/www/html/occ user:add --password-from-env --display-name='User Two' user2"
RUN su www-data -c "OC_PASS=user3 php /var/www/html/occ user:add --password-from-env --display-name='User Three' user3"
RUN su www-data -c "OC_PASS=test php /var/www/html/occ user:add --password-from-env --display-name='Test@Test' test@test"
RUN su www-data -c "OC_PASS=test php /var/www/html/occ user:add --password-from-env --display-name='Test Spaces' 'test test'"
RUN su www-data -c "php /var/www/html/occ user:setting user2 files quota 1G"
RUN su www-data -c "php /var/www/html/occ group:add users"
RUN su www-data -c "php /var/www/html/occ group:adduser users user1"
RUN su www-data -c "php /var/www/html/occ group:adduser users user2"

RUN su www-data -c "php /var/www/html/occ app:install spreed"
RUN su www-data -c "php /var/www/html/occ app:enable spreed"

ENTRYPOINT /usr/local/bin/run.sh