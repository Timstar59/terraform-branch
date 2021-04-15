FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

COPY ./requirements.txt /FrontEnd/requirements.txt

WORKDIR /FrontEnd

RUN pip install -r requirements.txt

COPY . /FrontEnd

ENTRYPOINT [ "python", "app.py" ]
