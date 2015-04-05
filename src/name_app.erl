%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module({{NAME}}_app).
-behaviour(application).

%% API.
-export([start/0, start/2]).
-export([stop/1]).

%% API.
start() -> start(none, none).
start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/ws",    pippi_websocket, []}
		]}
	]),
	{ok, _} = cowboy:start_http(
		http,
		100,
		[{port, 8080}],
		[{env, [{dispatch, Dispatch}]}]
	),
	{{NAME}}_sup:start_link().

stop(_State) ->
	ok.
