FROM ubuntu:12.04
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install postgresql-client wget ruby git bash
RUN chsh root -s /bin/bash
RUN wget https://github.com/gilt/schema-evolution-manager/archive/0.9.12.tar.gz \
    && tar -zxf 0.9.12.tar.gz
WORKDIR /schema-evolution-manager-0.9.12
RUN ruby configure.rb --lib_dir /usr/lib --bin_dir /usr/bin
RUN ruby install.rb
RUN ln -s /usr/bin/sem-init   /usr/bin/init
RUN ln -s /usr/bin/sem-add    /usr/bin/add
RUN ln -s /usr/bin/sem-apply  /usr/bin/apply
RUN ln -s /usr/bin/sem-dist   /usr/bin/dist
RUN ln -s /usr/bin/sem-config /usr/bin/config
RUN ln -s /usr/bin/sem-info   /usr/bin/info
RUN mkdir /app
WORKDIR /app
