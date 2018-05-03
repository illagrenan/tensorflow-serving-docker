# =====================================================================
# Tensorflow Serving Docker Image
# -------------------------------
#
# Build Image:
#
#     >>> docker build -t illagrenan/tensorflow-serving .
#
# =====================================================================
FROM ubuntu:16.04
LABEL authors="Vašek Dohnal <vaclav.dohnal@gmail.com>"

# ----------------------------------------------------------------------------------------------------
# 1. System Settings
# ----------------------------------------------------------------------------------------------------
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# ----------------------------------------------------------------------------------------------------
# 2. Install curl so we can fetch Google GPG key
# ----------------------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y -q --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------------------------------------------------
# 3. Install Tensorflow Serving via APT
#    https://www.tensorflow.org/serving/setup#installing_using_apt-get
# ----------------------------------------------------------------------------------------------------
RUN echo "deb [arch=amd64] http://storage.googleapis.com/tensorflow-serving-apt stable tensorflow-model-server tensorflow-model-server-universal" | tee /etc/apt/sources.list.d/tensorflow-serving.list \
    && curl -fsSL https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg | apt-key add -

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    tensorflow-model-server \
    && rm -rf /var/lib/apt/lists/*

# Verify tensorflow_model_server binary exists
RUN whereis tensorflow_model_server
RUN which tensorflow_model_server

# ---------------------------------------------------------------------
# 4. Prepare Volume for models (performance!)
#    https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/
#    https://docs.docker.com/engine/reference/builder/#volume
# ---------------------------------------------------------------------
RUN mkdir -p /models
VOLUME ["/models"]
