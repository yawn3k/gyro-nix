{ stdenv, pkgs, src, ... }:

stdenv.mkDerivation rec {
	pname = "joyshockmapper-linux";
	version = "git";
	inherit src;

	nativeBuildInputs = with pkgs; [
		cmake
		pkg-config
		clang
	];

	buildInputs = with pkgs; [
		gtk3
		libappindicator
		libevdev
		sdl3
	];

	patches = [ ./system-sdl3.patch ];

	cmakeFlags = [
		"-DCMAKE_CXX_COMPILER=clang++"
		"-DCMAKE_BUILD_TYPE=Release"

		"-DCPM_magic_enum_SOURCE=${pkgs.fetchFromGitHub {
			owner = "Neargye";
			repo = "magic_enum";
			rev = "v0.9.7";
			hash = "sha256-Q82HdlEMXpiGISnqdjFd0rxiLgsobsoWiqqGLawu2pM=";
		}}"
		"-DCPM_pocket_fsm_SOURCE=${pkgs.stdenv.mkDerivation {
			name = "pocket_fsm-source";
			src = pkgs.fetchFromGitHub {
				owner = "Electronicks";
				repo = "Pocket_FSM";
				rev = "e447ec24c7a547bd1fbe8d964baa866a9cf146c8";
				hash = "sha256-/dvOMEV9mduqk+BVpUqtdVGAEHIDmiQOIjMZPDzABRs=";
			};
			patchPhase = ''
				sed -i '2i include(CMakePackageConfigHelpers)' CMakeLists.txt
			'';
			installPhase = "cp -r . $out";
		}}"
		"-DCPM_GamepadMotionHelpers_SOURCE=${pkgs.fetchFromGitHub {
			owner = "JibbSmart";
			repo = "GamepadMotionHelpers";
			rev = "39b578aacf34c3a1c584d8f7f194adc776f88055";
			hash = "sha256-yEEcjUzXQAyc/3STuH7Yhbl5r+/S+M15AxNDEbhJuAY=";
		}}"
	];

	installPhase = ''
		mkdir -p $out/bin
		cp JoyShockMapper/JoyShockMapper $out/bin/joyshockmapper
	'';

	meta = with pkgs.lib; {
		description = "Controller remapping tool with gyro funcionality.";
		homepage = "https://github.com/CoderMaximus/JoyShockMapper-linux";
		license = licenses.mit;
		platforms = platforms.linux;
		mainProgram = "joyshockmapper";
	};
}
