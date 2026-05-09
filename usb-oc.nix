{ config, lib, pkgs, ... }:
{
	options.boot.usb-oc = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Enable the usb_oc kernel module.";
		};
		device = lib.mkOption {
			type = lib.types.str;
			description = "The USB device ID (vendor:product) to overclock.";
		};
		bInterval = lib.mkOption {
			type = lib.types.int;
			description = "The interrupt interval override value.";
		};
	};

	config = lib.mkIf config.boot.usb-oc.enable {
		boot.extraModulePackages = [ (config.boot.kernelPackages.callPackage ./packages/usb-oc.nix { src = pkgs.usb-oc-src; }) ];
		boot.kernelModules = [ "usb_oc" ];

		services.udev.extraRules = ''
			ACTION=="add", SUBSYSTEM=="usb", RUN+="${pkgs.runtimeShell} -c 'echo -n ${config.boot.usb-oc.device}:${toString config.boot.usb-oc.bInterval} > /sys/module/usb_oc/parameters/interrupt_interval_override'"
		'';
	};
}
