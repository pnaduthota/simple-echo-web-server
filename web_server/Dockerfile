# Author: Prayuth Naduthota

# Base python 3.8 image from Dockerhub
FROM python:3.8

# Set src directory var
ENV SRC_DIR /usr/bin/src/webapp/src

# Copy files into container src_dir
# Set working directory
COPY * ${SRC_DIR}/
WORKDIR ${SRC_DIR}

# Install dependecies
RUN pip install -r requirements.txt

# To see stdout in the console
ENV PYTHONUNBUFFERED=1

# Run web server
CMD ["python3", "web_server.py"]
