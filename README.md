nodestatus
=====

Very small Application to get some status via http from an erlang node.
Erlang Otp on top of cowboy

Erlang Version
--------------
 \>= 17.4

Build
-----

    $ rebar3 compile
    
Configuration
-------------

Example Config :

    [
    {nodestatus,
      [
      %% provide http port to listen on
         {http_port, 8011}, 
         
         %% provide name of .app file as string
         {app_src_mod, "nodestatus"}, 
         
         %% optional callback module, which must have 'get_status/0' exported, this must return a map with status infos
         {mod, my_status_module} 
      ]

    }
    ].
