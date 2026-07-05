{ rustPlatform, pkgs, lib, src }:

rustPlatform.buildRustPackage rec {
	pname = "moonglide";
	version = "0.1.0";
	inherit src;

	cargoLock = {
		lockFile = "${src}/Cargo.lock";
	};

	nativeBuildInputs = with pkgs; [
		pkg-config
	];

	buildInputs = with pkgs; [
		SDL2
		luajit
		udev
	];

	meta = with lib; {
		description = "Controller remapper configured with lua.";
		homepage = "https://github.com/yawn3k/moonglide";
		license = licenses.gpl3;
		platforms = platforms.linux;
	};
}
