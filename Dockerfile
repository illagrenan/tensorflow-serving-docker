# =====================================================================
# Tensorflow Serving Docker Image
# -------------------------------
#
# Build Image:
#
#     >>> docker build -t illagrenan/tensorflow-serving .
#
# =====================================================================

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Stage 1
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
FROM illagrenan/alpine-curl as builder

RUN curl -fsSL \
      http://storage.googleapis.com/tensorflow-serving-apt/pool/tensorflow-model-server/t/tensorflow-model-server/tensorflow-model-server_1.7.0_all.deb \
      -o /tmp/tensorflow_model_server.deb


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Stage 2
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
FROM ubuntu:16.04
LABEL authors="Vašek Dohnal <vaclav.dohnal@gmail.com>"

# ----------------------------------------------------------------------------------------------------
# 1. System Settings
# ----------------------------------------------------------------------------------------------------
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# ----------------------------------------------------------------------------------------------------
# 2. Install Tensorflow Serving via APT
#    https://www.tensorflow.org/serving/setup#installing_using_apt-get
# ----------------------------------------------------------------------------------------------------
COPY --from=builder /tmp/tensorflow_model_server.deb /tmp/tensorflow_model_server.deb
RUN dpkg -i /tmp/tensorflow_model_server.deb
RUN rm -f /tmp/tensorflow_model_server.deb

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
