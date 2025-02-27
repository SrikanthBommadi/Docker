FROM almalinux:9
RUN dnf install nginx -y
RUN rm -rf /usr/share/nginx/html/index.html
ADD https://raw.githubusercontent.com/SrikanthBommadi/Docker-/refs/heads/main/dockerfiles/COPY/Dockerfile /usr/share/nginx/index.html
RUN chmod +r /usr/share/nginx/html/index.html
CMD [ "nginx","-g","daemon off;" ]