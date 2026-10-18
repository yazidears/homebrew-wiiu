class GamepadBridge < Formula
  desc "Stream Mac video and audio to a Wii U GamePad through an OpenWrt radio"
  homepage "https://github.com/yazidears/gamepad-bridge"
  url "https://github.com/yazidears/gamepad-bridge/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1c274a62f2928a25057401d1beb55f43b38e0e9b88dc1e30043fcf4218168277"
  license "GPL-2.0-only"

  depends_on :arch => :arm64
  depends_on :macos => :ventura
  depends_on "python@3.14"

  def install
    selected_developer = Utils.safe_popen_read("/usr/bin/xcode-select", "-p").strip
    clt = Pathname("/Library/Developer/CommandLineTools")
    if !File.executable?(File.join(selected_developer, "usr/bin/xcrun")) && clt.directory?
      ENV["DEVELOPER_DIR"] = clt.to_s
    end
    python = Formula["python@3.14"].opt_bin/"python3.14"
    system python, "build.py"
    libexec.install "startup-service.py", "video_stream.py", "audio_stream.py", "input_report.py",
                    "mac-capture", "audio-capture"
    pkgshare.install "router"
    (bin/"gamepad-bridge").write <<~SH
      #!/bin/sh
      exec "#{python}" "#{libexec}/startup-service.py" "$@"
    SH
    (bin/"gamepad-bridge-router-build").write <<~SH
      #!/bin/sh
      exec "#{python}" "#{pkgshare}/router/build-openwrt.py" "$@"
    SH
    (bin/"gamepad-bridge-pairing-config").write <<~SH
      #!/bin/sh
      exec "#{python}" "#{pkgshare}/router/configure.py" "$@"
    SH
  end

  def caveats
    <<~EOS
      A dedicated compatible OpenWrt radio and a paired GamePad are required.
      Router setup: https://github.com/yazidears/gamepad-bridge/blob/v0.1.0/router/README.md
      Build the original MIPS router target with:
        gamepad-bridge-router-build --work-dir /tmp/gamepad-router-build
      Generate private pairing files with:
        gamepad-bridge-pairing-config --help
      Grant Screen & System Audio Recording permission when macOS asks.
    EOS
  end

  test do
    assert_match "usage:", shell_output("#{bin}/gamepad-bridge --help")
    assert_match "usage:", shell_output("#{bin}/gamepad-bridge-router-build --help")
    assert_match "usage:", shell_output("#{bin}/gamepad-bridge-pairing-config --help")
  end
end
