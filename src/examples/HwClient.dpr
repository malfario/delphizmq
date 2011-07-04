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
  SysUtils, zmq, ZMQContext, ZMQSocket, ZMQMessage;

var
  context: TZMQContext;
  socket: TZMQSocket;
  request_nbr: Integer;
  request, reply: TZMQMessage;
  req_data: Pointer;
begin

  context := TZMQContext.Create(0);
  socket := TZMQSocket.Create(context, ZMQ_REQ);

  try
    try
      writeln('Connecting to hello world server...');
      socket.Connect(PChar('tcp://localhost:5555'));

      for request_nbr := 0 to 9 do
      begin
        request := TZMQMessage.Create(6);
        req_data := request.Data;
        move('Hello', req_data, 5);
        writeln(format('Sending Hello %d...', [request_nbr]));
        socket.Send(request);

        reply := TZMQMessage.Create();
        socket.Recv(reply);
        writeln(format('Received Wolrd %d', [request_nbr]));
      end;
    except
      on E: EZMQException do
        writeln('Error: '+E.Message);
    end;
  finally
    socket.Free;
    context.Free;
  end;

end.
