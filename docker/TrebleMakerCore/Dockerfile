FROM appinair/jdk11-maven:latest 

RUN apt-get -y update && \ 
    apt-get -y install software-properties-common && \
    apt-get -y update && \
    apt-get -y install sox libsox-fmt-all && \
    apt-get -y install fluidsynth

RUN git clone https://github.com/shiehn/TrebleMaker.git

WORKDIR /TrebleMaker

RUN ./scripts/fetch-deps.sh

WORKDIR /TrebleMaker/TrebleMakerCore

#RUN mvn de.qaware.maven:go-offline-maven-plugin:resolve-dependencies --fail-never

ENV TM_ROOT_DIR="/TrebleMaker" \
    TM_CACHE_CONN="hazelcast:5701" \
    TM_DB_CONN="jdbc:mysql://mysql/hivecomposedb?useSSL=false&autoReconnect=true&maxReconnects=100&autoReconnectForPools=true&initialTimeout=5" \    
    TM_DB_USER="root" \
    TM_DB_PASS="maker" \
    TM_API_USER="treble" \
    TM_API_PASS="maker" \
    TM_API_VERSION=2 \
    TM_API_URL="http://treblemakerapi:7777" \
    TM_API_UPLOAD_URL="http://treblemakerapi:7777/filesync" \
    TM_BYPASS_RHYTHM_RATING="false" \
    TM_BYPASS_BASSLINE_RATING="false" \
    TM_BYPASS_ARPEGGIO_RATING="false" \
    TM_BYPASS_HARMONIC_LOOP_RATING="false" \
    TM_BYPASS_BEAT_LOOP_RATING="false" \
    TM_BYPASS_SEQUENCE_RATING="false" \
    TM_BYPASS_EQ_RATING="false" \
    TM_BYPASS_ANALYTICS="false" \
    TM_BYPASS_EQ_ANALYTICS="false" \
    TM_NUM_OF_MIXES=1 \
    TM_NUM_OF_MIX_VARIATIONS=1 \
    TM_CORE_LOG_DIR="logs" \
    TM_QUEUE_POLL_INTERVAL=120000 \
    AWS_BUCKET_NAME="[YOUR-BUCKET]" \
    AWS_ACCESS_KEY_ID="[YOUR-AWS-ACCESS-KEY]" \
    AWS_SECRET_ACCESS_KEY="[YOUR-AWS-SECRET-KEY]"

WORKDIR /TrebleMaker

RUN ./create_aws_credentials.sh 
 
CMD ./wait_on_api.sh
 
