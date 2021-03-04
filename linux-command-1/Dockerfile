FROM ubuntu:16.04
# Default password, overwrite with "docker build ... --build-arg ROOTPW=password"
ARG ROOTPW=kaitoryouga1@3

RUN apt-get update && apt-get install -y openssh-server && apt-get install vim -y && apt-get install expect -y && apt-get install zip unzip -y

RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# RUN echo "GatewayPorts yes" >> /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN echo root:${ROOTPW} | chpasswd
RUN ln -s /bin/bash /bin/limitbash
RUN useradd lab -s /bin/limitbash
RUN echo lab:kaito | chpasswd
RUN mkdir /home/lab
RUN mkdir /home/lab/bin
RUN ln -s /bin/ls /home/lab/bin/ls
COPY /src/.bash_profile /home/lab
RUN chown root. /home/lab/.bash_profile
RUN chmod 755 /home/lab/.bash_profile
RUN rm -f /root/.bashrc
COPY /src/.bashrc /root
RUN chmod 755 /root/
RUN chmod 755 /root/.bashrc
# RUN rm -f /usr/bin/scp
# RUN rm -f /usr/bin/wget
# COPY /src/flag.zip /home
# COPY /src/s.sh /tmp
# RUN chmod -R 777 /tmp/s.sh
# COPY /src/sshrc /etc/ssh
# RUN chmod +x /etc/ssh/sshrc
# When starting the container, map a custom port (i.e. 2222) to 22
# 80 is exposed for SSL-terminated HTTP traffic, which we will reverse proxy to localhost
# EXPOSE 22 80

# Start nginx
CMD ["/usr/sbin/sshd", "-D"]
