(*
    Copyright (c) 2007-2011 iMatix Corporation
    Copyright (c) 2007-2011 Other contributors as noted in the AUTHORS file

    This file is part of 0MQ.

    0MQ is free software; you can redistribute it and/or modify it under
    the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    0MQ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)

unit zmq;

interface
uses
  Winsock;
  
const
LIBZMQ = 'libzmq.dll';

{-----------------------------------}
{-----------------------------------}
{ 0MQ errors definition.             }
{-----------------------------------}
ZMQ_HAUSNUMERO = 156384712;

(* On Windows platform some of the standard POSIX errnos are not defined. *)
ENOTSUP = (ZMQ_HAUSNUMERO + 1);
EPROTONOSUPPORT = (ZMQ_HAUSNUMERO + 2);
ENOBUFS = (ZMQ_HAUSNUMERO + 3);
ENETDOWN = (ZMQ_HAUSNUMERO + 4);
EADDRINUSE = (ZMQ_HAUSNUMERO + 5);
EADDRNOTAVAIL = (ZMQ_HAUSNUMERO + 6);
ECONNREFUSED = (ZMQ_HAUSNUMERO + 7);
EINPROGRESS = (ZMQ_HAUSNUMERO + 8);
ENOTSOCK = (ZMQ_HAUSNUMERO + 9);

(* Native 0MQ error codes. *)
EFSM = (ZMQ_HAUSNUMERO + 51);
ENOCOMPATPROTO = (ZMQ_HAUSNUMERO + 52);
ETERM = (ZMQ_HAUSNUMERO + 53);
EMTHREAD = (ZMQ_HAUSNUMERO + 54);

{-----------------------------------}
{-----------------------------------}
{ 0MQ message definition.           }
{-----------------------------------}
ZMQ_MAX_VSM_SIZE = 30;

ZMQ_DELIMITER = 31;
ZMQ_VSM = 32;

ZMQ_MSG_MORE = 1;
ZMQ_MSG_SHARED = 128;
ZMQ_MSG_MASK = 129; // Merges all the flags

{-----------------------------------}
{-----------------------------------}
{ 0MQ socket definition.            }
{-----------------------------------}
(*  Socket types. *)
ZMQ_PAIR = 0;
ZMQ_PUB = 1;
ZMQ_SUB = 2;
ZMQ_REQ = 3;
ZMQ_REP = 4;
ZMQ_DEALER = 5;
ZMQ_ROUTER = 6;
ZMQ_PULL = 7;
ZMQ_PUSH = 8;
ZMQ_XPUB = 9;
ZMQ_XSUB = 10;
ZMQ_XREQ = ZMQ_DEALER;
ZMQ_XREP = ZMQ_ROUTER;
ZMQ_UPSTREAM = ZMQ_PULL;
ZMQ_DOWNSTREAM = ZMQ_PUSH;

(* Socket options. *)
ZMQ_HWM = 1;
ZMQ_SWAP = 3;
ZMQ_AFFINITY = 4;
ZMQ_IDENTITY = 5;
ZMQ_SUBSCRIBE = 6;
ZMQ_UNSUBSCRIBE = 7;
ZMQ_RATE = 8;
ZMQ_RECOVERY_IVL = 9;
ZMQ_MCAST_LOOP = 10;
ZMQ_SNDBUF = 11;
ZMQ_RCVBUF = 12;
ZMQ_RCVMORE = 13;
ZMQ_FD = 14;
ZMQ_EVENTS = 15;
ZMQ_TYPE = 16;
ZMQ_LINGER = 17;
ZMQ_RECONNECT_IVL = 18;
ZMQ_BACKLOG = 19;
ZMQ_RECOVERY_IVL_MSEC = 20;
ZMQ_RECONNECT_IVL_MAX = 21;

(*  Send/recv options. *)
ZMQ_NOBLOCK = 1;
ZMQ_SNDMORE = 2;


{-----------------------------------}
{-----------------------------------}
{ I/O multiplexing definitions.     }
{-----------------------------------}
ZMQ_POLLIN = 1;
ZMQ_POLLOUT = 2;
ZMQ_POLLERR = 4;

{-----------------------------------}
{-----------------------------------}
{ Built-in devices defs.            }
{-----------------------------------}
ZMQ_STREAMER = 1;
ZMQ_FORWARDER = 2;
ZMQ_QUEUE = 3;

type
TZMQMsg = packed record
  content: Pointer;
  flags: Byte;
  vsm_size: Byte;
  vsm_data: Array [0..ZMQ_MAX_VSM_SIZE-1] of Char;
end;
PZMQMsg = ^TZMQMsg;

TZMQFreeFn = procedure(data, hint: Pointer);

TZMQPollItem = packed record
  socket: Pointer;
  fd: TSocket;
  events: ShortInt;
  revents: ShortInt;
