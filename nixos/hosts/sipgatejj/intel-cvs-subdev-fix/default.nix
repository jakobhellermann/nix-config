{
  lib,
  stdenv,
  kernel,
  kmodigest,
  xz,
}:

stdenv.mkDerivation {
  pname = "intel-cvs-subdev-nodes";
  version = "1-${kernel.modDirVersion}";

  # Drop-in replacement for the in-tree intel_cvs (drivers/media/i2c/cvs):
  # without the patch, a sensor bound under the CVS notifier never gets a
  # /dev/v4l-subdev* node, because the ipu7 isys notifier never completes
  # while another sensor in the same firmware graph (HM1092 IR camera) has
  # no driver. libcamera and the Intel camera HAL both find no sensor then.
  # See register-subdev-nodes.patch for details.
  #
  # Same kernel source, same .config => same symbol CRCs under MODVERSIONS.
  # Remove once the kernel registers subdev nodes for CVS-notifier-bound
  # sensors itself.
  dontUnpack = true;
  hardeningDisable = [
    "format"
    "pic"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies ++ [
    kmodigest
    xz
  ];

  patches = [ ./register-subdev-nodes.patch ];

  prePatch = ''
    tar -xf ${kernel.src} --wildcards --strip-components=5 \
      '*/drivers/media/i2c/cvs/core.c' \
      '*/drivers/media/i2c/cvs/v4l2.c' \
      '*/drivers/media/i2c/cvs/icvs.h'
  '';

  postPatch = ''
    cat > Kbuild <<'EOF'
    obj-m := intel_cvs.o
    intel_cvs-y := core.o v4l2.o
    EOF
  '';

  buildPhase = ''
    runHook preBuild
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules
    runHook postBuild
  '';

  # "updates/" beats "kernel/" in depmod's search order, so this shadows the
  # in-tree module without blacklisting.
  # The module aggregator expects a kmodigest .ko.cer next to every external module.
  installPhase = ''
    runHook preInstall
    install -D -m 644 intel_cvs.ko \
      $out/lib/modules/${kernel.modDirVersion}/updates/intel_cvs.ko
    kmodigest $out/lib/modules/${kernel.modDirVersion}/updates/intel_cvs.ko
    xz -9 $out/lib/modules/${kernel.modDirVersion}/updates/intel_cvs.ko
    runHook postInstall
  '';

  meta = with lib; {
    description = "intel_cvs with subdev node registration at sensor bind time";
    platforms = platforms.linux;
  };
}
