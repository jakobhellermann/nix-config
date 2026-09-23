{
  lib,
  stdenv,
  kernel,
  xz,
}:

stdenv.mkDerivation {
  pname = "cs35l56-spk-id-ebusy";
  version = "1-${kernel.modDirVersion}";

  # Rebuilds the two cs35l56 modules that contain the spk-id GPIO lookup with
  # the EBUSY-tolerance patch on top, as drop-in replacements for the in-tree
  # ones. Same kernel source, same .config => same symbol CRCs under
  # MODVERSIONS, so the unpatched in-tree modules (snd-soc-cs35l56-sdw etc.)
  # keep resolving against these.
  #
  # Why out-of-tree instead of boot.kernelPatches: a source patch to the kernel
  # invalidates the whole kernel derivation (~30 min rebuild on every kernel
  # version bump). This package rebuilds in seconds and kernel.src pins it to
  # the exact module version automatically.
  #
  # See cs35l56-spk-id-ebusy.patch for the actual fix and its rationale
  # (thesofproject/sof#11152, still broken in v7.3-rc4).
  dontUnpack = true;
  hardeningDisable = [
    "format"
    "pic"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ xz ];

  patches = [ ./cs35l56-spk-id-ebusy.patch ];

  prePatch = ''
    mkdir -p sound/soc/codecs
    cp ${kernel.src}/sound/soc/codecs/cs35l56.c \
       ${kernel.src}/sound/soc/codecs/cs35l56-shared.c \
       ${kernel.src}/sound/soc/codecs/cs35l56.h \
       ${kernel.src}/sound/soc/codecs/wm_adsp.h \
       sound/soc/codecs/
  '';

  postPatch = ''
    cat > Kbuild <<'EOF'
    obj-m := sound/soc/codecs/snd-soc-cs35l56.o sound/soc/codecs/snd-soc-cs35l56-shared.o
    sound/soc/codecs/snd-soc-cs35l56-y := sound/soc/codecs/cs35l56.o
    sound/soc/codecs/snd-soc-cs35l56-shared-y := sound/soc/codecs/cs35l56-shared.o
    EOF
  '';

  buildPhase = ''
    runHook preBuild
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules
    runHook postBuild
  '';

  # "updates/" beats "kernel/" in depmod's search order, so these shadow the
  # in-tree modules without blacklisting.
  installPhase = ''
    runHook preInstall
    install -D -m 644 sound/soc/codecs/snd-soc-cs35l56.ko \
      $out/lib/modules/${kernel.modDirVersion}/updates/snd-soc-cs35l56.ko
    install -D -m 644 sound/soc/codecs/snd-soc-cs35l56-shared.ko \
      $out/lib/modules/${kernel.modDirVersion}/updates/snd-soc-cs35l56-shared.ko
    xz -9 $out/lib/modules/${kernel.modDirVersion}/updates/*.ko
    runHook postInstall
  '';

  meta = with lib; {
    description = "cs35l56 speaker driver with spk-id-gpios -EBUSY tolerance";
    platforms = platforms.linux;
  };
}
