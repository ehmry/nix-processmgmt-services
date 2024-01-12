{ lib, createManagedProcess, eris-go }:
let eris-go' = eris-go; in

{ instanceSuffix ? "", instanceName ? "eris-server${instanceSuffix}"
, eris-go ? eris-go'
  # Whether to decode ERIS content at http://…/uri-res/N2R?urn:eris:….
, decode ? false,
# Server CoAP listen address.
listenCoap ? null
  # Server HTTP listen address.
, listenHttp ? null
  # Server backend stores.
, storeBackends, mountpoint ? null }:

let
in createManagedProcess {
  inherit instanceName;
  foregroundProcess = "${eris-go}/bin/eris-go";
  foregroundProcessArgs = [ "server" ] ++ lib.optional decode "--decode"
    ++ lib.optionals (listenCoap != null) [ "--coap" listenCoap ]
    ++ lib.optionals (listenHttp != null) [ "--http" listenHttp ]
    ++ lib.optionals (mountpoint != null) [ "--mountpoint" mountpoint ];

  environment = {
    ERIS_STORE_URL = storeBackends;
  };

  path = [ "/run/wrappers" ]; # fusermount3

  overrides = {
    synit = {
      depends-on =
        lib.lists.optional ((listenCoap != null) || (listenHttp != null))
        "<service-state <milestone network> up>";
    };
    sysvinit = { runlevels = [ 3 4 5 ]; };
  };
}
