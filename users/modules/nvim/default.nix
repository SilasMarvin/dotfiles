{ config, pkgs, lib, colorscheme, ... }:
let
  blackv19 = with pkgs; (black.overrideAttrs (o:
    rec {
      pname = "black";
      version = "19.10b0";
      src = python3Packages.fetchPypi {
        inherit pname version;
        hash = "sha256-wu23Ogjp4Ob2Wg5q8YsFm4sc3VvvmX16Cxgd+T3IFTk=";
      };
      propagatedBuildInputs = with python3Packages; [
        attrs
        appdirs
        click
        toml
        aiohttp
        aiohttp-cors
        pathspec
        regex
        typed-ast
      ];
      disabledTests = [
        # requires network access
        "test_gen_check_output"
        "test_cache_multiple_files"
        "test_expression"
        "test_expression_diff"
        "test_expression_ff"
        "test_shhh_click"
        "test_failed_formatting_does_not_get_cached"
      ];
    }));
in
{
  home.packages = with pkgs;
    [
      # elm
      elmPackages.elm-language-server
      elmPackages.elm
      elmPackages.elm-test
      elmPackages.elm-format

      # Go
      gopls

      # Haskell
      haskellPackages.haskell-language-server

      # JavaScript
      nodePackages.typescript-language-server

      # lua
      luaformatter
      sumneko-lua-language-server

      # Nix
      rnix-lsp

      # python
      python3Packages.isort
      nodePackages.pyright
      blackv19

      # Rust
      rust-analyzer
      rustfmt
      clippy
      # lldb # debugging setup

      # SQL
      sqls

      # terraform
      terraform-ls

      # general purpose / multiple langs
      efm-langserver
      nodePackages.prettier

      # shit you need to deal with
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vscode-langservers-extracted
      nodePackages.vim-language-server
      nodePackages.yaml-language-server
      # This is a cli utility as we can't display all this in cli
      nodePackages.livedown
      pandoc

    ] ++ (if pkgs.stdenv.isLinux then [
      # Depends on pygls which does not build on darwin
      cmake-language-server
    ] else [

    ]);

  programs.neovim = {
    enable = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Appearance
      indent-blankline-nvim
      barbar-nvim
      nvim-tree-lua
      nvim-web-devicons
      lualine-nvim
      one-nvim
      dracula-vim
      nvim-colorizer-lua
      tokyonight-nvim

      # Programming
      which-key-nvim
      vim-haskellConcealPlus # vimscript
      lspkind-nvim
      nvim-treesitter
      nvim-treesitter-refactor
      nvim-treesitter-textobjects
      nvim-lspconfig
      lspsaga-nvim
      lsp_signature-nvim
      rust-tools-nvim
      symbols-outline-nvim
      fidget-nvim
      crates-nvim

      ## Autocompletion setup
      nvim-cmp
      cmp-path
      cmp-vsnip
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-treesitter
      cmp-calc
      copilot-vim
      vim-vsnip
      vim-vsnip-integ

      ## Project management
      project-nvim
      direnv-vim

      # Text objects
      tcomment_vim # vimscript
      vim-surround # vimscript
      vim-repeat # vimscript
      nvim-autopairs

      # Git
      vim-fugitive # vimscript
      gitsigns-nvim

      # DAP
      nvim-dap
      nvim-dap-ui

      # Fuzzy Finder
      telescope-nvim
      telescope-fzf-native-nvim
      cheatsheet-nvim

      # Text Helpers
      vim-table-mode # vimscript
      venn-nvim
      todo-comments-nvim

      # General Deps
      popup-nvim
      plenary-nvim
      nui-nvim
    ];

    extraConfig = ''
      colorscheme ${colorscheme.vim-name}
      ${builtins.readFile ./base-sane.vim}

      lua << EOF
        ${builtins.readFile ./base-sane.lua}
        ${builtins.readFile ./look-theme.lua}

        local statusline_theme = '${colorscheme.vim-statusline}'

        ${builtins.readFile ./look-dashboard.lua}
        ${builtins.readFile ./look-colorizer.lua}
        ${builtins.readFile ./look-statusline.lua}

        ${builtins.readFile ./ide-treesitter.lua}

        ${builtins.readFile ./git.lua}
        ${builtins.readFile ./todo.lua}
        ${builtins.readFile ./edit.lua}

        ${builtins.readFile ./nav-project.lua}
        ${builtins.readFile ./nav-nvim-tree.lua}
        ${builtins.readFile ./nav-telescope.lua}
        ${builtins.readFile ./nav-which_key.lua}
      EOF
    '';
  };
}
