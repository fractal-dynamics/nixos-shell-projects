{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.openssh.enable = true;
  virtualisation.qemu.networkingOptions = [
    # We need to re-define our usermode network driver
    # since we are overriding the default value.
    "-net nic"
    # Than we can use qemu's hostfwd option to forward ports.
    "-net user,hostfwd=tcp::2222-:22,hostfwd=tcp::4646-:4646,hostfwd=tcp::8881-:80"
    #"-net user,hostfwd=tcp::4646-:4646"
  ];
  nixos-shell.mounts = {
    mountHome = false;
    mountNixProfile = false;
    cache = "none"; # default is "loose"
  };
  networking.firewall.allowedTCPPorts = [80 443 8080 4646];
  services.nginx.enable = true;
  services.nomad.enable = true;
  services.nomad.settings = {
    bind_addr = "0.0.0.0";
    ports = {
      http = 4646;
      rpc = 4647;
      serf = 4648;
    };    

  # A minimal config example:
    server = {
      enabled = true;
      bootstrap_expect = 1; # for demo; no fault tolerance
    };
    client = {
      enabled = true;
    };
  };
}
