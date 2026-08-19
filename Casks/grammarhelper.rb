# Rendered by scripts/publish-release.sh — do not edit in the tap by hand.
# Only the version and the checksum are substituted at publish time; everything
# else is the contract and changes here, in the source repository.
cask "grammarhelper" do
  version "1.9.1"
  sha256 "939c5daa8d98555281808688efbdada1714e4bc75cf43e0848beb9e5a3606afa"

  url "https://github.com/SmartAndPoint/grammarhelper-releases/releases/download/v#{version}/GrammarHelper-#{version}.dmg"
  name "GrammarHelper"
  desc "Menu bar text correction for any app, one hotkey, works offline"
  homepage "https://github.com/SmartAndPoint/grammarhelper-releases"

  livecheck do
    url :url
    strategy :github_latest
  end

  # macOS 26+ only (owner decision 2026-08-04, current-OS-first). Without the
  # version the cask installs happily on older systems where the app cannot
  # launch at all.
  depends_on macos: ">= :tahoe"

  # The app is LSUIElement: it keeps running with no dock icon and no window.
  # Without this it survives uninstall and upgrade — still holding the hotkey
  # and still writing to its log.
  uninstall quit: "smartandpoint.com.GrammarHelper"

  app "GrammarHelper.app"

  # Every trace, including the two that are easy to miss: the preferences plist
  # holds the OpenAI API key, and the correction journal rotates into a second
  # file that a "*.log" pattern would never match.
  zap trash: [
    "~/Library/Preferences/smartandpoint.com.GrammarHelper.plist",
    "~/Library/Application Support/GrammarHelper",
    "~/Library/Logs/GrammarHelper.log",
    "~/Library/Logs/GrammarHelper.corrections.jsonl",
    "~/Library/Logs/GrammarHelper.corrections.1.jsonl",
    "~/Library/HTTPStorages/smartandpoint.com.GrammarHelper",
    "~/Library/HTTPStorages/smartandpoint.com.GrammarHelper.binarycookies",
    "~/Library/Caches/smartandpoint.com.GrammarHelper",
  ]

  caveats <<~EOS
    GrammarHelper needs Accessibility permission to press Cmd+C / Cmd+V for you:
      System Settings -> Privacy & Security -> Accessibility -> enable GrammarHelper

    After a `brew upgrade` macOS may drop that permission, because Homebrew
    replaces the app bundle rather than writing over it. If the hotkey goes
    quiet after an upgrade, toggle GrammarHelper off and on in that same list.
  EOS
end
