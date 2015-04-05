%%%
%%% you should edit this file to manage how to start applications
%%%
-module(config).
-export([auto_run/0, auto_test/0]).

apps() -> [crypto, cowlib, ranch, cowboy, pippi, {{NAME}}, mnesia, sync, odbc].

auto_run() -> [application:start(A) || A <- apps()].

auto_test() ->
    Apps = apps() ++ [sample],
    [application:start(A) || A <- Apps],

    reset_test_data(),

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

reset_test_data() ->
    %% table pp_account
    nosqlite:create_table(pp_account, ram),
    nosqlite:clear_table(pp_account),
    A = nosqlite:table(pp_account),
    Users = [
        #{user=> <<"adi">>, pass=> <<"123">>, roles=> [editor]},
        #{user=> <<"admin">>, pass=> <<"123">>, roles=> [admin]}
    ],
    [A:create(User) || User <- Users],

    %% table pp_role
    nosqlite:create_table(pp_role, ram),
    nosqlite:clear_table(pp_role),
    R = nosqlite:table(pp_role),
    Roles = [
        {everyone, #{methods=> [[users, [all, get, size]]]}},
        {editor, #{methods=> [[users, [create, update]]]}},
        {admin, #{methods=> [users]}}
    ],
    [R:create(Id, Role) || {Id, Role} <- Roles].
