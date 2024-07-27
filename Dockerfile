FROM debian:10

RUN apt-get update -y && apt-get install -y htop \
    && apt-get install -y build-essential \
    && apt-get install -y libpq-dev \
    && apt-get install -y telnet netcat 

# Install Python 3.11 dependencies
RUN apt-get install -y wget libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev  

RUN apt-get install -y tar

# Download Python 3.11 
WORKDIR /tmp
RUN wget https://www.python.org/ftp/python/3.11.8/Python-3.11.8.tar.xz
RUN tar xf Python-3.11.8.tar.xz
WORKDIR /tmp/Python-3.11.8
RUN ./configure --enable-optimizations
RUN make
RUN make install

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Requirements are installed here to ensure they will be cached.
COPY ./requirements.txt /requirements.txt
RUN pip3.11 install -r /requirements.txt

RUN apt-get install -y sed

# # Copy 'start-fastapi.sh' shell script
COPY ./scripts/start-fastapi.sh /start-fastapi.sh
# Convert Windows line endings to Unix line endings via sed
RUN sed -i 's/\r$//g' /start-fastapi.sh
RUN chmod 755 /start-fastapi.sh

# Copy 'start-celery-worker.sh' shell script
COPY ./scripts/start-celery-worker.sh /start-celery-worker.sh
# Remove all carriage returns from the file via sed
RUN sed -i 's/\r$//g' /start-celery-worker.sh
RUN chmod 755 /start-celery-worker.sh

# Set container directory with the copied source code
# WORKDIR /
#/workspaces/supallama-rag-backend-fastapi-celery-redis-python-template