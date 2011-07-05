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

unit ZMQMessage;

interface
uses
  zmq;
  
type
  TZMQMessage = class
  private
    _msg: TZMQMsg;
    function _data: Pointer;
    function _size: Cardinal;
  public
    constructor Create; overload;
    constructor Create(size: Cardinal); overload;
    constructor Create(data: Pointer; size: Cardinal; ffn: TZMQFreeFn;
        hint: Pointer); overload;
    destructor Destroy; override;
    procedure Rebuild; overload;
    procedure Rebuild(size: Cardinal); overload;
    procedure Rebuild(data: Pointer; size: Cardinal; ffn: TZMQFreeFn;
        hint: Pointer = nil); overload;
    procedure Move(msg: PZMQMsg);
    procedure Copy(msg: PZMQMsg);
    property Data: Pointer read _data;
    property Size: Cardinal read _size;
    property ptr: TZMQMsg read _msg;
  end;

implementation

{-----------------------------------}
{-----------------------------------}
{ TZMQMessage }
{-----------------------------------}
constructor TZMQMessage.Create;
var
  rc: Integer;
begin
  rc := zmq_msg_init(@_msg);
  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
constructor TZMQMessage.Create(data: Pointer; size: Cardinal; ffn: TZMQFreeFn;
  hint: Pointer);
var
  rc: Integer;
begin
  rc := zmq_msg_init_data(@_msg, data, size, ffn, hint);
  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
constructor TZMQMessage.Create(size: Cardinal);
var
  rc: Integer;
begin
  rc := zmq_msg_init_size(@_msg, size);
  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
destructor TZMQMessage.Destroy;
var
  rc: Integer;
begin
  rc := zmq_msg_close(@_msg);
  assert(rc = 0);
  inherited;
end;

{-----------------------------------}
procedure TZMQMessage.Copy(msg: PZMQMsg);
var
  rc: Integer;
begin
  rc := zmq_msg_copy(@_msg, msg);
  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
procedure TZMQMessage.Move(msg: PZMQMsg);
var
  rc: Integer;
begin
  rc := zmq_msg_move(@_msg, msg);
  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
procedure TZMQMessage.Rebuild(data: Pointer; size: Cardinal; ffn: TZMQFreeFn;
  hint: Pointer);
var
  rc: Integer;
begin
  rc := zmq_msg_close(@_msg);
  if rc <> 0 then
    raise EZMQException.Create();

  rc := zmq_msg_init_data(@_msg, data, size, ffn, hint);
  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
procedure TZMQMessage.Rebuild;
var
  rc: Integer;
begin
  rc := zmq_msg_close(@_msg);
  if rc <> 0 then
    raise EZMQException.Create();

  rc := zmq_msg_init(@_msg);
  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
procedure TZMQMessage.Rebuild(size: Cardinal);
var
  rc: Integer;
begin
  rc := zmq_msg_close(@_msg);
  if rc <> 0 then
    raise EZMQException.Create();

  rc := zmq_msg_init_size(@_msg, size);
  if rc <> 0 then
    raise EZMQException.Create();
end;

{-----------------------------------}
function TZMQMessage._data: Pointer;
begin
  result := zmq_msg_data(@_msg);
end;

{-----------------------------------}
function TZMQMessage._size: Cardinal;
begin
  result := zmq_msg_size(@_msg);
end;
end.
