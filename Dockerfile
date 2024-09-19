FROM openresty/openresty:jammy

RUN wget https://gitlab.com/lilypond/lilypond/-/releases/v2.24.4/downloads/lilypond-2.24.4-linux-x86_64.tar.gz
RUN tar -xvf lilypond-2.24.4-linux-x86_64.tar.gz
RUN chmod +x /lilypond-2.24.4/bin/lilypond

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY script.lua /usr/local/openresty/nginx/conf/script.lua

EXPOSE 80

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
