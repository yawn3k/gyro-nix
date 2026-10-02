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
	};
}
