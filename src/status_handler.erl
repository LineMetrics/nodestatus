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
   PortCount = erlang:system_info(port_count),
   ProcessCount = erlang:system_info(process_count),
   {Uptime, _Last} = erlang:statistics(wall_clock),
   {{input, In}, {output, Out}} = IORes = erlang:statistics(io),
   Now = unix_timestamp(),
   {NewTime, OldIn, OldOut} =
      case ets:lookup(ns_stats, io) of
         [] ->
            {0,0,0};
         [{io, OldTime, {{input, OIn}, {output, OOut}}}] ->
            {Now-OldTime, OIn, OOut}
      end,
   ets:insert(ns_stats,{io, Now, IORes}),

   Info = #{
      <<"ports">> => PortCount, <<"processes">> => ProcessCount, <<"uptime">> => Uptime,
      <<"ioin">> => In - OldIn, <<"ioout">> => Out - OldOut, <<"iotimespan">> => NewTime,
      <<"node">> => list_to_binary(atom_to_list(node()))
   },

   {MsgMap, StatusCode} =
   case app_check:do() of
      true ->
         case (catch call_status()) of
            {true, R}   -> {R, 200};
            {false, R}  -> {R, 503};
            _           -> {#{}, 503}
         end;
      false ->
         {#{<<"status">> => <<"problems">>,
            <<"problems">> => [<<"not_all_apps_running">>, <<"need restart">>]}, 503}
   end,
   {ok, Req} = cowboy_req:reply(StatusCode, ?HEADERS, jsx:encode(maps:merge(Info,MsgMap)), Req0),
   {ok, Req, S}.

call_status() ->
   case application:get_env(nodestatus, mod) of
      undefined -> {true, #{}};
      {ok, Module} -> Module:get_status()
   end.

terminate(_Reason, _Req, _State) ->
   ok.

unix_timestamp() ->
   LocalDateTime = calendar:datetime_to_gregorian_seconds({date(),time()}),
   UnixEpoch = calendar:datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}}),
   (LocalDateTime - UnixEpoch) * 1000
.