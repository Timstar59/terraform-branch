FROM ubuntu:20.04

RUN apt update -y && \
    apt install -y python-pip3 python-dev

COPY ./requirements.txt /backend/requirements.txt

WORKDIR /backend

RUN pip install -r requirements.txt

COPY . /backend

ENTRYPOINT [ "python", "app.py" ]
