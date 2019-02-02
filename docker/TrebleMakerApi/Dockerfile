FROM appinair/jdk11-maven:latest 

WORKDIR / 

RUN git clone https://github.com/shiehn/TrebleMakerApi.git

WORKDIR /TrebleMakerApi

#RUN mvn de.qaware.maven:go-offline-maven-plugin:resolve-dependencies --fail-never

ENV TM_API_ROOT_DIR="/TrebleMakerApi" \
    TM_API_USER="treble" \
    TM_API_PASS="maker" \
    TM_DB_CONN="jdbc:mysql://mysql/hivecomposedb?useSSL=false&autoReconnect=true&maxReconnects=100&autoReconnectForPools=true&initialTimeout=5" \
    TM_DB_USER="root" \
    TM_DB_PASS="maker" \
    TM_API_PORT="7777" \
    TM_API_VERSION="2" \
    TM_API_LOG_DIR="logs" \
    TM_API_S3_BUCKET="https://s3-us-west-2.amazonaws.com/[YOUR-BUCKET-NAME]" \
    AWS_BUCKET_NAME="[YOUR-BUCKET-NAME]" \
    AWS_ACCESS_KEY_ID="[YOUR-ACCESS-KEY]" \
    AWS_SECRET_ACCESS_KEY="[YOUR-SECRET-KEY]"

EXPOSE 7777

CMD mvn spring-boot:run
