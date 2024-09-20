{ config, pkgs, lib, ... }:

let
  timezone = "Europe/Berlin";
  locale = "en_US.UTF-8";

  keyboard_layout = "de-latin1-nodeadkeys";
  tty_console_font = "ter-132n.psf.gz";
in
{
  # Disable IPv6
  boot.kernelParams = [ "ipv6.disable=1" ];

  # Root user setup
  users.users.root = {
    hashedPassword = "$6$SfslMWXXXD539C0z$B8rpKb9GL2QoRLH/PwnS2oqOb5M3PPZZ.brq4ZtHlrIFNoBANMGh1wjQgcxWayL.yycojl9GpCS.jgaO84RLz/";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCiAi7gHLRaPwsulZdbejm2G3TSnkud9vDhOH9iVzNCEJJvYaCMf26OGZO5zumPeq0thwCEMTQ5/sBCL419fU9OxkJdn8zzlfq2RkOmf+LPkSe7JOLFLGjFZlHKkUr+7OITd+PozsUR+QkbO99jjtNEYGjEMLzdUVgACwmh51+reflR8K9aTTk/Hf7Miky5SmsHcpIVd3NDhMBMcfqgLqkT84BXaS+dza3CnoJYG7Qo41tmmBZ0/NClAsW6f0qubgsVecU6XHAYgC5lcP56o3KrXHCw+f5xjhiXg6dJxury+k81LGwtzZuuCldG+gjJdn8W6SlH/fx1Gf5XQYZsq3DQWY8IEL0kIQuJPhaMqKn23SY2IjsuN7ycl9sFAyobkauOYUI4lsasvNubds817zlQRqaulItLYtZW+GFngQK/hzapUzGRU+j4v+obIFgxNq5VIKVnYYL2Lgs7R5YqAYjC/HlxQdNMu2FOIQStcvVb6gjX5k5ti84LeMDhfnsJMLOvn/xTCMK8siKcnd962qP38RV2ObCprTvXcOZjbUYDKgYYxVovvCPXQmqqgrlB4jCJ//2IK2sdKXi/V9FalnOxMDVwTSAKJHfCugWqe2l4IYYPvdT0eb3yC+P9N8llRJe1GBVybbdN9bLVJyJUUCdVs6AVn9wAv/iMAqwTpPtEPQ=="
    ];
  };

  # Timezone
  time.timeZone = timezone;

  # Locales ----- default everything to en_US.UTF-8
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LANGUAGE = locale;
    LC_ALL = locale;
    LC_ADDRESS = locale;
    LC_NAME = locale;
    LC_MONETARY = locale;
    LC_PAPER = locale;
    LC_IDENTIFICATION = locale;
    LC_TELEPHONE = locale;
    LC_MEASUREMENT = locale;
    LC_TIME = locale;
    LC_NUMERIC = locale;
    LANG = locale;
  };

  # Console & Keyboard setup
  console = {
    keyMap = lib.mkDefault keyboard_layout;

    # big font please
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/${tty_console_font}";

    # don't know what it does but it works this way
    useXkbConfig = false;

    # don't know what it does but it works this way
    earlySetup = true;
  };

  # Modern Nix, please
  nix.settings.experimental-features = "nix-command flakes";

  # Custom CA certificates
  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIBsjCCAVegAwIBAgIRANJGKJcxKHqicrzV+jxjkrEwCgYIKoZIzj0EAwIwIjEL
      MAkGA1UEChMCT0MxEzARBgNVBAMTCk9DIFJvb3QgQ0EwHhcNMjQwODIzMDAyMjA3
      WhcNMzQwODIxMDAyMjA3WjAqMQswCQYDVQQKEwJPQzEbMBkGA1UEAxMST0MgSW50
      ZXJtZWRpYXRlIENBMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE25H9kOm6ORNu
      eAAdeSpH8fdjTGoIlPvf/QMRcG717522kVDxlVngDPbFQisUmqNUNy2D18LEM9yk
      ZBhcFrXh8qNmMGQwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAw
      HQYDVR0OBBYEFCA0m9ZpcAmOtyYtzOL9VBzu56sdMB8GA1UdIwQYMBaAFCFg1/QZ
      zgzUD96mZOdodyFLMW8iMAoGCCqGSM49BAMCA0kAMEYCIQCXcln5HMgIdifZVRUP
      c+a6hPIfaYDoM2COqsQFytN4GwIhAKUHAA6I+u4mWHesTvC8xYPt+pcpEKW4i4W5
      TTCPQ/uU
      -----END CERTIFICATE-----
    ''
    ''
      -----BEGIN CERTIFICATE-----
      MIIBhzCCAS2gAwIBAgIQRcmN/xmTn/H60IoZyBgOfDAKBggqhkjOPQQDAjAiMQsw
      CQYDVQQKEwJPQzETMBEGA1UEAxMKT0MgUm9vdCBDQTAeFw0yNDA4MjMwMDIyMDZa
      Fw0zNDA4MjEwMDIyMDZaMCIxCzAJBgNVBAoTAk9DMRMwEQYDVQQDEwpPQyBSb290
      IENBMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE4a0v9M7sHZYeqmIjuu3qEPAT
      VfC5Eog2hzTPB7Usf3ftcpS1jO6OErSNAHA3kVpPsRw20Tpbf5YhaA2kPWP/l6NF
      MEMwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQEwHQYDVR0OBBYE
      FCFg1/QZzgzUD96mZOdodyFLMW8iMAoGCCqGSM49BAMCA0gAMEUCIEglSImL62K6
      e5+hPtE4Hg13hFwfoEoilyUQHM6ibQtaAiEA0ml1mtq84iIP/NwtZB/ZgfPMgqXN
      nUyyBHrAD22zaOo=
      -----END CERTIFICATE-----
    ''
  ];

  # VM services setup
  services.qemuGuest.enable = true;
  services.fstrim.enable = true;
  systemd.services.fstrim.startAt = "daily";

  # OpenSSH setup
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
  };
}
