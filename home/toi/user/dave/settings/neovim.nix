{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.host.home.applications.neovim;
in
with lib;
{
  config = mkIf cfg.enable {
    programs.nixvim = {
      globals = {
        mapleader = " ";                         # <Space> as leader key
        maplocalleader = " ";                    # local leader (<leader>l)
        autoformat = true;                       # enable auto-format on save
        snacks_animate = true;                   # enable snacks animations
        root_spec = lib.mkDefault [ "lsp" { __unkeyed-1 = ".git"; __unkeyed-2 = "lua"; } "cwd" ];  # project root detection
        deprecation_warnings = false;            # silence nvim deprecation notices
        trouble_lualine = true;                  # show trouble symbols in lualine
        markdown_recommended_style = 0;          # disable md indent overrides
      };
      opts = {
        autowrite = true;                        # auto-save on :make etc
        clipboard = "unnamedplus";               # sync with system clipboard
        completeopt = "menu,menuone,noselect";   # completion popup behaviour
        conceallevel = 2;                        # hide * markers, show substitutions
        confirm = true;                          # confirm before exiting modified buffer
        cursorline = true;                       # highlight current line
        expandtab = true;                        # spaces over tabs
        fillchars = {
          eob = " ";
          foldopen = "";
          foldclose = "";
          fold = " ";
          foldsep = " ";
          diff = "╱";
        };
        foldlevel = 99;                          # open all folds by default
        foldmethod = "indent";                   # indent-based folding
        foldtext = "";                           # no fold label
        formatoptions = "jcroqlnt";
        grepformat = "%f:%l:%c:%m";              # grep output format
        grepprg = "rg --vimgrep";                # use ripgrep for :grep
        ignorecase = true;                       # case-insensitive search
        inccommand = "nosplit";                  # live preview of substitutions
        jumpoptions = "view";                    # preserve column when jumping
        laststatus = 3;                          # global statusline (one per screen)
        linebreak = true;                        # wrap at convenient word breaks
        list = true;                             # show invisible characters
        mouse = "a";                             # enable mouse
        number = true;                           # line numbers
        pumblend = 10;                           # popup menu transparency
        pumheight = 10;                          # max completion items
        relativenumber = true;                   # relative line numbers
        ruler = false;                           # disable default ruler (statusline covers it)
        scrolloff = 4;                           # context lines above/below cursor
        sessionoptions = [
          "buffers"                              # save/restore buffer list
          "curdir"                               # save/restore current directory
          "tabpages"                             # save/restore tab pages
          "winsize"                              # save/restore window sizes
          "help"                                 # save/restore help windows
          "globals"                              # save/restore global variables
          "skiprtp"                              # skip runtimepath (doesn't change)
          "folds"                                # save/restore folds
        ];
        shiftround = true;                       # round indent to shiftwidth
        shiftwidth = 2;                          # indent width
        showmode = false;                        # hide mode (statusline shows it)
        sidescrolloff = 8;                       # horizontal scroll context
        signcolumn = "yes";                      # always show diagnostics/git signs
        smartcase = true;                        # case-sensitive when uppercase in search
        smartindent = true;                      # auto-indent
        smoothscroll = false;                     # smooth horizontal scroll
        spelllang = [ "en" ];                    # spell check language
        splitbelow = true;                       # new horizontal split below
        splitkeep = "screen";                    # keep view when splitting
        splitright = true;                       # new vertical split right
        tabstop = 2;                             # display width of tab
        termguicolors = true;                    # 24-bit colour
        timeoutlen = 300;                        # which-key trigger time
        undofile = true;                         # persistent undo
        undolevels = 10000;                      # undo history depth
        updatetime = 200;                        # swap file / CursorHold trigger
        virtualedit = "block";                   # free cursor in visual block mode
        wildmode = "longest:full,full";          # cmdline completion style
        winminwidth = 5;                         # minimum window width
        wrap = false;                            # no line wrap by default
        swapfile = false;
        backup = false;
        hlsearch = false;                        # no persistent search highlight
        incsearch = true;                        # highlight matches while typing
      };

      colorschemes = {
        tokyonight = {
          enable = true;
          settings = {
            style = "storm";                     # moon | storm | night | day
            transparent = false;
            terminal_colors = true;
            styles = {
              comments = { italic = true; };
              keywords = { italic = true; };
              functions = { };
              variables = { };
              sidebars = "dark";
              floats = "dark";
            };
            sidebars = [
             "qf"
             "help"
            ];
            day_brightness = 0.3;
            dim_inactive = false;
            lualine_bold = false;
          };
        };
      };

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = pkgs.stdenv.hostPlatform.isLinux;
      };

      extraPackages = with pkgs; [
        fzf                                      # fuzzy finder (fzf-lua)
        stylua                                   # Lua formatter (conform)
      ];

      keymaps = [
        # Movement — smart line-aware up/down
        { key = "j";       mode = [ "n" "x" ]; action = "v:count == 0 ? 'gj' : 'j'";          options = { desc = "Down"; expr = true; silent = true; }; }
        { key = "k";       mode = [ "n" "x" ]; action = "v:count == 0 ? 'gk' : 'k'";          options = { desc = "Up"; expr = true; silent = true; }; }
        { key = "<Down>";  mode = [ "n" "x" ]; action = "v:count == 0 ? 'gj' : 'j'";          options = { desc = "Down"; expr = true; silent = true; }; }
        { key = "<Up>";    mode = [ "n" "x" ]; action = "v:count == 0 ? 'gk' : 'k'";          options = { desc = "Up"; expr = true; silent = true; }; }

        # Window navigation — Ctrl + hjkl
        { key = "<C-h>";   mode = [ "n" ]; action = "<C-w>h";                                 options = { desc = "Go to Left Window"; remap = true; }; }
        { key = "<C-j>";   mode = [ "n" ]; action = "<C-w>j";                                 options = { desc = "Go to Lower Window"; remap = true; }; }
        { key = "<C-k>";   mode = [ "n" ]; action = "<C-w>k";                                 options = { desc = "Go to Upper Window"; remap = true; }; }
        { key = "<C-l>";   mode = [ "n" ]; action = "<C-w>l";                                 options = { desc = "Go to Right Window"; remap = true; }; }

        # Window resize — Ctrl + arrow keys
        { key = "<C-Up>";    mode = [ "n" ]; action = "<cmd>resize +2<cr>";                    options = { desc = "Increase Window Height"; }; }
        { key = "<C-Down>";  mode = [ "n" ]; action = "<cmd>resize -2<cr>";                    options = { desc = "Decrease Window Height"; }; }
        { key = "<C-Left>";  mode = [ "n" ]; action = "<cmd>vertical resize -2<cr>";           options = { desc = "Decrease Window Width"; }; }
        { key = "<C-Right>"; mode = [ "n" ]; action = "<cmd>vertical resize +2<cr>";           options = { desc = "Increase Window Width"; }; }

        # Move lines — Alt + j/k
        { key = "<A-j>"; mode = [ "n" ]; action = "<cmd>execute 'move .+' . v:count1<cr>==";   options = { desc = "Move Line Down"; }; }
        { key = "<A-k>"; mode = [ "n" ]; action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>=="; options = { desc = "Move Line Up"; }; }
        { key = "<A-j>"; mode = [ "i" ]; action = "<esc><cmd>m .+1<cr>==gi";                   options = { desc = "Move Line Down"; }; }
        { key = "<A-k>"; mode = [ "i" ]; action = "<esc><cmd>m .-2<cr>==gi";                   options = { desc = "Move Line Up"; }; }
        { key = "<A-j>"; mode = [ "x" ]; action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv"; options = { desc = "Move Selection Down"; }; }
        { key = "<A-k>"; mode = [ "x" ]; action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv"; options = { desc = "Move Selection Up"; }; }

        # Buffer navigation — Shift + h/l, [b/]b
        { key = "<S-h>";   mode = [ "n" ]; action = "<cmd>bprevious<cr>";                     options = { desc = "Prev Buffer"; }; }
        { key = "<S-l>";   mode = [ "n" ]; action = "<cmd>bnext<cr>";                         options = { desc = "Next Buffer"; }; }
        { key = "[b";      mode = [ "n" ]; action = "<cmd>bprevious<cr>";                     options = { desc = "Prev Buffer"; }; }
        { key = "]b";      mode = [ "n" ]; action = "<cmd>bnext<cr>";                         options = { desc = "Next Buffer"; }; }
        { key = "<leader>bb";  mode = [ "n" ]; action = "<cmd>e #<cr>";                       options = { desc = "Switch to Other Buffer"; }; }
        { key = "<leader>`";   mode = [ "n" ]; action = "<cmd>e #<cr>";                       options = { desc = "Switch to Other Buffer"; }; }
        { key = "<leader>bd";  mode = [ "n" ]; action.__raw = "function() Snacks.bufdelete() end";          options = { desc = "Delete Buffer"; }; }
        { key = "<leader>bo";  mode = [ "n" ]; action.__raw = "function() Snacks.bufdelete.other() end";    options = { desc = "Delete Other Buffers"; }; }
        { key = "<leader>bD";  mode = [ "n" ]; action = "<cmd>:bd<cr>";                       options = { desc = "Delete Buffer and Window"; }; }

        # Bufferline extras
        { key = "<leader>bl"; mode = [ "n" ]; action = "<cmd>BufferLineCloseLeft<cr>";        options = { desc = "Close buffers to left"; }; }
        { key = "<leader>bp"; mode = [ "n" ]; action = "<cmd>BufferLineTogglePin<cr>";        options = { desc = "Toggle pin"; }; }
        { key = "<leader>bP"; mode = [ "n" ]; action = "<Cmd>BufferLineGroupClose ungrouped<CR>"; options = { desc = "Close unpinned buffers"; }; }

        # Save / Quit
        { key = "<leader>w";  mode = [ "n" ]; action = "<cmd>w<cr>";                          options = { desc = "Save"; }; }
        { key = "<C-s>";      mode = [ "i" "x" "n" "s" ]; action = "<cmd>w<cr><esc>";        options = { desc = "Save File"; }; }
        { key = "<leader>q";  mode = [ "n" ]; action = "<cmd>q<cr>";                          options = { desc = "Quit"; }; }
        { key = "<leader>qq"; mode = [ "n" ]; action = "<cmd>qa<cr>";                         options = { desc = "Quit All"; }; }

        # Clear search on escape
        { key = "<Esc>"; mode = [ "i" "n" "s" ]; action.__raw = "function() vim.cmd('noh'); return '<esc>' end"; options = { expr = true; desc = "Escape and Clear hlsearch"; }; }

        # Smart search navigation
        { key = "n"; mode = [ "n" ]; action = "'Nn'[v:searchforward].'zv'";                   options = { expr = true; desc = "Next Search Result"; }; }
        { key = "N"; mode = [ "n" ]; action = "'nN'[v:searchforward].'zv'";                   options = { expr = true; desc = "Prev Search Result"; }; }

        # Undo breakpoints — break undo sequence after punctuation
        { key = ","; mode = [ "i" ]; action = ",<c-g>u";                                      options = { desc = "Undo breakpoint"; }; }
        { key = "."; mode = [ "i" ]; action = ".<c-g>u";                                      options = { desc = "Undo breakpoint"; }; }
        { key = ";"; mode = [ "i" ]; action = ";<c-g>u";                                      options = { desc = "Undo breakpoint"; }; }

        # Indenting — keep visual selection after indent
        { key = "<"; mode = [ "x" ]; action = "<gv";                                          options = { desc = "Indent Left"; }; }
        { key = ">"; mode = [ "x" ]; action = ">gv";                                          options = { desc = "Indent Right"; }; }

        # Commenting — add comment below/above
        { key = "gco"; mode = [ "n" ]; action = "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";  options = { desc = "Add Comment Below"; }; }
        { key = "gcO"; mode = [ "n" ]; action = "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";  options = { desc = "Add Comment Above"; }; }

        # File browser (yazi)
        { key = "<leader>e";  mode = [ "n" ]; action = "<cmd>Yazi<cr>";                       options = { desc = "File Browser"; }; }

        # Find / pick (fzf-lua)
        { key = "<leader>ff"; mode = [ "n" ]; action = "<cmd>FzfLua files<CR>";                  options = { desc = "Find Files"; }; }
        { key = "<leader>fg"; mode = [ "n" ]; action = "<cmd>FzfLua live_grep<CR>";              options = { desc = "Find Text (Grep)"; }; }
        { key = "<leader>fb"; mode = [ "n" ]; action = "<cmd>FzfLua buffers<CR>";                options = { desc = "Find Buffers"; }; }
        { key = "<leader>fr"; mode = [ "n" ]; action = "<cmd>FzfLua oldfiles<CR>";               options = { desc = "Recent Files"; }; }
        { key = "<leader>sg"; mode = [ "n" ]; action = "<cmd>FzfLua live_grep<CR>";              options = { desc = "Grep"; }; }
        { key = "<leader>sw"; mode = [ "n" "x" ]; action = "<cmd>FzfLua grep_visual<CR>";        options = { desc = "Grep Word"; }; }
        { key = "<leader>sb"; mode = [ "n" ]; action = "<cmd>FzfLua lines<CR>";                  options = { desc = "Buffer Lines"; }; }
        { key = "<leader>gs"; mode = [ "n" ]; action = "<cmd>FzfLua git_status<CR>";             options = { desc = "Git Status"; }; }
        { key = "<leader>sh"; mode = [ "n" ]; action = "<cmd>FzfLua help_tags<CR>";              options = { desc = "Help Pages"; }; }

        # Dashboard
        { key = "<leader>fd"; mode = [ "n" ]; action = "<cmd>lua Snacks.dashboard()<cr>";          options = { desc = "Dashboard"; }; }

        # New file
        { key = "<leader>fn"; mode = [ "n" ]; action = "<cmd>enew<cr>";                       options = { desc = "New File"; }; }

        # Redraw / clear highlights
        { key = "<leader>ur"; mode = [ "n" ]; action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>"; options = { desc = "Redraw / Clear hlsearch / Diff Update"; }; }

        # Diagnostics
        { key = "<leader>cd"; mode = [ "n" ]; action.__raw = "vim.diagnostic.open_float";     options = { desc = "Line Diagnostics"; }; }
        { key = "]d"; mode = [ "n" ]; action.__raw = "function() vim.diagnostic.jump({ count = 1, float = true }) end";  options = { desc = "Next Diagnostic"; }; }
        { key = "[d"; mode = [ "n" ]; action.__raw = "function() vim.diagnostic.jump({ count = -1, float = true }) end"; options = { desc = "Prev Diagnostic"; }; }

        # Window splits
        { key = "<leader>-";  mode = [ "n" ]; action = "<C-W>s"; options = { desc = "Split Below";    remap = true; }; }
        { key = "<leader>|";  mode = [ "n" ]; action = "<C-W>v"; options = { desc = "Split Right";    remap = true; }; }
        { key = "<leader>wd"; mode = [ "n" ]; action = "<C-W>c"; options = { desc = "Delete Window";  remap = true; }; }

        # Tabs
        { key = "<leader><tab>l"; mode = [ "n" ]; action = "<cmd>tablast<cr>";     options = { desc = "Last Tab"; }; }
        { key = "<leader><tab>o"; mode = [ "n" ]; action = "<cmd>tabonly<cr>";     options = { desc = "Close Other Tabs"; }; }
        { key = "<leader><tab>f"; mode = [ "n" ]; action = "<cmd>tabfirst<cr>";    options = { desc = "First Tab"; }; }
        { key = "<leader><tab><tab>"; mode = [ "n" ]; action = "<cmd>tabnew<cr>";  options = { desc = "New Tab"; }; }
        { key = "<leader><tab>]"; mode = [ "n" ]; action = "<cmd>tabnext<cr>";     options = { desc = "Next Tab"; }; }
        { key = "<leader><tab>d"; mode = [ "n" ]; action = "<cmd>tabclose<cr>";    options = { desc = "Close Tab"; }; }
        { key = "<leader><tab>["; mode = [ "n" ]; action = "<cmd>tabprevious<cr>"; options = { desc = "Previous Tab"; }; }

        # Gitsigns — hunk navigation and staging
        { key = "]h"; mode = [ "n" ]; action.__raw = "function() if vim.wo.diff then vim.cmd.normal({']c', bang = true}) else require('gitsigns').nav_hunk('next') end end"; options = { desc = "Next Hunk"; }; }
        { key = "[h"; mode = [ "n" ]; action.__raw = "function() if vim.wo.diff then vim.cmd.normal({'[c', bang = true}) else require('gitsigns').nav_hunk('prev') end end"; options = { desc = "Prev Hunk"; }; }
        { key = "<leader>ghs"; mode = [ "n" "x" ]; action = ":Gitsigns stage_hunk<CR>";   options = { desc = "Stage Hunk"; }; }
        { key = "<leader>ghr"; mode = [ "n" "x" ]; action = ":Gitsigns reset_hunk<CR>";   options = { desc = "Reset Hunk"; }; }
        { key = "<leader>ghp"; mode = [ "n" ]; action.__raw = "function() require('gitsigns').preview_hunk_inline() end"; options = { desc = "Preview Hunk"; }; }
        { key = "<leader>ghb"; mode = [ "n" ]; action.__raw = "function() require('gitsigns').blame_line({full = true}) end"; options = { desc = "Blame Line"; }; }
        { key = "<leader>ghd"; mode = [ "n" ]; action.__raw = "function() require('gitsigns').diffthis() end"; options = { desc = "Diff This"; }; }

        # Lazygit
        { key = "<leader>gg"; mode = [ "n" ]; action = "<cmd>LazyGit<CR>";                  options = { desc = "Lazygit (root dir)"; }; }

        # Trouble — diagnostics, symbols, quickfix
        { key = "<leader>xx"; mode = [ "n" ]; action = "<cmd>Trouble diagnostics toggle<cr>";            options = { desc = "Diagnostics (Trouble)"; }; }
        { key = "<leader>xX"; mode = [ "n" ]; action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>"; options = { desc = "Buffer Diagnostics (Trouble)"; }; }
        { key = "<leader>cs"; mode = [ "n" ]; action = "<cmd>Trouble symbols toggle<cr>";               options = { desc = "Symbols (Trouble)"; }; }
        { key = "<leader>cS"; mode = [ "n" ]; action = "<cmd>Trouble lsp toggle<cr>";                   options = { desc = "LSP references/definitions (Trouble)"; }; }
        { key = "<leader>xL"; mode = [ "n" ]; action = "<cmd>Trouble loclist toggle<cr>";               options = { desc = "Location List (Trouble)"; }; }
        { key = "<leader>xQ"; mode = [ "n" ]; action = "<cmd>Trouble qflist toggle<cr>";                options = { desc = "Quickfix List (Trouble)"; }; }
        { key = "[q"; mode = [ "n" ]; action.__raw = "function() if require('trouble').is_open() then require('trouble').prev({skip_groups = true, jump = true}) else pcall(vim.cmd.cprev) end end"; options = { desc = "Prev Trouble/Quickfix"; }; }
        { key = "]q"; mode = [ "n" ]; action.__raw = "function() if require('trouble').is_open() then require('trouble').next({skip_groups = true, jump = true}) else pcall(vim.cmd.cnext) end end"; options = { desc = "Next Trouble/Quickfix"; }; }

        # Noice — notification history
        { key = "<leader>snl"; mode = [ "n" ]; action = "<cmd>Noice last<CR>";              options = { desc = "Noice Last Message"; }; }
        { key = "<leader>snh"; mode = [ "n" ]; action = "<cmd>Noice history<CR>";           options = { desc = "Noice History"; }; }
        { key = "<leader>sna"; mode = [ "n" ]; action = "<cmd>Noice all<CR>";               options = { desc = "Noice All"; }; }
        { key = "<leader>snd"; mode = [ "n" ]; action = "<cmd>Noice dismiss<CR>";           options = { desc = "Dismiss All"; }; }
        { key = "<leader>snt"; mode = [ "n" ]; action = "<cmd>Noice pick<CR>";              options = { desc = "Noice Picker"; }; }
        { key = "<S-Enter>"; mode = [ "c" ]; action.__raw = "function() require('noice').redirect(vim.fn.getcmdline()) end"; options = { desc = "Redirect Cmdline"; }; }
        { key = "<c-f>"; mode = [ "i" "n" "s" ]; action.__raw = "function() if not require('noice.lsp').scroll(4) then return '<c-f>' end end"; options = { expr = true; silent = true; desc = "Scroll Forward"; }; }
        { key = "<c-b>"; mode = [ "i" "n" "s" ]; action.__raw = "function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end"; options = { expr = true; silent = true; desc = "Scroll Backward"; }; }
      ];

      ## Definitions for commands
      autoGroups = {
        checktime = { clear = true; };
        highlight_yank = { clear = true; };
        resize_splits = { clear = true; };
        last_loc = { clear = true; };
        close_with_q = { clear = true; };
        man_unlisted = { clear = true; };
        wrap_spell = { clear = true; };
        json_conceal = { clear = true; };
        auto_create_dir = { clear = true; };
      };

      ## Event Handlers
      autoCmd = [

        # Reload file when neovim regains focus
        { event = [ "FocusGained" "TermClose" "TermLeave" ];
          group = "checktime";
          callback.__raw = "function() if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end end"; }

        # Highlight yanked text region
        { event = "TextYankPost";
          group = "highlight_yank";
          callback.__raw = "function() if vim.fn.has('nvim-0.13') == 1 then vim.hl.hl_op() else (vim.hl or vim.highlight).on_yank() end end"; }

        # Re-equalize splits when the window manager resizes
        { event = "VimResized";
          group = "resize_splits";
          callback.__raw = "function() local t = vim.fn.tabpagenr(); vim.cmd('tabdo wincmd ='); vim.cmd('tabnext ' .. t) end"; }

        # Restore cursor position when reopening a file
        { event = "BufReadPost";
          group = "last_loc";
          callback.__raw = "function(ev) local ex={'gitcommit'}; local b=ev.buf; if vim.tbl_contains(ex, vim.bo[b].filetype) or vim.b[b].last_loc then return end; vim.b[b].last_loc=true; local m=vim.api.nvim_buf_get_mark(b,'\"'); local l=vim.api.nvim_buf_line_count(b); if m[1]>0 and m[1]<=l then pcall(vim.api.nvim_win_set_cursor,0,m) end end"; }

        # Press q to close scratch/filetype windows (help, qf, trouble, etc.)
        { event = "FileType";
          group = "close_with_q";
          pattern = [ "PlenaryTestPopup" "checkhealth" "dap-float" "dbout" "gitsigns-blame" "grug-far" "help" "lspinfo" "neotest-output" "neotest-output-panel" "neotest-summary" "notify" "qf" "spectre_panel" "startuptime" "tsplayground" ];
          callback.__raw = "function(ev) vim.bo[ev.buf].buflisted=false; vim.schedule(function() vim.keymap.set('n','q',function() vim.cmd('close'); pcall(vim.api.nvim_buf_delete,ev.buf,{force=true}) end,{buffer=ev.buf,silent=true,desc='Quit buffer'}) end) end"; }

        # Don't list man pages in the buffer list
        { event = "FileType";
          group = "man_unlisted";
          pattern = [ "man" ];
          callback.__raw = "function(ev) vim.bo[ev.buf].buflisted = false end"; }

        # Enable wrap + spell for prose file types
        { event = "FileType";
          group = "wrap_spell";
          pattern = [ "text" "plaintex" "typst" "gitcommit" "markdown" ];
          callback.__raw = "function() vim.opt_local.wrap = true; vim.opt_local.spell = true end"; }

        # Show JSON conceal characters (disable hiding)
        { event = "FileType";
          group = "json_conceal";
          pattern = [ "json" "jsonc" "json5" ];
          callback.__raw = "function() vim.opt_local.conceallevel = 0 end"; }

        # Auto-create parent directories on :w
        { event = "BufWritePre";
          group = "auto_create_dir";
          callback.__raw = "function(ev) if ev.match:match('^%w%w+:[\\/][\\/]') then return end; local f=vim.uv.fs_realpath(ev.match) or ev.match; vim.fn.mkdir(vim.fn.fnamemodify(f,':p:h'),'p') end"; }
      ];

      plugins = {
        mini = {                                             # text objects, pairs, icons
          modules = {
            ai = { };
            pairs = { };
            icons = { };
          };
        };
        auto-save = {                                        # auto-save buffers on idle/blur
          enable = true;
        };
        aerial = {                                           # code outline sidebar
          enable = true;
          autoLoad = true;
          settings = {
            attach_mode = "global";
            backends = [
              "treesitter"
              "lsp"
              "markdown"
              "man"
            ];
            highlight_on_hover = true;
          };
        };
        barbecue.enable = true;                              # winbar breadcrumbs (LSP hierarchy)
        blink-cmp = {                                        # completion engine
          enable = true;
          setupLspCapabilities = true;
          settings = {
            keymap = {
              "<C-space>" = [ "show" "show_documentation" "hide_documentation" ];
              "<C-e>" = [ "hide" "fallback" ];
              "<CR>" = [ "accept" "fallback" ];
              "<Tab>" = [ "select_next" "snippet_forward" "fallback" ];
              "<S-Tab>" = [ "select_prev" "snippet_backward" "fallback" ];
              "<Up>" = [ "select_prev" "fallback" ];
              "<Down>" = [ "select_next" "fallback" ];
            };
            signature = { enabled = true; window.border = "rounded"; };
            sources.default = [
              "buffer"
              "lsp"
              "path"
              "snippets"
            ];
            appearance = {
              nerd_font_variant = "mono";
              kind_icons = {
                Text = "󰉿"; Method = ""; Function = "󰊕"; Constructor = "󰒓";
                Field = "󰜢"; Variable = "󰆦"; Property = "󰖷";
                Class = "󱡠"; Interface = "󱡠"; Struct = "󱡠"; Module = "󰅩";
                Unit = "󰪚"; Value = "󰦨"; Enum = "󰦨";
                Keyword = "󰻾"; Constant = "󰏿"; Snippet = "󱄽";
                Color = "󰏘"; File = "󰈔"; Reference = "󰬲";
                Folder = "󰉋"; Event = "󱐋"; Operator = "󰪚"; TypeParameter = "󰬛"; };
            };
            completion = {
              menu.border = "rounded";
              documentation = {
                auto_show = true;
                window.border = "rounded";
              };
              trigger.show_in_snippet = false;
              accept.auto_brackets.enabled = false;
            };
          };
        };
        bufferline = {                                       # tabline with icons & diagnostics
          enable = true;
          settings.options = {
            diagnostics = "nvim_lsp";
            mode = "buffers";
            close_icon = " ";
            buffer_close_icon = "󰱝 ";
            modified_icon = "󰔯 ";
            offsets = [{ filetype = "neo-tree"; text = "Neo-tree"; highlight = "Directory"; text_align = "left"; }];
          };
        };
        comment.enable = true;                               # gc/gcc treesitter-aware commenting
        conform-nvim = {                                     # format-on-save
          enable = true;
          settings = {
            format_on_save = ''
              function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
                if vim.bo[bufnr].filetype == "nix" or vim.bo[bufnr].filetype == "dockerfile" then return false end
                return { timeout_ms = 500, lsp_fallback = true }
              end
            '';
            notify_on_error = true;
            formatters_by_ft = {
              css = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };
              html = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };
              javascript = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };
              json = [ "jq" ];
              # "_" = [ "trim_whitespace" ];  # disabled
              lua = [ "stylua" ];
              markdown = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };
              typescript = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };
              yaml = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };

            };
            formatters = {
              stylua = { command = "${lib.getExe pkgs.stylua}"; };
            };
          };
        };
        fidget = {                                           # LSP progress spinner
          enable = true;
          settings = {
            progress = {
              poll_rate = 0;
              suppress_on_insert = true;
              display = {
                render_limit = 16;
                done_ttl = 3;
                done_icon = "✔";
                progress_ttl = 10;
                progress_icon = { pattern = "dots"; period = 1; };
              };
            };
            notification = {
              poll_rate = 10;
              filter = "info";
              history_size = 128;
              override_vim_notify = true;
              view.stack_upwards = true;
            };
          };
        };
        flash.enable = true;                                 # labelled jump (f/F/t/T)
        fzf-lua.enable = true;                               # fuzzy finder (LazyVim 14+ default)
        gitsigns = {                                         # git signs in signcolumn
          enable = true;
          settings = {
            signs = {
              add = { text = "▎"; };
              change = { text = "▎"; };
              delete = { text = ""; };
              topdelete = { text = ""; };
              changedelete = { text = "▎"; };
              untracked = { text = "▎"; };
            };
            signs_staged = {
              add = { text = "▎"; };
              change = { text = "▎"; };
              delete = { text = ""; };
              topdelete = { text = ""; };
              changedelete = { text = "▎"; };
            };
          };
        };
        grug-far.enable = true;                              # search & replace across files
        hlchunk = {                                          # indent guides & chunk highlight
          enable = true;
          settings = {
            blank = { enable = false; };
            chunk = {
              enable = true;
              use_treesitter = true;
              chars = { horizontal_line = "─"; left_bottom = "╰"; left_top = "╭"; right_arrow = "─"; vertical_line = "│"; };
              style = { fg = "#91bef0"; };
              exclude_filetypes = { lazyterm = true; neo-tree = true; };
            };
            indent = {
              chars = [ "│" ];
              enable = true;
              style = { fg = "#45475a"; };
              exclude_filetypes = { lazyterm = true; neo-tree = true; };
            };
            line_num = { style = "#91bef0"; use_treesitter = true; };
          };
        };
        lazygit = {                                          # Git TUI integration
          enable = true;
          settings = {
            floating_window_winblend = 0;
            floating_window_scaling_factor = 0.9;
            use_neovim_remote = 1;
          };
        };
        lint.enable = true;                                  # async linting engine
        lsp-lines.enable = true;                             # LSP diagnostic line numbers
        lazydev = {                                          # LuaLS completions for vim.*, snacks.*
          enable = true;
        };
        lsp = {                                              # built-in LSP client
          enable = true;
          inlayHints = true;
          servers = {
            nil_ls.enable = true;                            # Nix
            lua_ls = {
              enable = true;
              settings.Lua = {
                runtime.version = "LuaJIT";
                diagnostics.globals = [ "vim" ];
                workspace.checkThirdParty = false;
              };
            };
            ts_ls.enable = true;                             # TypeScript / JavaScript
            marksman.enable = true;                          # Markdown
            pyright.enable = true;                           # Python
            gopls.enable = true;                             # Go
            jsonls.enable = true;                            # JSON
            yamlls = {                                       # YAML w/ schema validation
              enable = true;
              extraOptions.settings.yaml = {
                schemas = {
                  "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
                  "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                  "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                  "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = "*compose*.{yml,yaml}";
                };
              };
            };
            sqls.enable = true;                              # SQL
            superhtml.enable = true;                         # HTML
            bashls.enable = true;                            # Bash
            docker_compose_language_service.enable = true;   # Docker Compose
            docker_language_server.enable = true;            # Docker Language Server
            dockerls.enable = true;                          # Docker
            dotls.enable = true;                             # .NET
            html.enable = true;                              # HTML
            jqls.enable = true;                              # jq queries
            phpactor.enable = true;                          # PHP
            tailwindcss.enable = true;                       # Tailwind CSS
          };
        };
        lualine = {                                          # statusline
          enable = true;
          settings = {
            options = {
              globalstatus = true;
              theme = "tokyonight";
              disabledFiletypes.statusline = [
                "startup"
                "alpha"
                "snacks_dashboard"
              ];
            };
            sections = {
              lualine_a = [ { __unkeyed-1 = "mode"; icon = ""; } ];
              lualine_b = [
                { __unkeyed-1 = "branch"; icon = ""; }
                { __unkeyed-1 = "diff";   symbols = {
                    added = " ";
                    modified = " ";
                    removed = " ";
                  };
                }
              ];
              lualine_c = [
                { __unkeyed-1 = "diagnostics"; sources = [ "nvim_lsp" ];
                  symbols = { error = " "; warn = " "; info = " "; hint = "󰝶 "; }; }
                { __unkeyed-1 = "filetype"; icon_only = true; separator = "";
                  padding = { left = 1; right = 0; }; }
                { __unkeyed-1 = "filename"; path = 1; }
              ];
              lualine_x = [ ];
              lualine_y = [ { __unkeyed-1 = "progress"; } ];
              lualine_z = [ { __unkeyed-1 = "location"; } ];
            };
          };
        };
        neoscroll.enable = false;                             # smooth scrolling
        nix-develop = {                                      # nix develop shell integration
          enable = true;
          autoLoad = true;
          ignoredVariables = {
            BASHOPTS = true;
            HOME = true;
            NIX_BUILD_TOP = true;
            NIX_ENFORCE_PURITY = true;
            NIX_LOG_FD = true;
            NIX_REMOTE = true;
            PPID = true;
            SHELL = true;
            SHELLOPTS = true;
            SSL_CERT_FILE = true;
            TEMP = true;
            TEMPDIR = true;
            TERM = true;
            TMP = true;
            TMPDIR = true;
            TZ = true;
            UID = true;
          };
          separatedVariables = {
            PATH = ":";
            XDG_DATA_DIRS = ":";
          };
        };
        noice = {                                            # cmdline popup replacement
          enable = true;
          settings = {
            lsp.override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
            presets = {
              bottom_search = true;
              command_palette = true;
              long_message_to_split = true;
            };
            routes = [{
              filter = { event = "msg_show"; any = [
                { find = "%d+L, %d+B"; }
                { find = "; after #%d+"; }
                { find = "; before #%d+"; }
              ]; };
              view = "mini";
            }];
          };
        };
        nvim-surround.enable = true;                         # ds/cs/ys surround operations
        persistence.enable = true;                           # auto session save/restore
        snacks = {                                           # QoL collection (picker, dashboard, notifier)
          enable = true;
          settings = {
            bigfile.enabled = true;
            indent.enabled = true;
            input.enabled = true;
            notifier.enabled = true;
            picker.enabled = false;                          # using fzf-lua instead
            quickfile.enabled = true;
            scope.enabled = true;
            scroll.enabled = false;
            statuscolumn.enabled = false;
            words.enabled = true;
            dashboard = {
              preset = {
                header = ''
                               .o88o.                                 .                       oooo
                               888 `"                               .o8                       `888
                  ooo. .oo.   o888oo  oooo d8b  .oooo.    .oooo.o .o888oo  .oooo.    .ooooo.   888  oooo
                 `888P"Y88b   888    `888""8P `P  )88b  d88(  "8   888   `P  )88b  d88' `"Y8  888 .8P'
                  888   888   888     888      .oP"888  `"Y88b.    888    .oP"888  888        888888.
                   888   888   888     888     d8(  888  o.  )88b   888 . d8(  888  888   .o8  888 `88b.
                   o888o o888o o888o   d888b    `Y888""8o 8""888P'   "888" `Y888""8o `Y8bod8P' o888o o888o
                '';
                keys = [
                  { icon = " "; key = "f"; desc = "Find File"; action = ":FzfLua files"; }
                  { icon = " "; key = "n"; desc = "New File"; action = ":ene | startinsert"; }
                  { icon = " "; key = "g"; desc = "Find Text"; action = ":FzfLua live_grep"; }
                  { icon = " "; key = "r"; desc = "Recent Files"; action = ":FzfLua oldfiles"; }
                  { icon = "󰓅 "; key = "k"; desc = "LazyGit"; action = ":LazyGit"; }
                  { icon = " "; key = "s"; desc = "Restore Session"; section = "session"; }
                  { icon = " "; key = "q"; desc = "Quit"; action = ":qa"; }
                ];
              };
              sections = [
                { section = "header"; }
                { section = "keys"; gap = 1; padding = 1; }
                { icon = " "; title = "Recent Files"; section = "recent_files"; indent = 2; padding = { __unkeyed-1 = 2; __unkeyed-2 = 2; }; }
                { icon = " "; title = "Projects"; section = "projects"; indent = 2; padding = 2; }
              ];
            };
          };
        };
        smear-cursor = {                                     # smooth cursor animation
          enable = true;
          settings = {
            distance_stop_animating = 0.5;
            stiffness = 0.8;
            trailing_stiffness = 0.5;
          };
        };
        timerly = {                                          # pomodoro timer
          enable = true;
          settings.minutes = [ 5 10 15 20 25 30 ];
        };
        todo-comments.enable = true;                         # TODO/FIX/HACK/BUG highlighting
        toggleterm = {                                       # floating terminal
          enable = true;
          settings = {
            direction = "float";
            size = 15;
            float_opts = {
              border = "curved";
              height = 30;
              width = 130;
            };
            open_mapping = "[[<c-t>]]";
            autochdir = true;
            close_on_exit = true;
            on_open.__raw = "function() vim.cmd('startinsert') end";
          };
        };
        treesitter-context.enable = true;                    # sticky function/class header
        treesitter = {                                       # syntax highlighting & parsing
          enable = true;
          nixGrammars = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };
        treesitter-textobjects = {                           # AST-based text objects
          enable = true;
          settings = {
            select = {
              enable = true;
              lookahead = true;
              keymaps = {
                "a=" = { query = "@assignment.outer"; desc = "Select around assignment"; };
                "i=" = { query = "@assignment.inner"; desc = "Select inner assignment"; };
                "aa" = { query = "@parameter.outer"; desc = "Select around parameter"; };
                "ia" = { query = "@parameter.inner"; desc = "Select inner parameter"; };
                "ai" = { query = "@conditional.outer"; desc = "Select around conditional"; };
                "ii" = { query = "@conditional.inner"; desc = "Select inner conditional"; };
                "al" = { query = "@loop.outer"; desc = "Select around loop"; };
                "il" = { query = "@loop.inner"; desc = "Select inner loop"; };
                "af" = { query = "@call.outer"; desc = "Select around function call"; };
                "if" = { query = "@call.inner"; desc = "Select inner function call"; };
                "am" = { query = "@function.outer"; desc = "Select around function"; };
                "im" = { query = "@function.inner"; desc = "Select inner function"; };
                "ac" = { query = "@class.outer"; desc = "Select around class"; };
                "ic" = { query = "@class.inner"; desc = "Select inner class"; };
              };
            };
            move = {
              enable = true;
              set_jumps = true;
              goto_next_start = {
                "]f" = { query = "@call.outer";    desc = "Next function call"; };
                "]m" = { query = "@function.outer"; desc = "Next function def"; };
                "]c" = { query = "@class.outer";    desc = "Next class"; };
              };
              goto_previous_start = {
                "[f" = { query = "@call.outer";    desc = "Prev function call"; };
                "[m" = { query = "@function.outer"; desc = "Prev function def"; };
                "[c" = { query = "@class.outer";    desc = "Prev class"; };
              };
            };
          };
        };
        treesj.enable = true;                                # toggle block split/join
        trouble = {                                          # diagnostics / references side panel
          enable = true;
          settings.modes.lsp.win.position = "right";
        };
        ts-autotag.enable = true;                            # auto-close/rename HTML/JSX tags
        ts-comments.enable = true;                           # treesitter-aware commenting
        which-key = {                                        # leader key popup
          enable = true;
          settings = {
            preset = "helix";
            delay = 200;
            spec = [
              { __unkeyed-1 = "<leader><tab>"; group = "tabs"; }
              { __unkeyed-1 = "<leader>b"; group = "buffer"; }
              { __unkeyed-1 = "<leader>c"; group = "code"; }
              { __unkeyed-1 = "<leader>d"; group = "debug"; }
              { __unkeyed-1 = "<leader>f"; group = "file/find"; }
              { __unkeyed-1 = "<leader>g"; group = "git"; }
              { __unkeyed-1 = "<leader>q"; group = "quit/session"; }
              { __unkeyed-1 = "<leader>s"; group = "search"; }
              { __unkeyed-1 = "<leader>u"; group = "ui"; }
              { __unkeyed-1 = "<leader>x"; group = "diagnostics/quickfix"; }
              { __unkeyed-1 = "["; group = "prev"; }
              { __unkeyed-1 = "]"; group = "next"; }
              { __unkeyed-1 = "g"; group = "goto"; }
              { __unkeyed-1 = "z"; group = "fold"; }
              { __unkeyed-1 = "gx"; desc = "Open with system app"; }
            ];
          };
        };
        wtf.enable = true;                                   # AI error explanation
        yanky.enable = true;                                 # yank/paste history ring
        yazi = {                                             # file browser
          enable = true;
          settings = {
            open_for_directories = true;
            floating_window_scaling_factor = 1;
            yazi_floating_window_border = "rounded";
          };
        };
        zen-mode = {                                         # distraction-free writing
          enable = true;
          settings = {
            window = {
              backdrop = 0.95;
              width = 0.8;
              height = 1;
              options.signcolumn = "no";
            };
            plugins = {
              options = {
                enabled = true;
                ruler = false;
                showcmd = false;
              };
              twilight.enabled = false;
              gitsigns.enabled = true;
              tmux.enabled = false;
            };
          };
        };
      };

      extraConfigLua = ''
        -- border styling for LSP popups (cannot be expressed in pure nix)
        local border = "rounded"
        vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
          config = vim.tbl_deep_extend("force", config or {}, { border = border })
          vim.lsp.handlers.hover(_, result, ctx, config)
        end
        vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
          config = vim.tbl_deep_extend("force", config or {}, { border = border })
          vim.lsp.handlers.signature_help(_, result, ctx, config)
        end
        vim.diagnostic.config { float = { border = border } }
      '';
   };
  };
}
