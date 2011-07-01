// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program HwClient;

{$APPTYPE CONSOLE}

uses
  SysUtils, zmq;

var
  context, requester, msg_data: Pointer;
  request_nbr: Integer;
  request, reply: TZMQMsg;

begin
  try
    context := zmq_init(1);

    writeln('Connecting to hello world server...');
    requester := zmq_socket(context, ZMQ_REQ);
    zmq_connect(requester, 'tcp://localhost:5555');

    for request_nbr := 0 to 9 do
    begin
      zmq_msg_init_size(@request, 5);
      msg_data := zmq_msg_data(@request);
      move('Hello', msg_data, 5);
      writeln(format('Sending Hello %d...', [request_nbr]));
      zmq_send(requester, @request, 0);
      zmq_msg_close(@request);

      zmq_msg_init(@reply);
      zmq_recv(requester, @reply, 0);
      writeln(format('Received World %d...', [request_nbr]));
      zmq_msg_close(@reply);
    end;

    zmq_close(requester);
    zmq_term(context);
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
