#FROM python:3.10-slim-buster

# Base Image 
FROM ubuntu:24

# Setup home directory, non interactive shell and timezone
RUN mkdir /bot /tgenc && chmod 777 /bot
WORKDIR /bot
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Lagos
ENV TERM=xterm

# Install Dependencies
RUN dnf -qq -y update && dnf -qq -y install git aria2 bash xz wget curl pv jq python3-pip mediainfo psmisc procps-ng qbittorrent-nox && python3 -m pip install --upgrade pip setuptools

# Install latest ffmpeg
COPY --from=mwader/static-ffmpeg:6.1 /ffmpeg /bin/ffmpeg
COPY --from=mwader/static-ffmpeg:6.1 /ffprobe /bin/ffprobe

# Copy files from repo to home directory
COPY . .

# Install python3 requirements
RUN pip3 install -r requirements.txt

# Start bot
CMD ["bash","run.sh"]
