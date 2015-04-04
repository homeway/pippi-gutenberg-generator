%% -*- mode: nitrogen -*-
-module(myres).
-export([init/0, create/1, create/2, get/1, update/2, delete/1, all/0]).
-include_lib("stdlib/include/qlc.hrl").

-define(Tab, ?MODULE).

%% nosqlite use mnesia as backend default

init() ->
    nosqlite:create_table(myres, ram).

create(Data) ->
    T = nosqlite:table(?Tab),
    T:create(Data).

create(Id, Data) ->
    T = nosqlite:table(?Tab),
    T:create(Id, Data).

get(Id) ->
    T = nosqlite:table(?Tab),
    T:get(Id).

update(Id, Data) ->
    T = nosqlite:table(?Tab),
    T:update(Id, Data).

delete(Id) ->
    T = nosqlite:table(?Tab),
    T:delete(Id).

all() ->
    T = nosqlite:table(?Tab),
    T:all(?Tab).
