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

program HwServer;

{$APPTYPE CONSOLE}

uses
  SysUtils, zmq, ZMQContext, ZMQSocket, ZMQMessage;

var
  context: TZMQContext;
  socket: TZMQSocket;
  request, reply: TZMQMessage;
  data: Pointer;
begin
  context := TZMQContext.Create(1);
  socket := TZMQSocket.Create(context, ZMQ_REP);
  socket.Bind('tcp://*:5555');

  while true do
  begin
      request := TZMQMessage.Create;
      socket.Recv(request);
      writeln('Received Hello');
      request.Free;

      sleep(1);

      reply := TZMQMessage.Create(5);
      data := reply.Data;
      move('World', data, 5);
      socket.Send(reply);
      reply.Free;
  end;
end.
