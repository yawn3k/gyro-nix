{ config, lib, pkgs, ... }:
{
  options.boot.usb-oc = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the usb_oc kernel module.";
    };
  };

  config = lib.mkIf config.boot.usb-oc.enable {
    boot.extraModulePackages = [ (config.boot.kernelPackages.callPackage ./packages/usb-oc.nix { src = pkgs.usb-oc-src; }) ];
    boot.kernelModules = [ "usb_oc" ];

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="054c", ATTR{idProduct}=="0ce6", RUN+="${pkgs.runtimeShell} -c 'echo -n 054c:0ce6:4 > /sys/module/usb_oc/parameters/interrupt_interval_override'"
    '';
  };
}
