{ pkgs ? import <nixpkgs> { inherit system; }
, system ? builtins.currentSystem
, processManagers ? [ "supervisord" "sysvinit" "systemd" "docker" "disnix" "s6-rc" ]
, profiles ? [ "privileged" "unprivileged" ]
, nix-processmgmt ? ../../nix-processmgmt
}:

let
  testService = import "${nix-processmgmt}/nixproc/test-driver/universal.nix" {
    inherit system;
  };
in
{
  apache = import ./apache {
    inherit pkgs processManagers profiles testService;
  };

  apache-tomcat = import ./apache-tomcat {
    inherit pkgs processManagers profiles testService;
  };

  apache-tomcat-ajp-reverse-proxy = import ./apache-tomcat-ajp-reverse-proxy {
    inherit pkgs processManagers profiles testService;
  };

  influxdb = import ./influxdb {
    inherit pkgs processManagers profiles testService;
  };

  mongodb = import ./mongodb {
    inherit pkgs processManagers profiles testService;
  };

  mysql = import ./mysql {
    inherit pkgs processManagers profiles testService;
  };

  postgresql = import ./postgresql {
    inherit pkgs processManagers profiles testService;
  };

  svnserve = import ./svnserve {
    inherit pkgs processManagers profiles testService;
  };
}
