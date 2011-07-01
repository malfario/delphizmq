// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program HwServer;

{$APPTYPE CONSOLE}

uses
  SysUtils, zmq;

var
  context, responder, msg_data: Pointer;
  request, reply: TZMQMsg;
  
begin
  try
    context := zmq_init(1);

    responder := zmq_socket(context, ZMQ_REP);
    zmq_bind(responder, 'tcp://*:5555');

    while true do
    begin
      zmq_msg_init(@request);
      zmq_recv(responder, @request, 0);
      writeln('Received Hello...');
      zmq_msg_close(@request);

      sleep(1);

      zmq_msg_init_size(@reply, 5);
      msg_data := zmq_msg_data(@reply);
      move('World', msg_data, 5);
      zmq_send(responder, @reply, 0);
      zmq_msg_close(@reply);
    end;

    zmq_close(responder);
    zmq_term(context);

  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
