FROM debian:jessie
MAINTAINER David Parrish <daveparrish@tutanota.com>

# Update Debian.
# install requirements (duply, mariadb-client, ssh)
RUN apt-get -y update && \
apt-get install -y -q --no-install-recommends \
  ca-certificates \
  duply \
  mariadb-client \
  openssh-client \
  python-paramiko \
  dateutils \
&& apt-get clean \
&& rm -r /var/lib/apt/lists/*

# Create user to run backups
RUN useradd -m -s /bin/bash duply

# Copy duply profiles
COPY .duply/ /home/duply/.duply
RUN chmod -R 700 /home/duply/.duply &&\
  chown -R duply:duply /home/duply/.duply
# Copy ssh keys
COPY .ssh/ /home/duply/.ssh
RUN chmod -R 700 /home/duply/.ssh &&\
  chown -R duply:duply /home/duply/.ssh

# Create directory for exporting sql
RUN mkdir -p /srv/http/sql_backup && chmod 777 /srv/http/sql_backup

# Add GPG keys for encrypting config tars
COPY public_keys /home/duply/public_keys
COPY load_developer_keys /home/duply/
RUN chmod +x /home/duply/load_developer_keys

# Setup volumes for backup
RUN install -dm777 /home/duply/backup && \
  install -dm777 /home/duply/backup_data && \
  install -dm777 /home/duply/.cache/duplicity && \
  install -dm777 {{PROJECT_BACKUP_SOURCE}}/sql_backup
VOLUME /home/duply/backup
VOLUME /home/duply/backup_data
VOLUME /home/duply/.cache/duplicity
VOLUME {{PROJECT_BACKUP_SOURCE}}/sql_backup

# Run as user
USER duply

# Build site
WORKDIR /home/duply

# Load the public keys into key chain for encrypting config tars
RUN ./load_developer_keys

# Copy backup service script
COPY backup_service /home/duply/backup_service

# Run backup service script by default
CMD /home/duply/backup_service
