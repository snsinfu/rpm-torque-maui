FROM centos:7

COPY ./torque*.rpm ./

RUN yum install -y rpm-build        \
                   gcc              \
                   gcc-c++          \
                   libtool          \
                   libtool-ltdl     \
                   make             \
                   torque.rpm       \
                   torque-devel.rpm \
 && yum clean all                   \
 && useradd builder                 \
 && install -o builder -d /home/builder/rpmbuild

USER builder
WORKDIR /home/builder/rpmbuild
ENTRYPOINT ["rpmbuild"]
