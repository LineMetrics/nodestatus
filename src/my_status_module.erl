%% Date: 17.01.17 - 16:16
%% Ⓒ 2017 LineMetrics GmbH
-module(my_status_module).
-author("Alexander Minichmair").

%% API
-export([get_status/0]).


get_status() ->
   #{<<"status">> => <<"normal">>}.