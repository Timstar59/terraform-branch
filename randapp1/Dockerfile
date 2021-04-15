FROM ubuntu:20.04

RUN apt update -y && \
    apt install -y python-pip3 python-dev

COPY ./requirements.txt /randapp1/requirements.txt

WORKDIR /randapp1

RUN pip install -r requirements.txt

COPY . /randapp1

ENTRYPOINT [ "python", "app.py" ]
