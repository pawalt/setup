let
  global = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXFHpF+KBXVyVAQj/4hLcahM3BVFeoKXhZCkRF0U6aj";
in
{
  "monohost_tskey.age".publicKeys = [ global ];
}
