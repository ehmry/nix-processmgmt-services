{ lib, createManagedProcess, nncp }:

{ instanceSuffix ? "", instanceName ? "nncp-daemon${instanceSuffix}"
, configfile ? "/etc/nncp.hjson", extraArgs ? [ ] }:

let
in createManagedProcess {
  inherit instanceName;
  foregroundProcess = "${nncp}/bin/nncp-daemon";
  foregroundProcessArgs = [ "-cfg" configfile ] ++ extraArgs;
  overrides = {
    synit = { depends-on = [ "<service-state <milestone network> up>" ]; };
  };
}
