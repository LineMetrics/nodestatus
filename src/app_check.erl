%% Date: 17.01.17 - 14:30
%% Ⓒ 2017 LineMetrics GmbH
-module(app_check).
-author("Alexander Minichmair").

%% API
-export([do/0]).


%% check if all needed applications are running
do() ->

   %% get applications from the .app file of the main application

   {ok,AppMod} = application:get_env(nodestatus, app_src_mod),
   AppSource = code:where_is_file(AppMod++".app"),
   {ok, [{application, ThisAppName, AppInfos}]} = file:consult(AppSource),
   %% add the 'main' application name
   AllAppNames = [ThisAppName | proplists:get_value(applications, AppInfos)],

   %% get running applications
   Apps = application:which_applications(),
   lists:all(fun(App) -> lists:keytake(App, 1, Apps) /= false end, AllAppNames).
