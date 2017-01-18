%% Date: 17.01.17 - 13:14
%% Ⓒ 2017 LineMetrics GmbH
-module(nodestatus).
-author("Alexander Minichmair").

%% API
-export([start/0]).

start() ->
   application:ensure_all_started(nodestatus).