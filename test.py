from urllib.request import urlopen
import requests

BASE = "http://127.0.0.1:8888"
headers = {'Content-Type' : 'image/png'}
data = open(r'C:\Users\franc\OneDrive\Ambiente de Trabalho\planta.png','rb').read()


print(data)
response = requests.post(BASE + "/blueprint/1", data=data, headers=headers, verify=False)
print(response.json())




#response = requests.get(BASE + "/blueprint/12")
#print(response.content)