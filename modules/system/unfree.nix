{ ... }:

{
  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;
  };
}
