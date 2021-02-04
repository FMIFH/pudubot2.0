from urllib.request import urlopen
import requests

BASE = "http://127.0.0.1:5000/"
#headers = {'Content-Type' : 'image/png'}
#image_url = r'C:\Users\franc\OneDrive\Ambiente de Trabalho\planta.png'
#data = open(r'C:\Users\franc\OneDrive\Ambiente de Trabalho\planta.png','rb').read()

#img_file = urlopen(image_url)
#print(data)
#response = requests.post(BASE + "/blueprint/1", data=data, headers=headers, verify=False)
#print(response.json())




response = requests.get(BASE + "/blueprint/12")
print(response)
#print(response.content)