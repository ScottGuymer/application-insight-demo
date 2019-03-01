FROM python:onbuild
MAINTAINER Paul Grave "paul.grave@sky.uk"

WORKDIR app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY app.py .

EXPOSE 5000

ENTRYPOINT ["python", "app.py"]
