FROM almalinux:9
RUN dnf install nginx -y
RUN rm -rf /usr/share/nginx/index.html
ADD https://raw.githubusercontent.com/SrikanthBommadi/Terraform/refs/heads/main/README /usr/share/nginx/index.html
RUN chmod +r /usr/share/nginx/index.html
CMD [ "nginx","-g","daemon off;" ]