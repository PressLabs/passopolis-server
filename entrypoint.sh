#!/bin/sh
if [ ! -f /secrets/sign_keyczar/1 ] ; then
    mkdir mitrocore_secrets/sign_keyczar
    java -cp build/mitrocore.jar org.keyczar.KeyczarTool create --location=mitrocore_secrets/sign_keyczar --purpose=sign
    java -cp build/mitrocore.jar org.keyczar.KeyczarTool addkey --location=mitrocore_secrets/sign_keyczar --status=primary
fi
java -jar -ea -Ddatabase_url="jdbc:postgresql://$DB_HOST:5432/$DB_NAME?user=$DB_USER&password=$DB_PASSWORD" -Dhttp_port=80 -Dhttps_port=443 "$@" /src/build/mitrocore.jar

