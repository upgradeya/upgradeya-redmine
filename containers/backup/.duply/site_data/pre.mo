#!/bin/bash

project_db_password="{{PROJECT_DB_PASSWORD}}"
password_param=""
if [ "$project_db_password" ]; then
  password_param="-p$project_db_password"
fi

# Export mysql database
mysqldump -u {{PROJECT_DB_USER}} $password_param -h db {{PROJECT_DB_DATABASE}} | gzip > {{PROJECT_BACKUP_SOURCE}}/sql_backup/app.sql.gz
