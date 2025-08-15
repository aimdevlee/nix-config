# Unstable packages overlay
# Selectively use packages from nixpkgs-unstable for newer versions
{ inputs }:
final: prev:
let
  # Import unstable nixpkgs
  unstable = import inputs.nixpkgs-unstable {
    system = final.system;
    config = final.config;
  };
in
{
  # Tools that benefit from being on latest version
  # These packages will use unstable versions instead of stable
  
  # Development tools - often need latest features
  gh = unstable.gh;                    # GitHub CLI updates frequently
  nodejs = unstable.nodejs_24;         # Latest Node.js version
  
  # Language servers - better to have latest features
  nil = unstable.nil;                   # Nix LSP
  lua-language-server = unstable.lua-language-server;
  
  # Terminal tools - new features and fixes
  tmux = unstable.tmux;                 # Terminal multiplexer
  eza = unstable.eza;                   # Modern ls replacement
  zoxide = unstable.zoxide;             # Smart cd
  
  # Cloud tools - API changes require latest versions
  awscli2 = unstable.awscli2;          # AWS CLI v2
  
  # Container tools - rapidly evolving
  podman = unstable.podman;             # Container runtime
  podman-compose = unstable.podman-compose;
  
  # Add unstable package set as an attribute for optional use
  unstable-pkgs = unstable;
}