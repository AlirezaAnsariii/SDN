FROM python:3.10

WORKDIR /app

COPY server.py .

RUN pip install flask

EXPOSE 8000

CMD ["python", "server.py"]

