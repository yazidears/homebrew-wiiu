# Wii U tools for Homebrew

```sh
brew tap yazidears/wiiu
brew install yazidears/wiiu/wiiu-audio yazidears/wiiu/gamepad-bridge
```

- [wiiu-audio](https://github.com/yazidears/wiiu-audio): listen to Wii U TV audio on your Mac. Requires a homebrew-enabled Wii U and the audio plugins described in its README.
- [gamepad-bridge](https://github.com/yazidears/gamepad-bridge): send Mac video and audio to a Wii U GamePad. Requires Apple Silicon, macOS 13+, Command Line Tools and a dedicated compatible OpenWrt radio. Experimental.

Start with `wiiu-audio --help` or `gamepad-bridge --help`. Follow each project's README for hardware setup.

GamePad router helpers are included:

```sh
gamepad-bridge-router-build --work-dir /tmp/gamepad-router-build
gamepad-bridge-pairing-config --help
```

The build helper targets the original MIPS router; check compatibility before installing anything on a radio. Neither formula changes router settings automatically.
