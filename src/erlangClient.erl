%% Authors Christian Dakermandji, Thomas Brander

-module(erlangClient).

-export([start_link/2, stop/1]).
-export([release_cycle/1, secure_cycle/1, get_info/1]).



stop(Ref) -> gen_fsm:sync_send_event(Ref, stop). 

start_link(Total, Occupied) ->
	{ok, Ref} =erlangvilleServer:start_link(Total, Occupied).
	

release_cycle(Ref) ->
	gen_fsm:sync_send_event(Ref, release).


secure_cycle(Ref) ->
	gen_fsm:sync_send_event(Ref, secure).

get_info(Ref) ->
	gen_fsm:sync_send_all_state_event(Ref, info).