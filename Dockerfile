# Use a Python base image
FROM python:3.9-alpine3.13

# Set metadata
LABEL maintainer="Jonathan Sasse <jonathan.sasse@outlook.de>"

# Set Python to run in unbuffered mode
ENV PYTHONUNBUFFERED 1

# Install dependencies and add temporary build dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev

# Copy requirements files (dev if required), install them and remove the files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
ARG DEV=false
RUN /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = 'true' ] ; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps

# Add a user for our application
RUN adduser \
    --disabled-password \
    --no-create-home \
    django-user

# Create directories for our static files
RUN mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol

# Set environment variables
ENV PATH="/py/bin:$PATH"

# Switch to the new user
USER django-user

# Set the working directory and copy in our code
WORKDIR /app
COPY ./app /app

# Expose the port the app runs on
EXPOSE 8000
