FROM python:3.10-slim-buster

WORKDIR /usr/src/app
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Lagos
ENV TERM=xterm
RUN chmod 777 /usr/src/app

RUN apt-get update && apt-get upgrade -y
RUN apt-get install git wget pv jq python3-dev mediainfo gcc libsm6 libxext6 libfontconfig1 libxrender1 libgl1-mesa-glx -y aria2 bash curl pv jq psmisc qbittorrent-nox

COPY --from=mwader/static-ffmpeg:6.0 /ffmpeg /bin/ffmpeg
COPY --from=mwader/static-ffmpeg:6.0 /ffprobe /bin/ffprobe

COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["bash","run.sh"]
