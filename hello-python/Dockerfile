From alpine:edge
RUN apk add --update py-pip
RUN pip install cherrypy
ADD web.py .
CMD python web.py
