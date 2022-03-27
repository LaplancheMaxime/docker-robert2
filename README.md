# Robert2 / Loxya on Docker

Dockerfile and compose for Robert2 (https://robertmanager.org/)

Github project : https://github.com/Robert-2/Robert2

Releases informations: https://github.com/Robert-2/Robert2/releases

## Supported tags

* **0.16.2**  0.16.2-php8-apache-buster | [Official release note](https://github.com/Robert-2/Robert2/blob/master/CHANGELOG.md#0161-2021-11-03) | [Official github release](https://github.com/Robert-2/Robert2/releases/tag/0.16.2)
* **0.17.1**  0.16.2-php8-apache-buster | [Official release note](https://github.com/Robert-2/Robert2/blob/master/CHANGELOG.md#0171-2022-01-06) | [Official github release](https://github.com/Robert-2/Robert2/releases/tag/0.17.1)
## What is Robert2 / Loxya
Web application to manage equipment rental or loan. Simple, efficient, scalable and open-source. 

### Who is it for?
If you are an association, a school or university, a company or even an auto-entrepreneur, and you have equipment to rent or to lend, this software is for you!

It will help you manage your equipment, your services, your clients and beneficiaries, as well as your staff. 

### More information 
[Robert2 repository](https://github.com/Robert-2/Robert2)

[Robert2 official website](https://robertmanager.org/)

## How to run this image ?
This image is based on the [official PHP repository](https://registry.hub.docker.com/_/php/).

**Important**: This image don't contains database.

Let's use [Docker Compose](https://docs.docker.com/compose/) to integrate it with  [MySQL](https://hub.docker.com/_/mysql/).

Create `docker-compose.yml` file as following:
```yaml
---
version: '3.7'
services:
  app:
    image: maximelaplanche/robert2:latest
    networks:
      - robert2_db_network
      - robert2_network
    depends_on:
      - db

  db:
    image: mysql:8
    command: --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: MdPToRootU3rF0rR0b3rt2
      MYSQL_DATABASE: robert2_db
      MYSQL_USER: robert2_usr
      MYSQL_PASSWORD: MdPToRootU3rF0rR0b3rt2U$3r
    volumes:
      - robert2_data:/var/lib/mysql
    networks:
      - robert2_db_network

# Docker Networks
networks:
  robert2_db_network:
  robert2_network:

# Docker volumes
volumes:
  robert2_data:
```
Then run all services `docker-compose up -d`. Now, go to http://0.0.0.0 to access to the new Robert2/Loxya installation.