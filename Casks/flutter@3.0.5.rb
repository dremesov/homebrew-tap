cask "flutter@3.0.5" do
  arch arm: "_arm64_", intel: "_"

  version "3.0.5"
  sha256 arm:   "ad3b620aef65d43f54c5432a7f3a72304de639c7cf393a8a8796aa1094476b2e",
         intel: "e79a04dcfd1b583e5831433fc200800ba0d1e9fe4567cb661479bd2542d4c685"

  url "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos#{arch}#{version}-stable.zip",
      verified: "storage.googleapis.com/flutter_infra_release/releases/stable/macos/"
  name "Flutter SDK"
  desc "UI toolkit for building applications for mobile, web and desktop"
  homepage "https://flutter.dev/"

  livecheck do
    url "https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json"
    regex(%r{/flutter[._-]macos[._-]v?(\d+(?:\.\d+)+)[._-]stable\.zip}i)
  end

  auto_updates true

  binary "flutter/bin/dart"
  binary "flutter/bin/flutter"

  zap trash: "~/.flutter"
end
