{ config, lib, pkgs, ... }:
{
	options.programs.moonglide = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
	};

	config = lib.mkIf config.programs.moonglide.enable {
		environment.systemPackages = [ pkgs.moonglide ];
	};
}
