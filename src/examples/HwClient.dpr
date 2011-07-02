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
