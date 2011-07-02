// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program HwServer;

{$APPTYPE CONSOLE}

uses
  SysUtils, zmq, windows;

var
  context, responder: Pointer;
  request, reply: PZMQMsg;
begin
  GetMem(request, SizeOf(request));
  GetMem(reply, SizeOf(reply));

  try
    try
      context := zmq_init(1);

      responder := zmq_socket(context, ZMQ_REP);
      zmq_bind(responder, 'tcp://*:5555');

      while true do
      begin
        zmq_msg_init(request);
        zmq_recv(responder, request, 0);
        writeln('Received Hello...');
        zmq_msg_close(request);

        sleep(1);

        zmq_msg_init_size(reply, 5);
        CopyMemory(zmq_msg_data(reply), PChar('World'), 5);
        zmq_send(responder, reply, 0);
        zmq_msg_close(reply);
      end;

      zmq_close(responder);
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
