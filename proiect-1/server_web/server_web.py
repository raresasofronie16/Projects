import socket
import os
import gzip
from threading import Thread

serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
serversocket.bind(('', 5678))
serversocket.listen(5)

base_dir = '../continut/'

def handle_client(clientsocket):
    print("S-a conectat un client.")
    cerere = ''
    linieDeStart = ''
    while True:
        data = clientsocket.recv(1024)
        cerere += data.decode()
        print("S-a citit mesajul: \n---------------------------\n" + cerere + "\n---------------------------")
        pozitie = cerere.find('\r\n')
        if pozitie > -1:
            linieDeStart = cerere[0:pozitie]
            print("S-a citit linia de start din cerere: ##### " + linieDeStart + " #####")
            break
    print('S-a terminat citirea.')
    
    resource_requested = linieDeStart.split()[1].lstrip('/')
    print(resource_requested)
    
    file_path = os.path.join(base_dir, resource_requested)
    print(file_path)
    
    if os.path.isfile(file_path) and file_path.startswith(base_dir):
        try:
            with open(file_path, 'rb') as file:
                content = file.read()

                compressed_content = gzip.compress(content)
                
            file_extension = os.path.splitext(file_path)[1].lower()
            if file_extension == '.html':
                content_type = 'text/html'
            elif file_extension == '.css':
                content_type = 'text/css'
            elif file_extension == '.js':
                content_type = 'application/javascript'
            elif file_extension == '.png':
                content_type = 'image/png'
            elif file_extension == '.jpg':
                content_type = 'image/jpeg'
            elif file_extension == '.jpeg':
                content_type = 'image/jpeg'
            elif file_extension == '.gif':
                content_type = 'image/gif'
            elif file_extension == '.ico':
                content_type = 'image/ico'
            elif file_extension == '.xml':
                content_type = 'application/xml'
            elif file_extension == '.json':
                content_type = 'application/json'
            else:
                content_type = 'text/plain'  # Default to plain text if type is unknown
            
            response = f"HTTP/1.1 200 OK\r\nContent-Type: {content_type}\r\nContent-Encoding: gzip\r\n\r\n".encode() + compressed_content
        except FileNotFoundError:
            response = "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\n404 Not Found".encode()
    else:
        response = "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\n404 Not Found".encode()

    clientsocket.sendall(response)
    clientsocket.close()
    print('S-a terminat comunicarea cu clientul.')

def start_server():
    while True:
        print("#########################################################################")
        print("Serverul asculta potentiali clienti.")
        (clientsocket, address) = serversocket.accept()
        # Start a new thread to handle the client
        client_thread = Thread(target=handle_client, args=(clientsocket,))
        client_thread.start()

if __name__ == "__main__":
    start_server()
