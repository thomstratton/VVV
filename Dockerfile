FROM ubuntu:focal
#official ubuntu docker image

# export TZ='America/New_York' & export DEBIAN_FRONTEND='noninteractive'
ENV TZ=America/New_York
ENV DEBIAN_FRONTEND=noninteractive

#add vagrant user account
RUN useradd vagrant -m \
  && echo "vagrant:vagrant" | chpasswd \
  && usermod -a -G sudo vagrant

# install sudo, ssh, basic ip utilities that are not part of base ubuntu image in docker
RUN apt-get update \
    && apt-get -y --no-install-recommends install sudo ssh iproute2 iputils-ping traceroute \
    && mkdir -p /var/run/sshd
    # ubuntu needs /var/run/sshd to exist for ssh to work


# allow vagrant to login using hashicorp insecure key https://github.com/hashicorp/vagrant/blob/main/keys/vagrant.pub
RUN cd ~vagrant \
  && mkdir .ssh \
  && echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > .ssh/authorized_keys \
  && chown -R vagrant:vagrant .ssh \
  && chmod 0700 .ssh \
  && chmod 0600 .ssh/authorized_keys \
  # give vagrant sudo and then changed default shell to bash
  && echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant_user \
  && sudo chsh -s /bin/bash vagrant


EXPOSE 22

#CMD ["service ssh restart && bash"]
CMD ["/usr/sbin/sshd", "-D"]
