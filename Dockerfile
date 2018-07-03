FROM ubuntu:14.04

RUN apt-get update -y && apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:kirillshkrogalev/ffmpeg-next
RUN apt-get update -y && apt-get install -y git mercurial xvfb xfonts-base xfonts-75dpi xfonts-100dpi xfonts-cyrillic gource ffmpeg screen

ADD generate.bash /tmp/generate.bash
ADD background.mp3 /tmp/background.mp3

VOLUME ["/src"]
WORKDIR /src

CMD bash /tmp/generate.bash
