%% Feel free to use, reuse and abuse the code in this file.

%% @doc rest api handler
-module(debug_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).


init(_Transport, Req, []) ->
     %% set lager meta-data
     {ok, Req, []}.

handle(Req, S) ->
%%    session_manager:ping(DeviceId), %% async ping
   cowboy_req:reply(200, [{<<"connection">>, <<"close">>}], Req),
   {ok, Req, S}.

terminate(_Reason, _Req, _State) ->
   ok.


%%%%%%% internal