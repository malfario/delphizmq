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

unit ZMQContext;

interface

uses
  zmq;

type
  TZMQContext = class
  private
    _ptr: Pointer;
  public
    constructor Create(io_threads: Integer);
    destructor Destroy; override;
    property ptr: Pointer read _ptr;
  end;

implementation

{-----------------------------------}
{-----------------------------------}
{ TZMQContext }
{-----------------------------------}
constructor TZMQContext.Create(io_threads: Integer);
begin
  _ptr := zmq_init(io_threads);
  if _ptr = nil then
    raise EZMQException.Create();
end;

{-----------------------------------}
destructor TZMQContext.Destroy;
var
  rc: Integer;
begin
  rc := zmq_term(_ptr);
  assert(rc = 0);  
  inherited;
end;

end.
