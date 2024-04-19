#"editor.formatOnPaste" = true;
#"editor.formatOnSave" = true;
#"editor.formatOnType" = false;
#"terminal.integrated.automationShell.linux" = "nix-shell";
#"terminal.integrated.defaultProfile.linux" = "zsh";

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vscode_fhs;
    jsonFormat = pkgs.formats.json { };
    vscodeUserSettings = {
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.colorTheme" = "Catppuccin Macchiato";
      "catppuccin.accentColor" = "mauve";
      "editor.fontFamily" = "JetBrainsMono Nerd Font, Material Design Icons";
      "editor.fontSize" = 15;
      "editor.fontLigatures" = true;
      "workbench.fontAliasing" = "antialiased";
      "files.trimTrailingWhitespace" = false;
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";
      "window.titleBarStyle" = "custom";
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.enableBell" = false;
      "editor.minimap.enabled" = false;
      "editor.minimap.renderCharacters" = false;
      "editor.overviewRulerBorder" = false;
      "editor.renderLineHighlight" = "all";
      "editor.inlineSuggest.enabled" = true;
      "editor.smoothScrolling" = true;
      "editor.suggestSelection" = "first";
      "editor.guides.indentation" = false;
      "window.nativeTabs" = true;
      "window.restoreWindows" = "all";
      "window.menuBarVisibility" = "toggle";
      "workbench.panel.defaultLocation" = "right";
      "workbench.editor.tabCloseButton" = "right";
      "workbench.startupEditor" = "none";
      "workbench.list.smoothScrolling" = true;
      "security.workspace.trust.enabled" = false;
      "explorer.confirmDelete" = true;
      "breadcrumbs.enabled" = true;
      "update.mode" = "none";
      "extensions.autoCheckUpdates" = false;
    };
in {
  options.modules.editors.vscode_fhs = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      vscode.fhs
    ];
 
    #home.configFile = {
    #  "Code/User/settings.json".source = jsonFormat.generate "vscode-user-settings" vscodeUserSettings;
    #};
  };
}
