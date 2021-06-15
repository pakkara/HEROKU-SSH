FROM heroku/heroku:18-build

# Install the CLI
RUN curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV APP_HOME /app  
RUN mkdir $APP_HOME  
WORKDIR $APP_HOME

RUN mkdir -p /opt/heroku
#FFMPEG &&
RUN apt install -y ffmpeg mkvtoolnix mediainfo
#Install Rclone
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y module-assistant
RUN apt-get install -y fuse-source
RUN apt-get install -y fuse kmod
RUN wget https://downloads.rclone.org/v1.55.1/rclone-v1.55.1-linux-amd64.deb
RUN dpkg -i rclone-v1.55.1-linux-amd64.deb
RUN rm rclone-v1.55.1-linux-amd64.deb
#Install Rclone
RUN wget https://downloads.plex.tv/plex-media-server-new/1.23.2.4656-85f0adf5b/debian/plexmediaserver_1.23.2.4656-85f0adf5b_amd64.deb
RUN dpkg -i plexmediaserver_1.23.2.4656-85f0adf5b_amd64.deb
RUN rm plexmediaserver_1.23.2.4656-85f0adf5b_amd64.deb
# Install python and pip
RUN apt-get -y install python3 python3-pip bash && apt-get update
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip3 install glances
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Expose is NOT supported by Heroku
# EXPOSE 5000 		

# Run the image as a non-root user
# none root stuff follows
RUN useradd -m heroku
RUN usermod -d $APP_HOME heroku
RUN chown heroku $APP_HOME
USER heroku

ADD . $APP_HOME 

ADD ./heroku-exec.sh /heroku-exec.sh
# Run the app.  CMD is required to run on Heroku
# $PORT is set by Heroku			
CMD bash /heroku-exec.sh && gunicorn --bind 0.0.0.0:$PORT wsgi
