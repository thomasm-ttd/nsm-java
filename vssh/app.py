from http.server import BaseHTTPRequestHandler, HTTPServer
import time
import subprocess
import socket
import sys
import os

hostName = "127.0.0.1"
serverPort = 8080

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><head><title>https://pythonbasics.org</title></head>", "utf-8"))
        self.wfile.write(bytes("<p>Request: %s</p>" % self.path, "utf-8"))
        self.wfile.write(bytes("<body>", "utf-8"))
        self.wfile.write(bytes("<p>This is an example web server.</p>", "utf-8"))
        self.wfile.write(bytes("</body></html>", "utf-8"))

if __name__ == "__main__":
    sub = subprocess.Popen(["/vssh/socat", "vsock-listen:2345,fork", "tcp4-connect:127.0.0.1:22"])
    # sub = subprocess.Popen(["/usr/bin/netstat", "-nat"])
    # sub = subprocess.Popen(["/usr/bin/ping", "127.0.0.1"])
    # sub = subprocess.Popen(["/usr/bin/ping", "localhost"])

    server_address = '/app/uds_socket'

    # Make sure the socket does not already exist
    try:
        os.unlink(server_address)
    except OSError:
        if os.path.exists(server_address):
            raise

    # Create a UDS socket
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

    print('starting up on %s' % server_address)
    sock.bind(server_address)

    # Listen for incoming connections
    sock.listen(1)

    while True:
        # Wait for a connection
        print('waiting for a connection')
        connection, client_address = sock.accept()
        try:
            print('connection from', client_address)

            # Receive the data in small chunks and retransmit it
            while True:
                data = connection.recv(128)
                print('received "%s"' % data)

                if data:
                    try:
                        result = subprocess.getoutput(data.decode().strip())
                        if result:
                            connection.sendall(result.encode())
                        else:
                            connection.sendall("command did not generate any output\n".encode())
                    except Exception as e:
                        connection.sendall(('error executing "%s"\n' % e).encode())
                else:
                    print('no more data from', client_address)
                    break
                
        finally:
            # Clean up the connection
            connection.close()