# Nextcolud client testing server

This is a docker setup to spawn different versions of Nextcloud in order to test Nextcloud clients.


## Install

Just clone this repository in a folder


## Run

Use the start, stop and rebuild scripts.

I.e., to start the master branch version of Nextcloud:
```
./rebuild.sh ephemeral-master
./start.sh ephemeral-master
# And when you're done
./stop.sh
```

You can start a specific version of Nextcloud as well:
```
./start.sh ephemeral-stable32
```

You can start it on another port adding it at the end:

```
./start.sh ephemeral-stable32 8888
```


To obtain the list of supported versions:
```
docker compose config --services
```


## Login

There are some user accounts already configured (username / password):

- admin / admin
- user1 / user1
- user2 / user2
- user3 / user3
- test@test / test
- test test / test

You will find as well a shared folder already set up for testing.


## Advanced usage


### Install apps

You can install the apps from the admin interface as usual, or you can tweak the Dockerfile.

- Open the Dockerfile
- Note the list of already installed apps (comment them with # if you don't want them)
- Add an app using the usual `occ` command

> I.e., for adding Notes app add: `RUN su www-data -c "php /var/www/html/occ app:enable -f notes"`

## Troubleshooting

### App "XXXX" cannot be installed because it is not compatible with this version of the server

The last version on master branch may not (yet) support all existing apps. In that case, disable the conflicting app commenting it in the Dockerfile (see above).

### Bruteforce protection kicks in during tests

It may happen for the bruteforce protection to kick in during tests due to the multiple logins, in that case you can disable it by entering in the container and:
```
php occ config:system:set auth.bruteforce.protection.enabled --value false --type bool
php occ security:bruteforce:reset 192.168.my.ip
```
(replace the IP with yours).

You can also completely disable bruteforcing in Dockerfile adding this line:
```
RUN su www-data -c "php /var/www/html/occ config:system:set auth.bruteforce.protection.enabled --value false --type bool"
```
