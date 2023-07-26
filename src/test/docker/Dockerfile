FROM almalinux:9.2

RUN dnf -y install emacs emacs-nox git subversion
RUN dnf -y install java-{1.8.0,11,17}-openjdk-{src,devel,javadoc}
RUN dnf -y install epel-release sudo wget passwd
RUN useradd -c "Software AG Productrs" sag
RUN usermod -aG wheel sag
RUN echo "manage" | passwd --stdin sag
RUN mkdir -p /usr/local/install
RUN chown -R sag:sag /usr/local/install
RUN mkdir -p /opt/wm/installation
RUN chown sag:sag /opt/wm/installation
USER sag:sag
WORKDIR /usr/local/install/

# The intention of the following command is having a file, that changes with every commit.
# In other words, as long as there is no commit, the file won't change and Docker's cache
# will prevent the following steps from running.
ADD "https://api.github.com/repos/SagGcs/wm-installation/commits?per_page=1" wm-installation-latest-commit
RUN git clone https://github.com/SagGcs/wm-installation.git
WORKDIR /usr/local/install/wm-installation/src/main/Installation
COPY settings-local.sh *-license.xml .
RUN sh -x install.sh 2>&1 | tee install.log
CMD /bin/bash

