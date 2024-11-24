FROM python:3.10-slim
WORKDIR /usr/src/app

ENV PYTHONWRITEYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip
COPY requirements.txt /usr/src/app/requirements.txt
RUN pip install -r requirements.txt

COPY . /usr/src/app 

CMD ["python", "main.py"]


