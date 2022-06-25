{ config, pkgs, libs, ... }:
let
  vimium-id = "dbepggeogbaibhgnhhndojpepiihcmeb";
  plasma-integration-id = "cimiefiiaegbelhefglklhhakcgmhkai";
in
{
  programs.brave = {
    enable = true;
    extensions = [
      { id = vimium-id; }
      { id = plasma-integration-id; }
    ];
  };
}
