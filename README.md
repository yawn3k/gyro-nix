# gyro-nix
A simple flake for gyro things on NixOS.

## Contains
- [JoyShockMapper-linux](https://github.com/CoderMaximus/JoyShockMapper-linux)
- [usb_oc-dkms](https://github.com/p0358/usb_oc-dkms)

> **Note:** I'm not a developer! If you see something that looks messy or wanna optimize my code please open a PR or let me know. PRs and issue reports are very much welcome from the gyro community and tool developers.

## How to use it
1. Add this to your `inputs` and add the module.
```nix
{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
		gyro = {
			url = "github:yawn3k/gyro-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = { self, nixpkgs, ... }@ inputs:
	{
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			specialArgs = {
				inherit inputs;
			};
			system = "x86_64-linux";
			modules = [
				inputs.gyro.nixosModules.default

				./configuration.nix
				./hardware-configuration.nix
			];
		};
	};
}
```

2. Add it to your `configuration.nix`.
```nix
{
	programs.joyshockmapper.enable = true; # Enables joyshockmapper
	# IMPORTANT add your user to the `uinput` group for joyshockmapper to work.
	users.users.yourname.extraGroups = [ "uinput" ]; 

	boot.usb-oc.enable = true; # Enables USB OC kernel module
}
```

