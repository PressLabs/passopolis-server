FROM java:8-alpine
MAINTAINER Calin Don <calin@presslabs.com>

ENV DB_HOST postgres
ENV DB_USER passopolis
ENV DB_PASSWORD secret
ENV DB_NAME passopolis

EXPOSE 80 443

RUN apk add --no-cache apache-ant git python

WORKDIR /src
ADD build.xml /src
ADD java /src/java
ADD tools /src/tools

RUN set -ex \
    && ant crypto \
    && ant jar \
    && mkdir /secrets \
    && ln -sf /secrets mitrocore_secrets \
    && mkdir mitrocore_secrets/sign_keyczar \
    && java -cp build/mitrocore.jar org.keyczar.KeyczarTool create --location=mitrocore_secrets/sign_keyczar --purpose=sign \
    && java -cp build/mitrocore.jar org.keyczar.KeyczarTool addkey --location=mitrocore_secrets/sign_keyczar --status=primary

VOLUME /secrets

ADD ./entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh
