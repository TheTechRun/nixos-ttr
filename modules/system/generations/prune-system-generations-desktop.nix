{ config, lib, pkgs, ... }:

{
  # Keep only the newest 15 system profile generations.
  system.activationScripts.pruneSystemGenerations = {
    text = ''
      profile=/nix/var/nix/profiles/system
      keep=15

      generations="$(${pkgs.nix}/bin/nix-env --list-generations --profile "$profile" | ${pkgs.gawk}/bin/awk '{print $1}' | ${pkgs.gnugrep}/bin/grep '^[0-9][0-9]*$' || true)"
      total="$(${pkgs.coreutils}/bin/printf '%s\n' "$generations" | ${pkgs.gnugrep}/bin/grep -c '^[0-9][0-9]*$' || true)"

      if [ "$total" -gt "$keep" ]; then
        delete_list="$(${pkgs.coreutils}/bin/printf '%s\n' "$generations" | ${pkgs.coreutils}/bin/head -n "$((total - keep))")"

        if [ -n "$delete_list" ]; then
          echo "Pruning old NixOS system generations:"
          echo "$delete_list"
          # Intentional word splitting: nix-env expects generation numbers as separate arguments.
          ${pkgs.nix}/bin/nix-env --delete-generations $delete_list --profile "$profile" || true
        fi
      fi
    '';
    deps = [ ];
  };
}
