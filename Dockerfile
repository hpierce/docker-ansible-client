#
# Ansible client
#
#
FROM hpierce/docker-ubuntu-16.04-base

MAINTAINER Hugh Pierce

ENV DEBIAN_FRONTEND noninteractive

# Userid that will run ansible commands (rundeck)
RUN useradd -m -d /home/rundeck -s /bin/bash rundeck

# Generate keys for rundeck user
RUN su - rundeck -c "ssh-keygen -q -N \"\" -t rsa -f /home/rundeck/.ssh/id_rsa"

# Copy authorized_keys for rundeck user
COPY authorized_keys /home/rundeck/.ssh/ 

# Fix permissions on authorized_keys
RUN chown rundeck:rundeck /home/rundeck/.ssh/authorized_keys && \
      chmod 600 /home/rundeck/.ssh/authorized_keys

# Sudoers file for rundeck user
COPY rundeck-user /etc/sudoers.d/

# Create for ssh
RUN mkdir /var/run/sshd

# Start services
ENTRYPOINT service ssh start && /bin/bash

