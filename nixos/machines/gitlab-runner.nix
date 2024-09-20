{ config, pkgs, ... }:

let
  # GitLab Runner settings
  gitlab_runner_image = "gitlab/gitlab-runner:ubuntu-v17.3.1";
  gitlab_runner_config_dir = "/srv/gitlab-runner";
in
{
  # Docker setup
  virtualisation.podman.enable = false;
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      userland-proxy = false;
      experimental = false;
      ipv6 = false;
    };
  };

  # TODO: describe config.toml <<here>>

  # Define GitLab Runner container as systemd service
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      gitlab-runner = {
        image = gitlab_runner_image;
        autoStart = true;
        volumes = [
          # Docker executor needs Docker socket
          "/var/run/docker.sock:/var/run/docker.sock"

          # GitLab Runner config
          "${gitlab_runner_config_dir}:/etc/gitlab-runner"

          # CA certificates
          "/etc/static/ssl/certs/ca-certificates.crt:/etc/gitlab-runner/certs/ca.crt:ro"

          # Do not create an unnamed volume for these directories
          "/tmp/gitlab-runner-home:/home/gitlab-runner:ro"
        ];
      };
    };
  };

  # Define a service to cleanup unused images
  systemd.services.docker-gitlab-runner-cleanup = {
    script = ''
      set -eu
      ${pkgs.docker}/bin/docker image prune -af
    '';
    wantedBy = [ "docker.service" ];
    after = [ "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # ... and run it daily
  systemd.timers.docker-gitlab-runner-cleanup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "docker-gitlab-runner-cleanup.service";
    };
  };
}
