# How to install Magento 2.4 on localhost

## Step 1: Install Docker Desktop on the Windows 10
Go to the link https://docs.docker.com/get-docker/ for downloading the Docker Desktop

## Step 2: Clone repository

## Step 2: Create the docker containers from docker-compose.yml
    docker-compose up -d

## Step 3: Install Magento 2.4.1 with magento cli command 

bin/magento setup:install \
--base-url=http://localhost/magento \
--backend-frontname=admin \
--db-host=mariadb \
--db-name=magento \
--db-user=user_magento \
--db-password=magento_db_password \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=admin@admin.com \
--admin-user=admin \
--admin-password=admin123 \
--language=en_US \
--currency=USD \
--timezone=America/Chicago \
--use-rewrites=1 \
--elasticsearch-host=elasticsearch \
--use-secure=1 \
--base-url-secure=https://magento.local


/var/www/html/magento/var/composer_home/auth.json

### Install sample data
`bin/magento sampledata:deploy`
`bin/magento setup:upgrade`

### Disable 2FA
`bin/magento module:disable Magento_TwoFactorAuth`

## Login to ad

/etc/init.d/apache2 reload

