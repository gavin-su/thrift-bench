#!/usr/bin/env python

import sys
sys.path.append('gen-py')

from bench import BenchService
from bench.ttypes import *

from thrift.transport import TSocket
from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol
from thrift.server import TServer
from thrift.server.TProcessPoolServer import TProcessPoolServer
from thrift.server.TNonblockingServer import TNonblockingServer

import socket

class BenchHandler:
  def __init__(self):
    self.log = {}

  def test(self,v):
    return 0

try:
    handler = BenchHandler()
    processor = BenchService.Processor(handler)
    transport = TSocket.TServerSocket(port=54343)
    tfactory = TTransport.TBufferedTransportFactory()
    pfactory = TBinaryProtocol.TBinaryProtocolFactory()

    #case 1
    #server = TProcessPoolServer(processor, transport, tfactory, pfactory)

    #case 2
    #server = TServer.TThreadedServer(processor, transport, tfactory, pfactory)

    #case 3
    #server = TServer.TThreadPoolServer(processor, transport, tfactory, pfactory)

    #case 4
    server = TNonblockingServer(processor, transport)

    print "Starting python server..."
    server.serve()
    print "done!"

except:
    print "Unexpected error:", sys.exc_info()
