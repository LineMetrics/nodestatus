%%%-------------------------------------------------------------------
%% @doc nodestatus top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(nodestatus_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    Ps =
    [
    % ETS Table Manager
    {ns_ets,
        {ns_ets, start_link, []},
        permanent, 1000, worker, dynamic}

    ],

    {ok, { {one_for_all, 10, 10}, Ps} }.

%%====================================================================
%% Internal functions
%%====================================================================
