ARG TF_VERSION
FROM hashicorp/terraform:${TF_VERSION}

LABEL name="terraform-local"
LABEL summary="terraform container for demo"
LABEL certified=true

ARG TF_VERSION
ENV TF_VERSION=${TF_VERSION}

RUN apk upgrade \
    && apk add rsyslog \
    && chmod 600 /etc/shadow \
    && apk add --update --no-cache \
        curl \
        bash \
        jq \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install awscli boto3 \
    && adduser -D terraform

USER terraform
