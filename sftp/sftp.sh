#!/bin/bash
IFS=',' read -r -a users <<< "$SFTP_USERS"
for user in "${users[@]}"; do
  IFS=':' read -r -a user_details <<< "$user"
  username="${user_details[0]}"
  password="${user_details[1]}"
  uid="${user_details[2]}"
  gid="${user_details[3]}"
  home="${user_details[5]}"
  shell="${user_details[6]}"
  useradd -u "$uid" -g "$gid" -d "$home" -s "$shell" "$username"
  echo "$username:$password" | chpasswd
done

exec "$@"

