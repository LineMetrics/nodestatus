%% Date: 18.01.17 - 13:19
%% Ⓒ 2017 LineMetrics GmbH
-module(status_callback).
-author("Alexander Minichmair").

%% API
-export([]).

-callback get_status() -> {true, map()} | {false, map()}.
