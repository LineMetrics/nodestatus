%%%-------------------------------------------------------------------
%% @doc nodestatus public API
%% @end
%%%-------------------------------------------------------------------

-module(nodestatus_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Sup = nodestatus_sup:start_link(),
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%  cowboy http & routes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Routes = [
        {'_', [
            {"/status/", status_handler, []},
            {"/debug/", debug_handler, []}
        ]}
    ],

    DispatchHWBox = cowboy_router:compile(Routes),

    %% HTTP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% get port from env
    Port = application:get_env(nodestatus, http_port, 8003),
    {ok, InfoHttp} = cowboy:start_http(http, 2,
        [{port, Port}],
        [
            {env, [{dispatch, DispatchHWBox}]}
        ]
    ),
    io:format("*** nodestatus http cowboy started: ~p~n", [InfoHttp]),
    Sup.

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
