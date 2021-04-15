FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

COPY ./requirements.txt /randapp2/requirements.txt

WORKDIR /randapp2

RUN pip install -r requirements.txt

COPY . /randapp2

ENTRYPOINT [ "python", "app.py" ]
