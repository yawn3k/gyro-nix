{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		jsm-linux-src = {
			url = "github:CoderMaximus/JoyShockMapper-linux";
			flake = false;
		};
		usb-oc-src = {
			url = "github:p0358/usb_oc-dkms";
			flake = false;
		};
		moonglide-src = {
			url = "github:yawn3k/moonglide";
			flake = false;
		};
	};

	outputs = { self, nixpkgs, ... }@inputs:
	let
		systems = [ "x86_64-linux" ];
		forAllSystems = nixpkgs.lib.genAttrs systems;
	in
	{
		packages = forAllSystems (system:
			let
				pkgs = import nixpkgs {
					inherit system;
					overlays = [ self.overlays.default ];
				};
			in
			{
				default = pkgs.joyshockmapper-linux;
				joyshockmapper-linux = pkgs.joyshockmapper-linux;
				moonglide = pkgs.moonglide; 
			}
		);

		overlays.default = final: prev: {
			joyshockmapper-linux = final.callPackage ./packages/jsm-linux/package.nix { src = inputs.jsm-linux-src; };
			moonglide = final.callPackage ./packages/moonglide.nix { src = inputs.moonglide-src; };

			usb-oc-src = inputs.usb-oc-src;
		};

		nixosModules.default = { config, lib, pkgs, ... }:
		{
			imports = [
				./jsm.nix
				./usb-oc.nix
			];
			nixpkgs.overlays = [ self.overlays.default ];
		};
	};
}
