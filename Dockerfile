FROM openjdk:8u322-slim-buster
LABEL maintainer="Ajay"
# Set the timezone to Indian Standard Time (IST)
ENV TZ=Asia/Kolkata
# Install the tzdata package (required for setting the timezone)
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Set environment variables using build arguments
ARG PROCESS_NAME
ARG PORT
ARG PROFILE
ARG NAMESPACE
ARG ROLE_ID
ARG SECRET_ID
#ARG AWS_ACCESS_KEY_ID
#ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION
ARG ENV
# Expose required port and define log dir
EXPOSE $PORT
VOLUME /var/log/$PROCESS_NAME
# create a new user and group (to not run docker as a root user)
ENV USER app-$PROCESS_NAME
RUN groupadd -g 999 $USER && useradd -r -u 999 -g $USER $USER
#RUN apt-get update && apt-get install -y telnet
RUN apt-get update && \
    apt-get install -y iputils-ping telnet curl wget vim zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Create required path and add jar files
RUN mkdir -p /srv/www/$PROCESS_NAME/current
WORKDIR /srv/www/$PROCESS_NAME/current
# create ENV varaible
ENV PROCESS_NAME=$PROCESS_NAME
ENV PORT=$PORT
ENV PROFILE=$PROFILE
ENV NAMESPACE=$NAMESPACE
ENV ROLE_ID=$ROLE_ID
ENV SECRET_ID=$SECRET_ID
#ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
#ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
ENV AWS_REGION=$AWS_REGION
ENV ENV=$ENV
# Creating and Copying cronjob
#RUN echo "0 05 * * * export AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID && export AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY && export AWS_REGION=\$AWS_REGION && /srv/www/\$PROCESS_NAME/current/log_script.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/auth-cron
#RUN sed -i "s|\$AWS_ACCESS_KEY_ID|${AWS_ACCESS_KEY_ID}|g" /etc/cron.d/auth-cron && \
#   sed -i "s|\$AWS_SECRET_ACCESS_KEY|${AWS_SECRET_ACCESS_KEY}|g" /etc/cron.d/auth-cron && \
#    sed -i "s|\$AWS_REGION|${AWS_REGION}|g" /etc/cron.d/auth-cron && \
#   sed -i "s|\$PROCESS_NAME|${PROCESS_NAME}|g" /etc/cron.d/auth-cron
# COPY cronjobs /etc/cron.d/auth-cron
#RUN chmod 0644 /etc/cron.d/auth-cron && \
#   crontab /etc/cron.d/auth-cron && \
#   touch /var/log/cron.log
COPY ./target/$PROCESS_NAME-*.jar /srv/www/$PROCESS_NAME/current/
RUN mv "$(ls -S /srv/www/$PROCESS_NAME/current/$PROCESS_NAME-*.jar | head -n 1)" /srv/www/$PROCESS_NAME/current/$PROCESS_NAME-exec.jar
# RUN mv  /srv/www/$PROCESS_NAME/current/$PROCESS_NAME-*.jar /srv/www/$PROCESS_NAME/current/$PROCESS_NAME-exec.jar
# copy the script file
COPY --chown=999 ./run.sh /srv/www/$PROCESS_NAME/current/run.sh
#COPY --chown=999 ./script.sh /srv/www/auth/current/script.sh
#RUN aws s3 cp s3://inspirenetz-eks/scripts/log_script.sh /srv/www/$PROCESS_NAME/current/log_script.sh
#RUN chmod 777 /srv/www/$PROCESS_NAME/current/log_script.sh
# Replacing the env varaibles values
#RUN sed -i "s|\$PROCESS_NAME|$PROCESS_NAME|g" /srv/www/$PROCESS_NAME/current/log_script.sh && \
#   sed -i "s|\$ENV|$ENV|g" /srv/www/$PROCESS_NAME/current/log_script.sh
# Replacing the env varaibles values
RUN sed -i "s|\$ROLE_ID|$ROLE_ID|g" /srv/www/$PROCESS_NAME/current/run.sh && \
    sed -i "s|\$SECRET_ID|$SECRET_ID|g" /srv/www/$PROCESS_NAME/current/run.sh && \
    sed -i "s|\$PORT|$PORT|g" /srv/www/$PROCESS_NAME/current/run.sh && \
    sed -i "s|\$PROCESS_NAME|$PROCESS_NAME|g" /srv/www/$PROCESS_NAME/current/run.sh && \
    sed -i "s|\$PROFILE|$PROFILE|g" /srv/www/$PROCESS_NAME/current/run.sh
CMD ["/bin/bash" , "run.sh"]
#CMD ["bash", "-c", "/usr/sbin/cron && tail -f /var/log/cron.log & /bin/bash run.sh"]