{
  stdenv,
  unzip,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "perfetto-tools";
  version = "58.2";

  # The release bundle has trace_processor_shell and traceconv, which the
  # nixpkgs perfetto package does not ship.
  src = fetchurl {
    url = "https://github.com/google/perfetto/releases/download/v58.2/linux-amd64.zip";
    sha256 = "32c739f71b2d39721afd294c0b038f2499a44a71b5b6bcdd85b83faca0b240b9";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -Dm755 linux-amd64/trace_processor_shell "$out/bin/trace_processor_shell"
    install -Dm755 linux-amd64/traceconv "$out/bin/traceconv"
  '';

  meta = {
    description = "trace_processor_shell and traceconv from the perfetto release bundle";
  };
}
