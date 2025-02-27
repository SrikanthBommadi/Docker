FROM almalinux:9
RUN dnf nginx install -y
RUN rm -f /usr/share/nginx/index.html
ADD https://raw.githubusercontent.com/SrikanthBommadi/Terraform/refs/heads/main/README /usr/share/nginx/index.html
RUN chmod +r /usr/share/nginx/index.html
CMD [ "nginx","-g","daemon off;" ]