end;
PZMQPollItem = ^TZMQPollItem;

{-----------------------------------}
{-----------------------------------}
{ Run-time API version detection.   }
{-----------------------------------}
// ZMQ_EXPORT void zmq_version (int *major, int *minor, int *patch);
procedure zmq_version(major, minot, patch: Integer); cdecl; external LIBZMQ;

{-----------------------------------}
{-----------------------------------}
{ Error handling                    }
{-----------------------------------}
(* Errnum from zmq side. *)
// ZMQ_EXPORT int zmq_errno (void);
function zmq_errno: Integer; cdecl; external LIBZMQ;

(*  Resolves system errors and 0MQ errors to human-readable string. *)
//ZMQ_EXPORT const char *zmq_strerror (int errnum);
function zmq_strerror(errnum: Integer): PChar; cdecl; external LIBZMQ;

{-----------------------------------}
{-----------------------------------}
{ Message functions                 }
{-----------------------------------}
//ZMQ_EXPORT int zmq_msg_init (zmq_msg_t *msg);
function zmq_msg_init(msg: PZMQMsg): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_msg_init_size (zmq_msg_t *msg, size_t size);
function zmq_msg_init_size(msg: PZMQMsg; size: Cardinal): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_msg_init_data (zmq_msg_t *msg, void *data,
//    size_t size, zmq_free_fn *ffn, void *hint);
function zmq_msg_init_data(msg: PZMQMsg; data: Pointer; size: Cardinal;
  zmq_free_fn: TZMQFreeFn; hint: Pointer): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_msg_close (zmq_msg_t *msg);
function zmq_msg_close(msg: PZMQMsg): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_msg_move (zmq_msg_t *dest, zmq_msg_t *src);
function zmq_msg_move(dest, src: PZMQMsg): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_msg_copy (zmq_msg_t *dest, zmq_msg_t *src);
function zmq_msg_copy(dest, src: PZMQMsg): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT void *zmq_msg_data (zmq_msg_t *msg);
function zmq_msg_data(msg: PZMQMsg): Pointer; cdecl; external LIBZMQ;

//ZMQ_EXPORT size_t zmq_msg_size (zmq_msg_t *msg);
function zmq_msg_size(msg: PZMQMsg): Cardinal; cdecl; external LIBZMQ;

{-----------------------------------}
{-----------------------------------}
{ 0MQ infrastructure initialisation }
{ & termination.                    }
{-----------------------------------}
//ZMQ_EXPORT void *zmq_init (int io_threads);
function zmq_init(io_threads: Integer): Pointer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_term (void *context);
function zmq_term(context: Pointer): Integer; cdecl; external LIBZMQ;

{-----------------------------------}
{-----------------------------------}
{ 0MQ socket.                       }
{-----------------------------------}
//ZMQ_EXPORT void *zmq_socket (void *context, int type);
function zmq_socket(context: Pointer; itype: Integer): Pointer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_close (void *s);
function zmq_close(s: Pointer): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_setsockopt (void *s, int option, const void *optval,
//    size_t optvallen);
function zmq_setsockopt(s: Pointer; option: Integer; const optval: Pointer;
  optvallen: Cardinal): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_getsockopt (void *s, int option, void *optval,
//    size_t *optvallen);
function zmq_getsockopt(s: Pointer; option: Integer; optval: Pointer;
  var optvallen: Cardinal): Integer; cdecl; external LIBZMQ;
   
//ZMQ_EXPORT int zmq_bind (void *s, const char *addr);
function zmq_bind(s: Pointer; const addr: PChar): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_connect (void *s, const char *addr);
function zmq_connect(s: Pointer; const addr: PChar): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_send (void *s, zmq_msg_t *msg, int flags);
function zmq_send(s: Pointer; msg: PZMQMsg; flags: Integer): Integer; cdecl; external LIBZMQ;

//ZMQ_EXPORT int zmq_recv (void *s, zmq_msg_t *msg, int flags);
function zmq_recv(s: Pointer; msg: PZMQMsg; flags: Integer): Integer; cdecl; external LIBZMQ;

{-----------------------------------}
{-----------------------------------}
{ I/O multiplexing.                 }
{-----------------------------------}
//ZMQ_EXPORT int zmq_poll (zmq_pollitem_t *items, int nitems, long timeout);
function zmq_poll(items: PZMQPollItem; nitems: Integer;
  timeout: Longint): Integer; cdecl; external LIBZMQ;

{-----------------------------------}
{-----------------------------------}
{ Built-in devices                  }
{-----------------------------------}
//ZMQ_EXPORT int zmq_device (int device, void * insocket, void* outsocket);
function zmq_device(device: Integer; insocket,
  outsocket: Pointer): Integer; cdecl; external LIBZMQ;


implementation

end.
