# SEARCH-2568: Supporting tools

This project provides a Docker Compose deployment in order to restore the environment provided for SEARCH-2568.

The main `docker-compose.yml` file includes a deployment for Alfresco Repository and Search Services, while the `sqlserver/docker-compose.yml` provides a Database deployment restoring a backup from SQLServer.

## Preparing the environment

Before using this project, you need to copy the SQLServer backup `alfrescodb.back` to `sqlserver/backup` folder.

It's also required to get your local IP Address, as it's required in order to use SQLServer Docker Container. A command like the following one, where the local IP Address is 192.168.1.43, could help.

```
$ ifconfig en0
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	options=400<CHANNEL_IO>
	ether 38:f9:d3:2e:e7:7d
	inet6 fe80::47d:141f:b7a4:3588%en0 prefixlen 64 secured scopeid 0x6
	inet 192.168.1.43 netmask 0xffffff00 broadcast 192.168.1.255
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect
	status: active
```

## Starting the environment

**Step 1** Start the SQL Server database

```
$ cd sqlserver
$ docker-compose up --build --force-recreate

Starting up database 'ILCLONEDALFDB01A'.
Processed 102 pages for database 'ILCLONEDALFDB01A', file 'ILALFDB01P_log' on file 1.
RESTORE DATABASE successfully processed 1729854 pages in 126.621 seconds (106.731 MB/sec).
Changed database context to 'ILCLONEDALFDB01A'.
Updating Alfresco admin password...
(1 rows affected)
Database is up & ready!
```

**Step 2** Start ACS Repository and SOLR

SQL Server database should be up & running before running `docker-compose` in root folder.

Add your local IP Address to environment values.

```
$ cat .env
ALFRESCO_TAG=6.2.2
SEARCH_TAG=2.0.1
LOCAL_IP=192.168.1.43
```

Start Docker Compose template.

```
$ docker-compose up --build --force-recreate
```

Once started, following endpoints should be available with default `admin`/`admin` credentials.

* http://localhost:8080/alfresco
* http://localhost:8083/solr

YourKit service for SOLR is exposed using port 10001


## Using experimental Search Services release

In order to use an experimental Search Services release, including a new core property to start indexing from a given Transaction Id, follow next steps.

```
$ git clone git@github.com:Alfresco/InsightEngine.git
$ cd InsightEngine
$ git checkout fix/SEARCH-2568_OOMLargeAncestorList

$ cd search-services
$ mvn clean package -DskipTests

$ cd packaging/target/docker-resources/
$ docker build -t searchservices:develop .
```

Once the Docker Image has been built, change the `FROM` line in `search/Dockerfile` file to use the new tag `searchservices:develop`. This will save a lot of time, as 4 million transactions can be skipped.
