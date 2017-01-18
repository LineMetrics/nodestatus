%% Feel free to use, reuse and abuse the code in this file.

%% @doc rest api handler
-module(status_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-define(HEADERS, [{<<"content-type">>, <<"application/json">>}, {<<"content-encoding">>, <<"utf-8">>}]).

init(_Transport, Req, []) ->
     %% set lager meta-data
     {ok, Req, []}.

handle(Req0, S) ->
   {ok, Req} =
   case app_check:do() of
      true ->
         RMap = call_status(),
         cowboy_req:reply(200, ?HEADERS, jsx:encode(RMap), Req0);
      false ->
         cowboy_req:reply(503, ?HEADERS,
            jsx:encode(
               #{<<"status">> => <<"problems">>, <<"problems">> => [<<"not_all_apps_running">>, <<"need restart">>]}
            ), Req0)
   end,
   {ok, Req, S}.

call_status() ->
   case application:get_env(nodestatus, mod) of
      undefined -> #{};
      {ok, Module} -> Module:get_status()
   end.

terminate(_Reason, _Req, _State) ->
   ok.