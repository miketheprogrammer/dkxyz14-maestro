import cherrypy

cherrypy.config.update({'server.socket_port': 9090})
cherrypy.config.update({'server.socket_host': '0.0.0.0'})

class Root(object):
    @cherrypy.expose
    def index(self):
        return "Hello World! From Python"

if __name__ == '__main__':
   cherrypy.quickstart(Root(), '/')