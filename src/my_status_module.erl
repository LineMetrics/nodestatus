%% Date: 17.01.17 - 16:16
%% Ⓒ 2017 LineMetrics GmbH
%%
%% example status callback
-module(my_status_module).
-author("Alexander Minichmair").

-behaviour(status_callback).

%% API
-export([get_status/0]).


get_status() ->
   {true, #{<<"status">> => <<"normal">>}}.