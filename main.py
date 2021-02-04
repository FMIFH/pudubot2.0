from flask import Flask, request, send_file
from flask_restful import Resource, Api, reqparse
import png

path = 'blueprints'

app = Flask(__name__)
api = Api(app)



class Blueprint(Resource):
    
    def get(self, groupid):
        return send_file(path+'/'+str(groupid)+".png",mimetype='image/png')
    
    def post(self, groupid):
        print(request.data)
        f = open(path+'/'+str(groupid)+".png","wb")
        f.write(request.data)
        return 1

api.add_resource(Blueprint, "/blueprint/<int:groupid>")


if __name__ == "__main__":
    app.run(port=8888,debug=True)

