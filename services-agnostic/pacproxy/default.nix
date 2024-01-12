{ lib, createManagedProcess, pacproxy }:
let pacproxy' = pacproxy; in

{ instanceSuffix ? "", instanceName ? "pacproxy${instanceSuffix}"
, pacproxy ? pacproxy'
, config # PAC file name, url or javascript.
, listen ? "127.0.0.1:3128"
, verbose ? false }:

let
in createManagedProcess {
  inherit instanceName;
  foregroundProcess = lib.getExe pacproxy;
  foregroundProcessArgs = [ "-c" config  "-l" listen ] ++ lib.optional verbose "-v";

  overrides = {
    synit = {
      depends-on = [ "<service-state <milestone network> up>" ];
    };
    sysvinit = {
      runlevels = [ 3 4 5 ];
    };
  };
}
