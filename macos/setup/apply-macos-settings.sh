#!/usr/bin/env bash
set -euo pipefail

# Idempotent script for applying settings on macOS, instead of clicking through a user interface
# To ensure all changes are effected, make sure to restart after running

# Keyboard and text input
defaults write -g KeyRepeat -int 2                    # Fast key repeat rate
defaults write -g InitialKeyRepeat -int 15            # Short delay before key repeat starts
defaults write -g AppleKeyboardUIMode -int 3          # Tab through all UI controls
defaults write -g ApplePressAndHoldEnabled -bool false # Enable key repeat instead of press-and-hold accents

# Disable autocorrections that can silently corrupt code in some apps.
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false       # No smart quotes
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false        # No smart dashes
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false      # No spelling autocorrect
defaults write -g NSAutomaticCapitalizationEnabled -bool false          # No automatic capitalization
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false      # No double-space period

# Remove input/caps-lock indicators in text fields.
defaults write -g TSMLanguageIndicatorEnabled -bool false # No language/input method popup
sudo defaults write /Library/Preferences/FeatureFlags/Domain/UIKit.plist redesigned_text_cursor -dict-add Enabled -bool NO # No animated caps-lock cursor indicator; requires re-login

# Sound
defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0.0 # Alert volume zero
sudo nvram StartupMute=%01                                          # Play sound on startup: off
defaults write NSGlobalDomain "com.apple.sound.uiaudio.enabled" -int 0 # No user interface sound effects
defaults write NSGlobalDomain "com.apple.sound.beep.feedback" -int 0   # No feedback when volume is changed

# Accessibility and appearance
defaults write com.apple.universalaccess reduceTransparency -bool true # Make liquid glass more tolerable

# Menu bar date and time
defaults write com.apple.menuextra.clock ShowDate -int 1            # Show date in menu bar
defaults write com.apple.menuextra.clock ShowDayOfWeek -int 1       # Show day of week in menu bar
defaults write com.apple.menuextra.clock IsAnalog -int 0            # Use digital clock
defaults write com.apple.menuextra.clock FlashDateSeparators -int 0 # Do not flash time separators
defaults write com.apple.menuextra.clock ShowSeconds -int 1         # Show seconds in menu bar clock

# Desktop, Dock, Mission Control, and windows
defaults write com.apple.dock autohide -bool true                    # Auto-hide Dock
defaults write com.apple.dock autohide-delay -float 0                # No hover delay before Dock appears
defaults write com.apple.dock autohide-time-modifier -float 0.15     # Faster Dock show/hide animation
defaults write com.apple.dock show-recents -bool false               # No recent apps section in Dock
defaults write com.apple.dock launchanim -bool false                 # No app launch bounce animation
defaults write com.apple.dock tilesize -int 21                       # Small Dock icon size
defaults write com.apple.dock magnification -bool false              # Disable Dock magnification
defaults write com.apple.dock largesize -int 61                      # Magnified size if magnification is enabled later
defaults write com.apple.dock orientation -string "bottom"           # Keep Dock at bottom of screen
defaults write com.apple.dock mineffect -string "scale"              # Use Scale Effect when minimizing windows
defaults write com.apple.dock minimize-to-application -bool false     # Do not minimize windows into app icons
defaults write com.apple.dock show-process-indicators -bool true      # Show open-app indicators in Dock
defaults write com.apple.dock mru-spaces -bool false                 # Do not rearrange Spaces by recent use
defaults write com.apple.dock expose-group-apps -bool true           # Group windows by app in Mission Control
defaults write com.apple.spaces spans-displays -bool false           # Displays have separate Spaces
defaults write com.apple.dock showDesktopGestureEnabled -bool false  # Disable desktop show gesture
defaults write -g AppleSpacesSwitchOnActivate -bool false            # Do not jump Spaces when activating apps
defaults write NSGlobalDomain AppleWindowTabbingMode -string "always" # Prefer tabs when opening documents
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true # Ask to keep changes when closing documents
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true     # Keep windows when quitting apps
defaults write com.apple.WindowManager GloballyEnabled -bool false    # Disable Stage Manager
defaults write com.apple.WindowManager AutoHide -bool false           # Show recent apps in Stage Manager if enabled
defaults write com.apple.WindowManager AppWindowGroupingBehavior -int 1 # Show all windows from an app at once
defaults write com.apple.WindowManager HideDesktop -bool false        # Show desktop items
defaults write com.apple.WindowManager StandardHideWidgets -bool false # Show widgets on desktop
defaults write com.apple.WindowManager StageManagerHideWidgets -bool false # Show widgets in Stage Manager
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false # Only click wallpaper to show desktop in Stage Manager
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false # Do not tile by dragging windows to screen edges
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false # Do not fill screen by dragging windows to menu bar
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false # Do not tile by holding Option while dragging
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false # No margins around tiled windows
defaults write com.apple.dock wvous-tl-corner -int 1                 # Disable top-left hot corner
defaults write com.apple.dock wvous-tr-corner -int 1                 # Disable top-right hot corner
defaults write com.apple.dock wvous-bl-corner -int 1                 # Disable bottom-left hot corner
defaults write com.apple.dock wvous-br-corner -int 1                 # Disable bottom-right hot corner
defaults write com.apple.dock wvous-tl-modifier -int 0               # No top-left hot corner modifier
defaults write com.apple.dock wvous-tr-modifier -int 0               # No top-right hot corner modifier
defaults write com.apple.dock wvous-bl-modifier -int 0               # No bottom-left hot corner modifier
defaults write com.apple.dock wvous-br-modifier -int 0               # No bottom-right hot corner modifier

# Finder and filesystem
defaults write -g AppleShowAllExtensions -bool true                         # Show all file extensions
defaults write com.apple.finder AppleShowAllFiles -bool true                # Show hidden files
defaults write com.apple.finder ShowPathbar -bool true                      # Show path bar
defaults write com.apple.finder ShowStatusBar -bool true                    # Show status bar
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"         # Search current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # No extension change warning
defaults write com.apple.finder _FXSortFoldersFirst -bool true              # Folders before files
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"         # Use list view by default
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true # Do not write .DS_Store on network drives
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true     # Do not write .DS_Store on USB drives
chflags nohidden ~/Library                                                  # Show ~/Library

# Documents
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false # Save to disk by default, not iCloud

# Screenshots
defaults write com.apple.screencapture disable-shadow -bool true # No window screenshot shadows
defaults write com.apple.screencapture show-thumbnail -bool false # No floating thumbnail after screenshot
defaults write com.apple.screencapture target -string "file"      # Save screenshots as files
defaults write com.apple.screencapture style -string "selection"  # Default to selection screenshots

# Mouse and trackpad
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false # Disable natural scrolling

# Menu bar spacing requires re-login.
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 2          # Tighten menu bar icon spacing
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 2 # Tighten menu bar selection padding

# Security
sudo spctl --master-disable # Disable Gatekeeper
# Then go to System Settings > Privacy & Security > Security,
# select Allow applications from: Anywhere.

# Keybindings and Trackpad
# TODO: Change macOS system keybindings
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2                  # Swipe down with three fingers for App Expose
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 2 # Swipe down with three fingers for App Expose on Bluetooth trackpads
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerVertSwipeGesture -int 2             # Swipe down with three fingers for App Expose on this host

# Displays
open "x-apple.systempreferences:com.apple.Displays-Settings.extension"
# TODO: Disable True Tone and Automatic Brightness Adjustment
