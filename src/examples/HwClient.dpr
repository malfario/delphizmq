(*
    Copyright (c) 2011 Rafael Leblic.

    This file is part of delphizmq.

    delphizmq is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    delphizmq is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with delphizmq.  If not, see <http://www.gnu.org/licenses/>.
*)

// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF

program HwClient;

{$APPTYPE CONSOLE}

uses
  SysUtils, zmq, Windows;

var
  context, requester: Pointer;
  request_nbr: Integer;
  request, reply: PZMQMsg;
begin
  GetMem(request, SizeOf(request));
  GetMem(reply, SizeOf(reply));

  try
    try
      context := zmq_init(1);

      writeln('Connecting to hello world server...');
      requester := zmq_socket(context, ZMQ_REQ);
      zmq_connect(requester, 'tcp://localhost:5555');

      for request_nbr := 0 to 9 do
      begin
        zmq_msg_init_size(request, 5);
        CopyMemory(zmq_msg_data(request), PChar('Hello'), 5);
        writeln(format('Sending Hello %d...', [request_nbr]));
        zmq_send(requester, request, 0);
        zmq_msg_close(request);

        zmq_msg_init(reply);
        zmq_recv(requester, reply, 0);
        writeln(format('Received World %d...', [request_nbr]));
        zmq_msg_close(reply);
      end;

      zmq_close(requester);
      zmq_term(context);
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;
  finally
    FreeMem(reply);
    FreeMem(request);
  end;
end.
