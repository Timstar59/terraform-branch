FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

COPY ./requirements.txt /randapp1/requirements.txt

WORKDIR /randapp1

RUN pip install -r requirements.txt

COPY . /randapp1

ENTRYPOINT [ "python", "app.py" ]
