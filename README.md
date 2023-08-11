# Robert2 / Loxya on Docker

<div align="center">

<img src="https://gitlab.com/uploads/-/system/project/avatar/34781125/docker-robert2.png" width="100" alt="docker-robert2">

[![Docker Image Size](https://badgen.net/docker/size/maximelaplanche/robert2?icon=docker&label=image%20size)](https://hub.docker.com/repository/docker/maximelaplanche/robert2)
[![Github stars](https://badgen.net/github/stars/LaplancheMaxime/docker-robert2?icon=github&label=stars)](https://github.com/LaplancheMaxime/docker-robert2)
[![GitHub Official last release](https://badgen.net/github/release/Robert-2/Robert2/stable?icon=github)](https://github.com/Robert-2/Robert2/releases)
[![GitHub Official last release](https://badgen.net/github/release/LaplancheMaxime/docker-robert2?icon=github)](https://github.com/LaplancheMaxime/docker-robert2)

Dockerfile and compose for Robert2 / Loxya (<https://robertmanager.org/>)

[![Docker hub](https://dockeri.co/image/maximelaplanche/robert2)](https://hub.docker.com/r/maximelaplanche/robert2)

 [Gitlab image repository](https://gitlab.com/mlaplanche/docker-robert2/) | [Official Github project](https://github.com/Robert-2/Robert2) | [Releases informations](https://github.com/Robert-2/Robert2/releases) |

</div>

## Supported tags

* **`latest`**  **`0.22.2`**  `0.22.2-php8-apache-buster` | [Dockerfile](/images/0.21.2-php8-apache-buster/Dockerfile) | [Official release note](https://github.com/Robert-2/Robert2/blob/master/CHANGELOG.md#0221-2023-08-04) | [Official github release](https://github.com/Robert-2/Robert2/releases/tag/0.22.2)

* **`0.21.2`**  `0.21.2-php8-apache-buster` | [Dockerfile](/images/0.21.2-php8-apache-buster/Dockerfile) | [Official release note](https://github.com/Robert-2/Robert2/blob/master/CHANGELOG.md#0212-2023-05-15) | [Official github release](https://github.com/Robert-2/Robert2/releases/tag/0.21.2)

* **`0.20.6`**  `0.20.6-php8-apache-buster` | [Dockerfile](/images/0.20.6-php8-apache-buster/Dockerfile) | [Official release note](https://github.com/Robert-2/Robert2/blob/master/CHANGELOG.md#0206-2023-04-14) | [Official github release](https://github.com/Robert-2/Robert2/releases/tag/0.20.6)

* **`0.19.3`**  `0.19.3-php8-apache-buster` | [Dockerfile](/images/0.19.3-php8-apache-buster/Dockerfile) | [Official release note](https://github.com/Robert-2/Robert2/blob/0.19.3/CHANGELOG.md#0193-2022-10-28) | [Official github release](https://github.com/Robert-2/Robert2/releases/tag/0.19.3)


## What is Robert2 / Loxya

Web application to manage equipment rental or loan. Simple, efficient, scalable and open-source. 

### Who is it for?

If you are an association, a school or university, a company or even an auto-entrepreneur, and you have equipment to rent or to lend, this software is for you!

It will help you manage your equipment, your services, your clients and beneficiaries, as well as your staff. 

### More information

* [Robert2 repository](https://github.com/Robert-2/Robert2)
* [Robert2 official website](https://robertmanager.org/)
* [Robert2 official documentation](https://robertmanager.org/wiki)

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
      MYSQL_PASSWORD: MdPToRootU3rF0rR0b3rt2Us3r
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

Then run all services `docker-compose up -d`. Now, go to <http://0.0.0.0> to access to the new Robert2/Loxya installation.
