#!/bin/bash

# Count system updates for Debian
# This command lists upgradable packages and pipes the output to 'wc -l' to count lines.
# We subtract 1 because 'apt list --upgradable' always includes a header line.
system_updates=$(apt list --upgradable 2>/dev/null | wc -l)
system_updates=$((system_updates - 1)) # Subtract 1 for the "Listing..." header line

# Ensure the count isn't negative if there are no updates (e.g., if only the header is present)
if [ "$system_updates" -lt 0 ]; then
  system_updates=0
fi

# Sum and display the total
total_updates=$system_updates

if [ "$total_updates" -gt 0 ]; then
  echo "%{F#83c07c}󰇚: $total_updates"
else
  echo "%{F#85a498}󰇚"
fi
