%%%
%%% you should edit this file to manage how to start applications
%%%
-module(config).
-export([start/0]).

apps() -> [crypto, cowlib, ranch, cowboy, pippi, erp, mnesia, sync, odbc].

auto_run() -> [application:start(A) || A <- apps()].

auto_test() ->
    Apps = [sample|apps()],
    [application:start(A) || A <- Apps],
    RunTests = fun(Mods) ->
        ToTest1 = [Mod || Mod <- Mods, erlang:function_exported(Mod, test, 0)],
        ToTest2 = lists:filtermap(fun(M) ->
            M2 = list_to_atom(atom_to_list(M) ++ "_test"),
            code:ensure_loaded(M2),
            case erlang:function_exported(M2, test, 0) of
                true -> {true, M2};
                _ -> false
            end
        end, Mods),
        lists:map(fun(M) ->
            case M:test() of
                ok ->
                    sync_notify:growl_success("test ok");
                _ ->
                    sync_notify:growl_errors("test failed")
            end
        end, lists:flatten(ToTest1 ++ ToTest2))
    end,
    sync:onsync(RunTests).
