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

unit ZMQSocket;

interface
uses
  zmq, ZMQContext, ZMQMessage;

const
  EAGAIN = 11;	{ errno Try again } // rlc: Is it 11 or 35 ?

type
  TZMQSocket = class
  private
    _ptr: Pointer;
  public
    constructor Create(context: TZMQContext; itype: Integer); reintroduce;
    destructor Destroy; override;
    procedure Close;
    procedure SetSockOpt(option: Integer; const optval: Pointer; optvallen: Cardinal);
    procedure GetSockOpt(option: Integer; optval: Pointer; var optvallen: Cardinal);
    procedure Bind(const addr: PChar);
    procedure Connect(const addr: PChar);
    function Send(msg: TZMQMessage; flags: Integer = 0): Boolean;
    function Recv(msg: TZMQMessage; flags: Integer = 0): Boolean;
    property ptr: Pointer read _ptr;
  end;

implementation


{-----------------------------------}
{-----------------------------------}
{ TSocket }
{-----------------------------------}
constructor TZMQSocket.Create(context: TZMQContext; itype: Integer);
begin
  _ptr := zmq_socket(context.ptr, itype);
  
  if _ptr = nil then
    raise EZMQException.Create();
end;

{-----------------------------------}
destructor TZMQSocket.Destroy;
begin
  self.Close();
  inherited;
end;

{-----------------------------------}
procedure TZMQSocket.Bind(const addr: PChar);
var
  rc: Integer;
begin
  rc := zmq_bind(_ptr, addr);
  
  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
procedure TZMQSocket.Close;
var
  rc: Integer;
begin
  if _ptr = nil then exit;

  rc := zmq_close(_ptr);
  if rc <> 0 then
    raise EZMQException.Create();

  _ptr := nil;
end;

{-----------------------------------}
procedure TZMQSocket.Connect(const addr: PChar);
var
  rc: Integer;
begin
  rc := zmq_connect(_ptr, addr);

  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
procedure TZMQSocket.GetSockOpt(option: Integer; optval: Pointer;
    var optvallen: Cardinal);
var
  rc: Integer;
begin
  rc := zmq_getsockopt(_ptr, option, optval, optvallen);

  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
function TZMQSocket.Recv(msg: TZMQMessage; flags: Integer): Boolean;
var
  rc: Integer;
begin
  rc := zmq_recv(_ptr, @(msg.ptr), flags);

  if rc = 0 then
    result := true
  else if (rc = -1) and (zmq_errno() = EAGAIN) then
    result := false
  else
    raise EZMQException.Create();
end;

{-----------------------------------}
function TZMQSocket.Send(msg: TZMQMessage; flags: Integer): Boolean;
var
  rc: Integer;
begin
  rc := zmq_send(_ptr, @(msg.ptr), flags);

  if rc = 0 then
    result := true
  else if (rc = -1) and (zmq_errno() = EAGAIN) then
    result := false
  else
    raise EZMQException.Create();
end;

{-----------------------------------}
procedure TZMQSocket.SetSockOpt(option: Integer; const optval: Pointer;
  optvallen: Cardinal);
var
  rc: Integer;
begin
  rc := zmq_setsockopt(_ptr, option, optval, optvallen);
  if rc <> 0 then
    raise EZMQException.Create();
end;

end.
