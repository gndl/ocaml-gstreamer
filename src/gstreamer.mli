exception Error
exception End_of_stream

val init : ?argv:(string array) -> unit -> unit

val deinit : unit -> unit

val version : unit -> int * int * int * int

val version_string : unit -> string

type state =
| State_void_pending
| State_null
| State_ready
| State_paused
| State_playing

val string_of_state : state -> string

type state_change =
| State_change_sucess
| State_change_async
| State_change_no_preroll

module Element : sig
  type t

  val set_property_string : t -> string -> string -> unit

  val set_property_int : t -> string -> string -> unit

  val set_property_bool : t -> string -> string -> unit

  val set_state : t -> state -> state_change

  val get_state : t -> state_change * state * state

  val link : t -> t -> unit

  val link_many : t list -> unit
end

module Element_factory : sig
  type t = Element.t

  val make : string -> string -> t
end

module Bin : sig
  type t = Element.t

  val of_element : Element.t -> t

  val add : t -> Element.t -> unit

  val add_many : t -> Element.t list -> unit

  val get_by_name : t -> string -> Element.t
end

module Pipeline : sig
  type t = Element.t

  val create : string -> t

  val parse_launch : string -> t
end

module App_src : sig
  type t

  val to_element : t -> Element.t

  val of_element : Element.t -> t

  val push_buffer_string : t -> string -> unit

  val connect_need_data : t -> (int -> unit) -> unit

  val end_of_stream : t -> unit
end

module App_sink : sig
  type t = Element.t

  val of_element : Element.t -> t

  val pull_buffer : t -> (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

  val pull_buffer_string : t -> string

  val is_eos : t -> bool
end