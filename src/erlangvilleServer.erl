%% Authors Christian Dakermandji, Thomas Brander

-module(erlangvilleServer).
-behaviour(gen_fsm).


-export([start_link/2, init/1, terminate/3, handle_sync_event/4]).
-export([empty/3, full/3, idle/3]).


start_link(Total, Occupied) ->
 gen_fsm:start_link({local, ?MODULE}, ?MODULE, {Total, Occupied}, []). 

init({Total, Occupied}) ->
	{ok, idle, {Total, Occupied}}.

%% Terminate
terminate(Reason, StateName, LoopData) -> ok.


%% IDLE STATE
idle(release, From, {Total, Occupied}) when Occupied==1 ->
	{reply, ok, empty, {Total, Occupied-1}};
idle(release, From, {Total, Occupied}) when Occupied > 1 ->
	{reply, ok, idle, {Total, Occupied-1}};
idle(secure, From, {Total, Occupied}) when Occupied == (Total-1) ->
	{reply, ok, full, {Total, Occupied+1}};
idle(secure, From, {Total, Occupied}) when Occupied < (Total-1) ->
	{reply, ok, idle, {Total, Occupied+1}};
idle(info, From, {Total, Occupied}) ->
	{reply, getInfo(Total, Occupied), idle, {Total, Occupied}}.

%%EMPTY STATE

handle_sync_event(info,From, StateName, {Total, Occupied}) ->
    {reply, getInfo(Total, Occupied), StateName, {Total, Occupied}}.

empty(secure, From, {Total, Occupied}) ->
	{reply, ok, idle, {Total, Occupied+1}};
empty(info, From, {Total, Occupied}) ->
	{reply, getInfo(Total, Occupied), empty, {Total, Occupied}};
empty(_Other, From, {Total, Occupied})->
	{reply, {error, empty}, empty, {Total, Occupied}}.


%% FULL STATE 
full(release, From, {Total, Occupied}) ->
	{reply, ok, idle, {Total, Occupied-1}};
full(info, From, {Total, Occupied}) ->
	{reply, getInfo(Total, Occupied), full, {Total, Occupied}};
full(_Other, From, {Total, Occupied})->
	{reply, {error, full}, full, {Total, Occupied}}.



getInfo(Total, Occupied) ->
	{ok, [{total, Total}, {occupied, Occupied}, {free, (Total-Occupied)}]}.

	