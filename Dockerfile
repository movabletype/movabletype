FROM masiuchi/docker-mt-test:trusty-full

COPY t/cpanfile .

RUN cpm install -g --test &&\
 mysql -e "create database mt character set utf8;" &&\
 mysql -e "grant all privileges on mt_test.* to mt@localhost;"

