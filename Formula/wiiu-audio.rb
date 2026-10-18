class WiiuAudio < Formula
  include Language::Python::Virtualenv

  desc "Listen to Wii U TV audio on a Mac over the local network"
  homepage "https://github.com/yazidears/wiiu-audio"
  url "https://github.com/yazidears/wiiu-audio/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "32ba5193a03d7294724aa7c864577c4c976c498bd405177e98768c60c2b9e657"
  license "GPL-3.0-or-later"

  depends_on "pkgconf" => :build
  depends_on "libffi"
  depends_on :macos
  depends_on "portaudio"
  depends_on "python@3.14"

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/ec/db/0c890e2d9aab9ba284021efc02e1d3aebfecab1b611762d7434602209bcf/sounddevice-0.5.6.tar.gz"
    sha256 "8ec9fbfde2e32f020b167e348f3ab3bac6625a5f15af524d790108ac7147a410"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/da/a8/c5fdbeee588bb8ada9458774f43adf1bdd30bd59157055142183e769a024/pycparser-3.11.tar.gz"
    sha256 "d875f09c3507d00e1aba0eecc6dcadc1352f30fff09dc6bff2f1c2935e97c2bc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage:", shell_output("#{bin}/wiiu-audio --help")
    assert_match "usage:", shell_output("#{bin}/wiiu-audio-plugins --help")
    system libexec/"bin/python", "-c", "import sounddevice; assert sounddevice.get_portaudio_version()[0] > 0"
  end
end
