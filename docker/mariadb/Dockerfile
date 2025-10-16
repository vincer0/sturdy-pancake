FROM mariadb:10.4.10-bionic

COPY my.cnf /etc/mysql/conf.d/my.cnf
COPY ./docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

CMD ["mysqld"]

EXPOSE 3306
