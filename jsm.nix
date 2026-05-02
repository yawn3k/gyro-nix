{ config, lib, pkgs, ... }:
{
  options.programs.joyshockmapper = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    package = lib.mkPackageOption pkgs "joyshockmapper-linux" { };
  };

  config = lib.mkIf config.programs.joyshockmapper.enable {
    environment.systemPackages = [ config.programs.joyshockmapper.package ];

    # users.groups.uinput = { };
    # boot.kernelModules = [ "uinput" ];

    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"

      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2006|2007", MODE="0666"
    '';
  };
}
