_:
let
  hmModule = _: {
    programs.mpv = {
      enable = true;
      config = {
        keep-open = "always";
        keepaspect-window = "no";
        geometry = "100%x100%";
        video-recenter = "yes";
        reset-on-next-file = "video-rotate,video-zoom,panscan";
        hr-seek = "yes";
        screenshot-template = "%F&t=%wf";
        screenshot-dir = "~/Downloads";
        screenshot-format = "png";
      };
      profiles = {
        image = {
          script-opts = "osc-visibility=never";
          profile-cond = "get('current-tracks/video/image') and not get('current-tracks/video/albumart') and mp.command('enable-section image')";
          profile-restore = "copy";
        };
        image-hq = {
          profile-cond = "get('current-tracks/video/image') and width < 5000";
          profile-restore = "copy";
          scale = "spline36";
          cscale = "spline36";
          dscale = "mitchell";
          dither-depth = "auto";
          correct-downscaling = "yes";
          sigmoid-upscaling = "yes";
        };
        gif = {
          profile-cond = "filename and filename:match('%.gif$') ~= nil";
          loop = "yes";
          profile-restore = "copy";
        };
        video = {
          profile-cond = "get('current-tracks/video/image') == false and mp.command('disable-section image')";
          profile = "gpu-hq";
          profile-restore = "copy";
        };
      };
    };
  };
in
{
  config = {
    flake.modules.homeManager.mpv = hmModule;
    autix.home.modules.mpv = hmModule;
  };
}
