FROM python:3.9-slim

WORKDIR /app

ADD . /app

RUN pip install --trusted-host pypi.python.org -r requirements.txt

EXPOSE 5000

ENV Name OpentoAll

CMD ["python", "server.py"]