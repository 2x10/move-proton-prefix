#!/usr/bin/env bash
#
# Proton Prefix Relocator Script (library preset edition)
# Moves a Steam game's Proton prefix off an NTFS library
# and replaces it with a symlink to an ext4 location.
#
# Usage:
#   ./proton-prefix-mover.sh --appid 123456 --library nvme01
#
# Configurable variables:
HOMEPATH="$HOME/.steam/compatdata_emu"   # Where ext4-based prefixes are stored

# Define your preset library paths here:
nvme01="/mnt/ntfs/drive_a/Steam/steamapps/compatdata"
nvme02="/mnt/ntfs/drive_b/Steam/steamapps/compatdata"
hdd01="/mnt/ntfs/drive_c/Steam/steamapps/compatdata"
hdd02="/mnt/ntfs/drive_d/Steam/steamapps/compatdata"


# --- Argument parsing ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --appid) APPID="$2"; shift ;;
        --library) LIBRARY_NAME="$2"; shift ;;
        -h|--help)
            echo "Usage: $0 --appid <steam_appid> --library <library_name>"
            echo "Preset libraries available: nvme01, nvme02, hdd01, hdd02"
            exit 0 ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# --- Validation ---
if [[ -z "$APPID" || -z "$LIBRARY_NAME" ]]; then
    echo "❌ Error: You must specify both --appid and --library"
    exit 1
fi

# Resolve library variable dynamically
BASEPATH_VAR="$LIBRARY_NAME"
BASEPATH="${!BASEPATH_VAR}"

if [[ -z "$BASEPATH" ]]; then
    echo "❌ Error: Unknown library name '$LIBRARY_NAME'"
    echo "Available presets: nvme01, nvme02, hdd01, hdd02"
    exit 1
fi

# Resolve tilde in HOMEPATH
HOMEPATH="${HOMEPATH/#\~/$HOME}"

GAMEPATH="$BASEPATH/$APPID"
TARGET="$HOMEPATH/$APPID"

# --- Create destination directory ---
echo "🔧 Preparing ext4 prefix directory: $TARGET"
mkdir -p "$HOMEPATH"

# --- Move existing prefix if it exists ---
if [[ -d "$GAMEPATH" && ! -L "$GAMEPATH" ]]; then
    echo "📦 Moving existing prefix from NTFS to $TARGET ..."
    mv "$GAMEPATH" "$TARGET" || { echo "❌ Move failed."; exit 1; }
elif [[ -L "$GAMEPATH" ]]; then
    echo "⚠️  Note: $GAMEPATH is already a symlink. Skipping move."
else
    echo "⚠️  No existing prefix found. Creating new one at $TARGET ..."
    mkdir -p "$TARGET"
fi

# --- Create the symlink ---
echo "🔗 Creating symlink: $GAMEPATH → $TARGET"
ln -sfn "$TARGET" "$GAMEPATH" || { echo "❌ Failed to create symlink."; exit 1; }

# --- Done ---
echo "✅ Proton prefix relocation complete!"
echo "AppID: $APPID"
echo "Library: $LIBRARY_NAME"
echo "Original Path: $GAMEPATH"
echo "Real Prefix: $TARGET"
