{ stdenv, lib, kernel, src }:

stdenv.mkDerivation {
	pname = "usb_oc";
	version = "git";
	inherit src;

	sourceRoot = "source";
	nativeBuildInputs = kernel.moduleBuildDependencies;

	buildPhase = ''
		runHook preBuild
		make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd)/src modules
		runHook postBuild
	'';

	installPhase = ''
		runHook preInstall
		install -D src/usb_oc.ko $out/lib/modules/${kernel.modDirVersion}/extra/usb_oc.ko
		runHook postInstall
	'';

	meta = with lib; {
		description = "USB Overclocking kernel module";
		homepage = "https://github.com/p0358/usb_oc-dkms";
		license = licenses.gpl2Only;
		platforms = platforms.linux;
	};
}
