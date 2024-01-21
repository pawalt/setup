{ user, config }:
  let
    homedir = config.users.users.${user}.home;
    syncdir = "${homedir}/sync";
  in
{
  services.syncthing = {
    enable = true;
    user = user;
    configDir = "${homedir}/.config/syncthing";
    dataDir = "${homedir}/.config/syncthing/db";

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
        "iphone" = { id = "5YRXT5Z-KEGT5DW-VBH6EAR-YDQPFMW-LCUKH2X-QPKHWXH-BYAVZGR-LODC4AI"; };

        "crlmbp" = { id = "TGGH4PO-YTTK7W3-SDFYJNI-HPXZ5FC-SW364DR-JMQKI67-V4QFGAF-SJ6ZYQI"; };
        "peytonsmbp" = { id = "UE3H5H4-TIW7NIX-7HQG4XR-QJAACS3-6NONWPQ-33CBZV5-KU5CUSM-VD2VHQR"; };

        "macbox" = { id = "RCECRYN-BKKJI56-H5JHUMK-2DUGITH-YLWPET2-4SEMKVR-2CQ6YUA-JBTMMAW"; };
        "monohost" = { id = "Z3XMJ7T-PK55SC7-WWK3MQD-JPOX3H2-53XNVJD-SIP2NY2-WCGRPDL-SYUCYAE"; };
      };

      folders = {
        # generic sync folder
        "cccjw-5fcyz" = {
          path = syncdir;
          devices = [
            "iphone"
            "crlmbp"
            "peytonsmbp"
            "macbox"
            "monohost"
          ];
        };
      };
    };
  };

  # use special identity for secrets
  age.identityPaths = [ "${syncdir}/secrets/id_age_ed25519" ];
}
