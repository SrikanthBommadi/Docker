ARG version
FROM almalinux:${version:-9}
ENV course="docker" \
    trainer="reddy"
ARG USERNAME=srikanth
RUN echo "Hello User: ${USERNAME}, image version: ${version}" > /tmp/devops.txt
##RUN echo "Hello ${trainer}" > /tmp/devops.txt
CMD [ "sleep","100" ]