"""
Launch the server in the commandline with valid arguments.

Valid instruction format: python(v) filename ip:port . v is the version
of python. py3 is not applicable. I recommand python2.7

A valid instruction should like: python2.7 server.py 10.10.10.10:8080

or it will give the exception notes and kill itself

"""
import socket
import time
import sys

args = sys.argv

host = 'localhost'
port = 58000
BUFSIZ = 1024

try:
    host,port = args[1].strip().split(":")
    addr = (host, int(port))
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(addr)
    s.listen(5)
except:
    print 'invalid address for server. Please check the launch order.'
    print 'A valid order should like: python filename.py ip:port'
    exit(0)

while True:
    conn, client=s.accept()
    print('connect from ', addr)
    data = conn.recv(1024)
    print 'receive data:',data
    conn.send(data)
