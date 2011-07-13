(*
  Zeromq socket abstraction for string messages.

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
 
unit ZMQStringSocket;

interface
uses
  zmq, ZMQMessage, ZMQSocket, Windows, SysUtils;

type
  TZMQStringMessage = class(TZMQMessage)
  public
    constructor Create(txt: String); overload;
    function Text: String;
  end;

  TZMQStringSocket = class(TZMQSocket)
  public
    function Send(msg: String): Boolean;
    function Recv: String;
  end;

const
  nullterm: Char = #0;
  
implementation

{-----------------------------------}
{-----------------------------------}
{ TZMQStringSocket }
{-----------------------------------}
function TZMQStringSocket.Recv: String;
var
  msg: TZMQStringMessage;
begin
  result := '';
  msg := TZMQStringMessage.Create();

  try
    if (inherited Recv(msg, 0)) then
      result := msg.Text;
  finally
    msg.Free;
  end;
end;

{-----------------------------------}
function TZMQStringSocket.Send(msg: String): Boolean;
var
  smsg: TZMQStringMessage;
begin
  smsg := TZMQStringMessage.Create(msg);
  try
    result := inherited Send(smsg, 0);
  finally
    smsg.Free;
  end;
end;

{-----------------------------------}
{-----------------------------------}
{ TZMQStringMessage }
{-----------------------------------}
constructor TZMQStringMessage.Create(txt: String);
begin
  inherited Create(length(txt));
  CopyMemory(self.Data, PChar(txt), length(txt));
end;

{-----------------------------------}
function TZMQStringMessage.Text: String;
var
  pc: PChar;
begin
  GetMem(pc, self.Size+1);
  try
    CopyMemory(pc, self.Data, self.Size);
    pc[self.Size] := nullterm; // Null term string
    result := pc;
  finally
    FreeMem(pc);
  end;
end;

end.
