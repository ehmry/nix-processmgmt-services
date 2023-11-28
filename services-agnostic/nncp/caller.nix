{ lib, createManagedProcess, nncp }:

{ instanceSuffix ? "", instanceName ? "nncp-caller${instanceSuffix}"
, configfile ? "/etc/nncp.hjson", extraArgs ? [ ] }:

let
in createManagedProcess {
  inherit instanceName;
  foregroundProcess = "${nncp}/bin/nncp-caller";
  foregroundProcessArgs = [ "-cfg" configfile ] ++ extraArgs;
  overrides = {
    synit = { depends-on = [ "<service-state <milestone network> up>" ]; };
  };
}
