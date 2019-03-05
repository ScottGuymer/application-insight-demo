FROM python:3.7-alpine

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY app.py .

EXPOSE 80

ENTRYPOINT ["python", "app.py"]