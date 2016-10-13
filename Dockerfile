#
# Ansible client
#
#
FROM hpierce/docker-ubuntu-16.04-base

MAINTAINER Hugh Pierce

ENV DEBIAN_FRONTEND noninteractive

# Additional packages required for ansible
RUN apt-get install -y sudo python

# Userid that will run ansible commands
RUN useradd -m -d /home/ansible -s /bin/bash ansible

# Generate keys for ansible user
RUN su - ansible -c "ssh-keygen -q -N \"\" -t rsa -f /home/ansible/.ssh/id_rsa"

# Copy authorized_keys for ansible user
COPY authorized_keys /home/ansible/.ssh/ 

# Fix permissions on authorized_keys
RUN chown ansible:ansible /home/ansible/.ssh/authorized_keys && \
      chmod 600 /home/ansible/.ssh/authorized_keys

# Sudoers file for ansible user
COPY ansible-user /etc/sudoers.d/

# Create for ssh
RUN mkdir /var/run/sshd

ENTRYPOINT /usr/sbin/sshd -D

