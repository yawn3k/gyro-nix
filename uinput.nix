{ config, lib, pkgs, ... }:
{
	config = lib.mkIf (config.programs.joyshockmapper.enable || config.programs.moonglide.enable) {
		# users.groups.uinput = { };
		# boot.kernelModules = [ "uinput" ];

		services.udev.extraRules = ''
			KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"

			KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0666"
			KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2006|2007", MODE="0666"
		'';
	};
}
