#!/bin/bash

echo 'Waiting 10 seconds for things to start up and settle down...'
sleep 10

# Every day at a scheduled time do a backup
while true; do
  echo "Backing up site data"
  duply site_data backup

  echo "Backing up configuration files"
  # Get all developer keys
  public_keys=(); gpg_recipients=""
  for key in public_keys/*; do
    test -f $key && \
    public_keys+=( ${key##*/} ) && \
    gpg_recipients=$gpg_recipients" -r ${key##*/}"
  done

  if [ "${#public_keys[@]}" -gt "0" ]; then
    # Encrypt all config backups
    gpg --yes --encrypt-files $gpg_recipients --trust-model always backup_config/*.gz

    # Send all encrypted config backups to target
    if [[ ! -z "{{PROJECT_BACKUP_CONFIG_TARGET}}" ]]; then
      scp backup_config/*.gpg {{PROJECT_BACKUP_CONFIG_TARGET}}
    else
      echo "WARNING: Remote backup configuration TARGET is missing! Skipping remote backup of configuration files."
    fi
  else
    echo "WARNING: No public keys available for encrypting configuration files. Skipping remote backup of configuration files."
  fi

  current_epoch=$(date +%s)
  target_epoch=$(date -d '{{PROJECT_BACKUP_SCHEDULED_TIME}}' +%s)
  sleep_seconds=$(( $target_epoch - $current_epoch ))
  echo "Waiting '$sleep_seconds' seconds for next backup"

  sleep "$sleep_seconds"
done

# vim: set ft=sh:
