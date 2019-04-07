FROM tensorflow/tensorflow:latest-gpu-py3

RUN set -eux; \
    add-apt-repository ppa:jonathonf/python-3.7 -y; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    libnss-wrapper \
    freeglut3-dev \
    xvfb \
    python-pyglet \
    ffmpeg \
    graphviz \
    python3.7; \
  rm -rf /var/lib/apt/lists/*

COPY req.txt .
RUN pip3 install -r req.txt

VOLUME ["/project"]
WORKDIR /project

COPY docker-entrypoint.sh /
ENTRYPOINT ["bash", "/docker-entrypoint.sh"]

CMD ["jupyter", "lab"]

RUN mkdir -m 777 /apt
ENV HOME=/apt \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8
