#!/usr/bin/env bash
export EXISTING_VARS=$(printenv | awk -F= '{print $1}' | sed 's/^/\$/g' | paste -sd,); 
for file in $JSFOLDER;
do
#!  cat $file | envsubst $EXISTING_VARS | tee $file
  sed -i "s|\$BASE_URL|${BASE_URL}|g" $file
  sed -i "s|\$REDIRECTOR_URL|${REDIRECTOR_URL}|g" $file
  sed -i "s|Config.BASE_URL|${BASE_URL}|g" $file
  sed -i "s|Config.REDIRECTOR_URL|${REDIRECTOR_URL}|g" $file
done
nginx -g 'daemon off;'
