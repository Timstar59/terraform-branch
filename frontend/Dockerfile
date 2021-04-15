FROM ubuntu:20.04

RUN apt update -y && \
    apt install -y python-pip3 python-dev

COPY ./requirements.txt /FrontEnd/requirements.txt

WORKDIR /FrontEnd

RUN pip install -r requirements.txt

COPY . /FrontEnd

ENTRYPOINT [ "python", "app.py" ]
