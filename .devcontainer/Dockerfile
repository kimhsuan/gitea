FROM mcr.microsoft.com/devcontainers/base:bookworm

# Install required packages
ARG APT_PKGS="\
ca-certificates \
curl \
wget \
git \
lsb-release \
python3 \
python3-venv \
rsync \
"

RUN apt-get update -qqy && apt-get -qqy upgrade && apt-get install -qqy --no-install-recommends ${APT_PKGS} \
&&  rm -rf /var/lib/apt/lists/*

# Install Google Cloud SDK
ARG CLOUD_SDK_PKGS="\
python3 \
gnupg \
"

ARG CLOUD_SDK_VERSION
ENV CLOUD_SDK_VERSION=${CLOUD_SDK_VERSION:-532.0.0}
ARG CLOUD_SDK_COMPONENTS="\
google-cloud-cli-gke-gcloud-auth-plugin=${CLOUD_SDK_VERSION}-0 \
kubectl \
"

RUN apt-get update -qqy && apt-get install -qqy --no-install-recommends ${CLOUD_SDK_PKGS} \
&&  export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
&&  echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
&&  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
&&  apt-get update && apt-get install -y google-cloud-cli=${CLOUD_SDK_VERSION}-0 ${CLOUD_SDK_COMPONENTS} \
&&  gcloud --version \
&&  kubectl version --client \
&&  rm -rf /var/lib/apt/lists/*

# Install Terraform
ARG TARGETARCH
ARG TERRAFORM_BINARY_VERSION
ENV TERRAFORM_BINARY_VERSION=${TERRAFORM_BINARY_VERSION:-1.5.7}

RUN ( curl -sLo terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_BINARY_VERSION}/terraform_${TERRAFORM_BINARY_VERSION}_linux_${TARGETARCH}.zip" && \
      unzip terraform.zip && \
      rm terraform.zip && \
      mv ./terraform /usr/local/bin/terraform \
    ) && terraform --version
