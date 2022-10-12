# build:
#  docker build -t baroka/idrive .

FROM ubuntu:22.04

ARG TZ "America/Los_Angeles"
ENV tz=$TZ

RUN mkdir -p /home/backup

WORKDIR /work

# Copy entrypoint script
COPY entrypoint.sh .
RUN chmod a+x entrypoint.sh

# Install packages
RUN apt-get update && apt-get -y install vim unzip curl libfile-spec-native-perl
RUN apt-get update && apt-get -y install build-essential sqlite3 perl-doc libdbi-perl libdbd-sqlite3-perl liblinux-inotify2-perl
RUN cpan App::cpanminus
# RUN cpanm Log::Log4perl
RUN cpanm common::sense
#RUN cpanm --force Linux::Inotify2

# Timezone (no prompt)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
RUN echo $tz > /etc/timezone
RUN rm -f /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# Install IDrive
RUN curl -O https://www.idrivedownloads.com/downloads/linux/download-for-linux/LinuxScripts/IDriveForLinux.zip && \
    unzip IDriveForLinux.zip

RUN rm IDriveForLinux.zip

WORKDIR /work/IDriveForLinux/scripts

# Give execution rights
RUN chmod a+x *.pl

# Create the log file to be able to run tail
RUN touch /var/log/idrive.log

# Run the command on container startup
ENTRYPOINT ["/work/entrypoint.sh"]