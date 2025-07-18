;; -*- lexical-binding: t; -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(abbrev-file-name "~/.local/state/emacs/abbrev_defs")
 '(ansi-color-for-comint-mode nil)
 '(async-bytecomp-package-mode t)
 '(async-shell-command-buffer 'new-buffer)
 '(async-shell-command-display-buffer t)
 '(auth-source-save-behavior nil)
 '(auto-hscroll-mode 'current-line)
 '(auto-insert-mode t)
 '(auto-revert-mode-text " Rv")
 '(auto-save-list-file-prefix "~/.local/state/emacs/auto-save-list/.saves-")
 '(backup-by-copying-when-linked t)
 '(battery-load-critical 25)
 '(battery-load-low 40)
 '(bookmark-default-file "~/.local/state/emacs/bookmarks")
 '(bookmark-save-flag 1)
 '(calendar-date-style 'iso)
 '(calendar-intermonth-text
   '(propertize
     (format "%2d"
             (car
              (calendar-iso-from-absolute
               (calendar-absolute-from-gregorian
                (list month day year)))))
     'font-lock-face 'font-lock-function-name-face))
 '(calendar-time-display-form
   '(24-hours ":" minutes
              (if time-zone " (")
              time-zone
              (if time-zone ")")))
 '(calendar-week-start-day 1)
 '(checkdoc-verb-check-experimental-flag nil)
 '(comint-input-ring-size 20000)
 '(comint-terminfo-terminal "dumb-emacs-ansi")
 '(comment-empty-lines 'eol)
 '(completion-category-overrides '((file (styles basic partial-completion))))
 '(completion-ignore-case t t)
 '(completion-styles '(basic orderless))
 '(completions-format 'vertical)
 '(consult-preview-key nil)
 '(consult-preview-max-size 102400)
 '(current-language-environment "UTF-8")
 '(delete-old-versions 'other)
 '(dired-async-mode t)
 '(dired-async-skip-fast t)
 '(dired-clean-confirm-killing-deleted-buffers nil)
 '(dired-create-destination-dirs 'ask)
 '(dired-dwim-target t)
 '(dired-guess-shell-alist-user
   '(("\\.ipynb\\'" "jupyter-notebook")
     ("\\.\\(png\\|jpg\\|bmp\\)\\'" "sxiv")
     ("\\.\\(7z\\|zip\\|rar\\)\\'" "7z x" "7z l"
      (format "7z x -o\"%s\""
              (file-name-sans-extension file)))
     ("\\.\\(avi\\|flac\\|ogg\\|m4a\\|mkv\\|mp[34]\\|wav\\|webm\\|wmv\\)\\'" "mpv")))
 '(dired-isearch-filenames 'dwim)
 '(dired-vc-rename-file t)
 '(display-battery-mode t)
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(display-time-use-mail-icon t)
 '(echo-keystrokes 0.001)
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(eglot-menu-string "egl")
 '(eldoc-minor-mode-string nil)
 '(elgrep-data-file nil)
 '(emmet-indentation 2)
 '(enable-recursive-minibuffers t)
 '(epg-pinentry-mode 'loopback)
 '(file-name-shadow-tty-properties '(face file-name-shadow field shadow))
 '(find-file-visit-truename t)
 '(flymake-mode-line-lighter "Fly")
 '(flyspell-issue-message-flag nil)
 '(flyspell-issue-welcome-flag nil)
 '(flyspell-use-meta-tab nil)
 '(focus-follows-mouse t)
 '(follow-mode-line-text " Fw")
 '(frame-resize-pixelwise t)
 '(garbage-collection-messages t)
 '(git-commit-cd-to-toplevel t)
 '(global-diff-hl-mode t)
 '(global-so-long-mode t)
 '(global-tree-sitter-mode t)
 '(glyphless-char-display-control
   '((c1-control . acronym)
     (format-control . acronym)
     (no-font . acronym)))
 '(gnutls-algorithm-priority
   "SECURE192:+SECURE128:-VERS-ALL:+VERS-TLS1.2:%PROFILE_MEDIUM")
 '(gnutls-min-prime-bits 2048)
 '(gnutls-verify-error t)
 '(gofmt-command "goimports")
 '(history-length 4000)
 '(ibuffer-formats
   '((mark modified read-only locked " "
           (name 36 36 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 32 -1)
           " " filename-and-process)))
 '(ibuffer-movement-cycle nil)
 '(ibuffer-saved-filter-groups
   '(("default"
      ("Shell"
       (or
        (used-mode . shell-command-mode)
        (used-mode . shell-mode))
       (process))
      ("Dead Shell"
       (or
        (used-mode . shell-command-mode)
        (used-mode . shell-mode)))
      ("ERC"
       (used-mode . erc-mode))
      ("Tramp"
       (or
        (filename . "^/scp:")
        (filename . "^/ssh:")
        (filename . "^/sudo:")))
      ("Emacs"
       (not name . "^magit[:-]")
       (filename . "/.emacs.d/"))
      ("Src"
       (not derived-mode . comint-mode)
       (not derived-mode . special-mode)
       (filename . "/src/"))
      ("Special"
       (starred-name))
      ("Magit"
       (name . "^magit[:-]")))))
 '(image-dired-dir "~/.cache/emacs/image-dired/")
 '(image-dired-thumb-size 200)
 '(image-use-external-converter t)
 '(imenu-auto-rescan t)
 '(indent-tabs-mode nil)
 '(indicate-buffer-boundaries 'left)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(initial-scratch-message ";; Vanitas vanitatum\12;; Was yea ra chs hymmnos mea\12")
 '(isearch-allow-scroll t)
 '(js-indent-level 2)
 '(kill-do-not-save-duplicates t)
 '(kill-read-only-ok t)
 '(magit-clone-set-remote.pushDefault nil)
 '(magit-define-global-key-bindings t)
 '(magit-diff-refine-hunk 'all)
 '(magit-remote-add-set-remote.pushDefault nil)
 '(magit-repository-directories
   '(("~" . 0)
     ("~/.config/emacs" . 0)
     ("~/.config/emacs/elpa" . 0)
     ("~/.config/emacs/vc" . 1)
     ("~/src" . 1)))
 '(magit-save-repository-buffers nil)
 '(magit-wip-mode nil)
 '(mailcap-download-directory "/tmp")
 '(marginalia-mode t)
 '(max-lisp-eval-depth 10000)
 '(menu-bar-mode nil)
 '(message-log-max 5000)
 '(message-sendmail-envelope-from 'header)
 '(minibuffer-depth-indicate-mode t)
 '(minibuffer-eldef-shorten-default t)
 '(minibuffer-electric-default-mode t)
 '(minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
 '(minions-mode t)
 '(minions-prominent-modes
   '(auto-revert-mode defining-kbd-macro dired-async--modeline-mode flymake-mode follow-mode view-mode clipmag-mode comint-reaper-mode))
 '(mm-automatic-display '("text/plain"))
 '(mm-discouraged-alternatives '("text/html" "text/richtext" "text/enriched" "image/.*"))
 '(mm-enable-external 'ask)
 '(mm-html-inhibit-images t)
 '(mm-inlined-types '("text/plain" "text/html"))
 '(mm-text-html-renderer 'shr)
 '(mml-default-directory "~/")
 '(mouse-1-click-follows-link nil)
 '(mouse-wheel-progressive-speed nil)
 '(network-security-level 'high)
 '(nsm-settings-file "~/.local/state/emacs/network-security.data")
 '(org-adapt-indentation nil)
 '(org-agenda-include-diary t)
 '(org-agenda-persistent-filter t)
 '(org-agenda-search-view-always-boolean t)
 '(org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)
 '(org-agenda-skip-scheduled-if-deadline-is-shown t)
 '(org-agenda-skip-unavailable-files t)
 '(org-agenda-span 'day)
 '(org-agenda-sticky t)
 '(org-agenda-text-search-extra-files '(agenda-archives))
 '(org-agenda-todo-ignore-scheduled 'future)
 '(org-archive-default-command 'org-archive-subtree)
 '(org-attach-commit nil)
 '(org-attach-store-link-p 'attached)
 '(org-attach-use-inheritance t)
 '(org-babel-load-languages '((emacs-lisp . t) (python . t) (shell . t) (dot . t)))
 '(org-capture-templates
   '(("Z" "org-protocol capture" entry
      (file "notes.org")
      "* TODO %?org-protocol capture :capture:\12%(let ((x \"%:annotation\")) (if (string= x \"\") \"\" (concat x \"\\n\")))%(quote \"%i\")")))
 '(org-checkbox-hierarchical-statistics nil)
 '(org-columns-default-format "%60ITEM %TODO %Effort{:} %CLOCKSUM")
 '(org-confirm-babel-evaluate nil)
 '(org-ctags-open-link-functions nil)
 '(org-ctrl-k-protect-subtree 'error)
 '(org-edit-src-content-indentation 0)
 '(org-ellipsis "...")
 '(org-enforce-todo-dependencies t)
 '(org-export-backends '(ascii html md texinfo))
 '(org-export-use-babel nil)
 '(org-export-with-sub-superscripts '{})
 '(org-fast-tag-selection-single-key t)
 '(org-fold-catch-invisible-edits 'smart)
 '(org-format-latex-options
   '(:foreground default :background default :scale 2.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-goto-interface 'outline-path-completion)
 '(org-habit-graph-column 50)
 '(org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
 '(org-id-locations-file "~/.local/state/emacs/org-id-locations")
 '(org-log-done 'time)
 '(org-log-into-drawer t)
 '(org-log-redeadline 'note)
 '(org-log-refile nil)
 '(org-log-reschedule 'time)
 '(org-modules '(org-id ol-info org-protocol))
 '(org-outline-path-complete-in-steps nil)
 '(org-pretty-entities nil)
 '(org-protocol-protocol-alist
   '(("goto-heading" :protocol "goto-heading" :function goto-heading)))
 '(org-publish-timestamp-directory "~/.local/state/emacs/org-timestamps/")
 '(org-refile-allow-creating-parent-nodes 'confirm)
 '(org-refile-targets '((nil :maxlevel . 3) (org-agenda-files :maxlevel . 2)))
 '(org-refile-use-outline-path 'file)
 '(org-special-ctrl-a/e t)
 '(org-special-ctrl-k t)
 '(org-structure-template-alist
   '(("a" . "export ascii")
     ("b" . "src bash")
     ("c" . "center")
     ("C" . "comment")
     ("e" . "example")
     ("E" . "export")
     ("h" . "export html")
     ("l" . "export latex")
     ("p" . "src python")
     ("q" . "quote")
     ("s" . "src")
     ("v" . "verse")))
 '(org-use-speed-commands
   (lambda nil
     (and
      (looking-at org-outline-regexp)
      (looking-back "^**"))))
 '(org-use-sub-superscripts '{})
 '(org-yank-folded-subtrees nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/")
     ("melpa" . "https://melpa.org/packages/")
     ("melpa-stable" . "https://stable.melpa.org/packages/")))
 '(package-check-signature t)
 '(package-install-upgrade-built-in t)
 '(package-pinned-packages
   '((markdown-mode . "nongnu")
     (dash . "gnu")
     (transient . "gnu")
     (yasnippet . "gnu")
     (ws-butler . "nongnu")
     (with-editor . "nongnu")
     (wgrep . "nongnu")
     (vlf . "nongnu")
     (vertico . "gnu")
     (tiny . "gnu")
     (systemd . "nongnu")
     (smartparens . "nongnu")
     (keycast . "nongnu")
     (htmlize . "nongnu")
     (gptel . "nongnu")
     (expand-region . "gnu")
     (dockerfile-mode . "nongnu")
     (diff-hl . "gnu")
     (consult . "gnu")
     (bash-completion . "nongnu")
     (async . "gnu")
     (aggressive-indent . "gnu")
     (orderless . "gnu")
     (marginalia . "gnu")
     (bind-key . "gnu")
     (use-package . "gnu")
     (faceup . "gnu")))
 '(package-quickstart t)
 '(package-selected-packages
   '(gptel-commit vterm aggressive-indent async bash-completion bazel bluetooth consult csv-mode ddskk diff-hl dockerfile-mode dumb-jump easydraw editorconfig eglot emmet-mode erc expand-region flymake flymake-shellcheck ghub git-timemachine gnu-elpa-keyring-update go-mode gptel graphviz-dot-mode helpful htmlize ialign idlwave ipcalc jakuri jq-mode json-mode keycast lua-mode magit marginalia markdown-mode minions obsidian orderless org pinentry project protobuf-mode python rainbow-mode reintegrate seq smartparens string-inflection systemd tiny toml-mode tramp valign vc-jj verb verilog-mode vertico vlf vundo wgrep with-editor ws-butler xterm-color yaml-mode yasnippet))
 '(package-unsigned-archives '("melpa" "melpa-stable"))
 '(project-list-file "~/.local/state/emacs/projects")
 '(project-switch-commands
   '((project-find-file "Find file" nil)
     (project-find-regexp "Find regexp" nil)
     (project-dired "Dired" nil)
     (project-vc-dir "VC-Dir" nil)
     (project-eshell "Eshell" nil)
     (project-shell "Shell" nil)))
 '(project-vc-merge-submodules nil)
 '(python-fill-docstring-style 'pep-257-nn)
 '(recentf-auto-cleanup 'never)
 '(recentf-exclude
   '("/\\(\\(\\(COMMIT\\|NOTES\\|PULLREQ\\|MERGEREQ\\|TAG\\)_EDIT\\|MERGE_\\|\\)MSG\\|\\(BRANCH\\|EDIT\\)_DESCRIPTION\\)\\'" "/\\.cache/emacs/filesets-cache\\.el\\'" "\\`/sudo:" "\\.\\(jpg\\|png\\)\\'" "/ionasal/src/home/"))
 '(recentf-max-saved-items 8000)
 '(recentf-mode t)
 '(recentf-save-file "~/.local/state/emacs/recentf")
 '(register-preview-delay 0.3)
 '(repeat-mode t)
 '(require-final-newline 'ask)
 '(rmail-file-name "~/.local/state/emacs/RMAIL")
 '(safe-local-variable-values
   '((org-num-max-level . 2)
     (make-backup-files)
     (git-commit-major-mode . git-commit-elisp-text-mode)
     (create-lockfiles)
     (bug-reference-bug-regexp . "#\\(?2:[0-9]+\\)")))
 '(save-place-file "~/.local/state/emacs/places")
 '(save-place-mode t)
 '(save-place-skip-check-regexp
   "\\`/\\(?:cdrom\\|floppy\\|mnt\\|net\\|\\(?:[^@/:]*@\\)?[^@/:]*[^@/:.]:\\)")
 '(savehist-file "~/.local/state/emacs/history")
 '(savehist-mode t)
 '(scroll-bar-mode nil)
 '(send-mail-function 'smtpmail-send-it)
 '(set-mark-command-repeat-pop t)
 '(sh-learn-basic-offset 'usually)
 '(shell-file-name "/bin/bash")
 '(shift-select-mode nil)
 '(show-paren-mode t)
 '(shr-color-visible-luminance-min 60)
 '(skk-check-okurigana-on-touroku 'ask)
 '(skk-jisyo-edit-user-accepts-editing t)
 '(skk-jisyo-save-count 1)
 '(skk-save-jisyo-instantly t)
 '(skk-user-directory "~/.local/state/emacs/ddskk")
 '(sp-base-key-bindings 'sp)
 '(sp-highlight-pair-overlay nil)
 '(sp-highlight-wrap-overlay nil)
 '(sp-highlight-wrap-tag-overlay nil)
 '(switch-to-buffer-preserve-window-point nil)
 '(tab-bar-close-button-show nil)
 '(tab-bar-format
   '(tab-bar-format-history tab-bar-format-tabs tab-bar-separator))
 '(tab-bar-new-tab-choice nil)
 '(tab-bar-tab-hints t)
 '(text-scale-mode-step 1.1)
 '(tls-checktrust t)
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(tooltip-resize-echo-area t)
 '(tramp-persistency-file-name "~/.local/state/emacs/tramp")
 '(transient-history-file "~/.local/state/emacs/transient/history.el")
 '(underline-minimum-offset 15)
 '(undo-limit 1600000)
 '(undo-outer-limit 240000000)
 '(undo-strong-limit 2400000)
 '(url-cache-directory "~/.cache/emacs/url")
 '(url-cookie-file "~/.local/state/emacs/url/cookies")
 '(use-dialog-box nil)
 '(user-full-name "Allen Li")
 '(user-mail-address "darkfeline@felesatra.moe")
 '(vertico-mode t)
 '(visible-bell t)
 '(wdired-allow-to-change-permissions t)
 '(wgrep-auto-save-buffer t)
 '(window-combination-limit 'display-buffer)
 '(winner-mode t)
 '(ws-butler-global-exempt-modes nil)
 '(ws-butler-global-mode t)
 '(ws-butler-keep-whitespace-before-point nil)
 '(x-stretch-cursor t)
 '(yas-alias-to-yas/prefix-p nil)
 '(yas-expand-only-for-last-commands '(self-insert-command))
 '(yas-global-mode t)
 '(yas-good-grace nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "gray20" :foreground "white smoke" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "ADBO" :family "Source Code Pro"))))
 '(Info-quoted ((t (:inherit default :foreground "sandy brown"))))
 '(comint-highlight-prompt ((t (:inherit nil))))
 '(diary ((t (:foreground "orange"))))
 '(diff-hl-change ((t (:background "royal blue" :foreground "deep sky blue"))))
 '(dired-async-mode-message ((t (:background "gold4" :foreground "gold1"))))
 '(ediff-even-diff-A ((t (:background "gray12"))))
 '(ediff-even-diff-B ((t (:background "gray12"))))
 '(ediff-even-diff-C ((t (:background "gray12"))))
 '(ediff-odd-diff-A ((t (:background "gray20"))))
 '(ediff-odd-diff-B ((t (:background "gray20"))))
 '(ediff-odd-diff-C ((t (:background "gray20"))))
 '(erc-input-face ((t (:foreground "light coral"))))
 '(erc-my-nick-face ((t (:foreground "light coral" :weight bold))))
 '(hi-black-b ((t (:background "dark goldenrod" :foreground "black"))))
 '(hi-black-hb ((t (:foreground "goldenrod" :weight bold))))
 '(hi-blue-b ((t (:foreground "deep sky blue" :weight bold))))
 '(line-number-current-line ((t (:inherit line-number :background "dark gray" :foreground "black"))))
 '(mode-line ((t (:background "grey60" :foreground "black"))))
 '(org-habit-clear-future-face ((t (:background "dark slate blue"))))
 '(org-headline-done ((t (:foreground "rosy brown" :strike-through t))))
 '(secondary-selection ((t (:background "dark slate gray")))))
