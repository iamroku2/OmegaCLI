FROM python:3.10-slim-buster

RUN mkdir /bot /tgenc && chmod 777 /bot
WORKDIR /bot
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Lagos
ENV TERM=xterm

RUN apt-get update && apt-get upgrade -y
RUN apt-get install git aria2 bash wget curl pv jq python3-pip mediainfo psmisc qbittorrent-nox -y && python3 -m pip install --upgrade pip setuptools

COPY --from=mwader/static-ffmpeg:7.0 /ffmpeg /bin/ffmpeg
COPY --from=mwader/static-ffmpeg:7.0 /ffprobe /bin/ffprobe

COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt
CMD ["bash","run.sh"]
