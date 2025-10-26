{ lib
, pkgs
, ...
}:
{
  hardware.fancontrol = {
    enable = true;
    config = "";
  };
  environment.systemPackages = with pkgs; [
    lm_sensors
  ];
  systemd.services = {
    fancontrol-generate-config = {
      description = "Generate fancontrol config with correct hwmon indices";
      wantedBy = [ "multi-user.target" ];
      before = [ "fancontrol.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
              set -e
              nct_idx=""
              k10temp_idx=""
              for d in /sys/class/hwmon/hwmon*/name; do
                name=$(cat "$d")
                idx=$(basename $(dirname "$d"))
                case "$name" in
                  nct6779) nct_idx="$idx" ;;
                  k10temp) k10temp_idx="$idx" ;;
                esac
              done
              if [ -z "$nct_idx" ]; then
                echo "nct6779 hwmon device not found!" >&2
                exit 1
              fi
              if [ -z "$k10temp_idx" ]; then
                echo "k10temp hwmon device not found!" >&2
                exit 1
              fi
              cat > /run/fancontrol.conf <<EOF
        # Generated at boot
        INTERVAL=10
        DEVPATH=$k10temp_idx=devices/pci0000:00/0000:00:18.3 $nct_idx=devices/platform/nct6775.656
        DEVNAME=$k10temp_idx=k10temp $nct_idx=nct6779
        FCTEMPS=$nct_idx/pwm2=$k10temp_idx/temp1_input $nct_idx/pwm3=$k10temp_idx/temp1_input
        FCFANS=$nct_idx/pwm2=$nct_idx/fan2_input
        MINTEMP=$nct_idx/pwm2=65 $nct_idx/pwm3=65
        MAXTEMP=$nct_idx/pwm2=90 $nct_idx/pwm3=90
        MINSTART=$nct_idx/pwm2=30 $nct_idx/pwm3=30
        MINSTOP=$nct_idx/pwm2=20 $nct_idx/pwm3=20
        EOF
      '';
    };
    fancontrol = {
      after = [ "fancontrol-generate-config.service" ];
      requires = [ "fancontrol-generate-config.service" ];
      serviceConfig.ExecStart = lib.mkForce "${pkgs.lm_sensors}/bin/fancontrol /run/fancontrol.conf";
      unitConfig.X-StopOnReconfiguration = false;
    };
  };
  boot.kernelModules = [
    "k10temp"
    "nct6775"
  ];
}
