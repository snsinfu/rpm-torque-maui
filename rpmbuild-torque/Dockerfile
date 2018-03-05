FROM centos:7

RUN yum install -y epel-release               \
 && yum install -y rpm-build                  \
                   gcc                        \
                   gcc-c++                    \
                   libtool                    \
                   libtool-ltdl               \
                   make                       \
                   openssh-clients            \
                   hwloc-devel                \
                   munge-devel                \
                   readline-devel             \
                   openssl-devel              \
                   libxml2-devel              \
                   boost-devel                \
 && yum clean all                             \
 && echo "#!/bin/sh"     > /usr/bin/systemctl \
 && echo "echo -.mount" >> /usr/bin/systemctl \
 && useradd builder                           \
 && install -o builder -d /home/builder/rpmbuild

USER builder
WORKDIR /home/builder/rpmbuild
ENTRYPOINT ["rpmbuild"]
