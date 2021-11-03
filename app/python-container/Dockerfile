FROM python:3.8.5-slim

RUN apt-get update \
    && apt-get install -y auditd \
    && sed -i "/PASS_MAX_DAYS/c\PASS_MAX_DAYS           60" /etc/login.defs \
    && sed -i "/PASS_MIN_DAYS/c\PASS_MIN_DAYS           7" /etc/login.defs \
    && sed -i "/UMASK/c\UMASK           027" /etc/login.defs \
    && mkdir /etc/modprobe.d \
    && echo "install cramfs /bin/true" > /etc/modprobe.d/dev-sec.conf \
    && echo "install freevxfs /bin/true" >> /etc/modprobe.d/dev-sec.conf \ 
    && echo "install jffs2 /bin/true" >> /etc/modprobe.d/dev-sec.conf \ 
    && echo "install hfs /bin/true" >> /etc/modprobe.d/dev-sec.conf \ 
    && echo "install hfsplus /bin/true" >> /etc/modprobe.d/dev-sec.conf \ 
    && echo "install squashfs /bin/true" >> /etc/modprobe.d/dev-sec.conf \ 
    && echo "install udf /bin/true" >> /etc/modprobe.d/dev-sec.conf \ 
    && echo "install vfat /bin/true" >> /etc/modprobe.d/dev-sec.conf \
    && sed -i "/max_log_file_action/c\max_log_file_action = keep_logs"  /etc/audit/auditd.conf \
    && apt-get install -y zip jq bash \
    && pip install --upgrade pip \
    && pip3 install \
      awscli \
      boto3 \
      plumbum \
      pytest \
      lambda-uploader \
      black \
    && adduser --disabled-password --gecos "" pythoner

USER pythoner
