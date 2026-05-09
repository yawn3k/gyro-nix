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
	};

	outputs = { self, nixpkgs, ... }@inputs:
	let
		systems = [ "x86_64-linux" ];
		forAllSystems = nixpkgs.lib.genAttrs systems;
	in
	{
		packages = forAllSystems (system:
			let
				pkgs = nixpkgs.legacyPackages.${system};
			in
			{
				default = pkgs.callPackage ./packages/jsm-linux/package.nix { src = inputs.jsm-linux-src; };
				joyshockmapper-linux = self.packages.${system}.default;
			}
		);

		overlays.default = final: prev: {
			joyshockmapper-linux = final.callPackage ./packages/jsm-linux/package.nix { src = inputs.jsm-linux-src; };
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
