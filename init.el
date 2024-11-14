;; -*- lexical-binding: t; -*-

;;; Package/library setup
;; Drop-in library setup
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'mir-init)

(mir-init-bootstrap-package-vc '(easydraw
                                 magit
                                 reintegrate
                                 jakuri))

;; lilypond-mode is packaged with lilypond.
;; `lilypond-init' only sets up autoloads and `auto-mode-alist'.
(when (locate-library "lilypond-init")
  (load "lilypond-init"))

;; Borg setup
(add-to-list 'load-path (expand-file-name "lib/borg" user-emacs-directory))
(require 'borg)
(borg-initialize)

;; Loading customizations needs to happen after loading all autoloads
;; so customizable variables with setters run correctly.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)


;;; Eval after load
(with-eval-after-load 'cc-styles
  ;; Linux uses tabs for indent, but this is omitted from the linux
  ;; style shipped with Emacs.
  (c-add-style "linux" (nconc '((indent-tabs-mode . t))
                              (cdr (assoc "linux" c-style-alist)))))

(with-eval-after-load 'diff-hl
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))

(with-eval-after-load 'dired
  (require 'dired-x)
  (mir-init-bind-keys dired-mode-map
    ([?\C-a] (lambda ()
               (interactive)
               (when (= (point) (dired-move-to-filename))
                 (move-beginning-of-line 1))))))

(with-eval-after-load 'elisp-mode
  (mir-init-bind-keys lisp-interaction-mode-map
    ([?\C-c ?\C-e] #'emacs-lisp-macroexpand)
    ([?\C-c ?\C-q] #'sp-indent-defun))

  (mir-init-bind-keys emacs-lisp-mode-map
    ([?\C-c ?\C-e] #'emacs-lisp-macroexpand)
    ([?\C-c ?\C-q] #'sp-indent-defun)))

(with-eval-after-load 'go-mode
  (mir-init-bind-keys go-mode-map
    ([?\C-c ?i] #'consult-imenu)))

(with-eval-after-load 'grep
  (require 'wgrep))

(with-eval-after-load 'org
  (mir-init-bind-keys org-mode-map
    ([?\C-c ?\M-,] #'org-insert-structure-template)))

(with-eval-after-load 'protobuf-mode
  (mir-init-bind-keys protobuf-mode-map
    ([?=] (lambda () (interactive) (insert "=") (protobuf-next-tag-finish-field)))
    ([?\M-q] #'fill-paragraph)))

(with-eval-after-load 'python
  (mir-init-bind-keys python-mode-map
    ([?\C-c ?i] #'consult-imenu)))

(with-eval-after-load 'shell
  (mir-init-bind-keys shell-mode-map
    ([?\s] #'comint-magic-space)
    ([?\M-r] #'consult-history)))

(with-eval-after-load 'skk
  (remove-hook 'kill-emacs-hook #'skk-save-jisyo)
  (add-hook 'kill-emacs-hook (lambda () (skk-save-jisyo :quiet))))

(with-eval-after-load 'smartparens
  (mir-init-bind-keys smartparens-mode-map
    ([M-backspace] nil)  ; sp-backward-unwrap-sexp
    ([M-delete] nil)     ; sp-unwrap-sexp
    ))

(with-eval-after-load 'vertico
  (mir-init-bind-keys vertico-map
    ([?\M-a] #'marginalia-cycle)))

(with-eval-after-load 'wdired
  (mir-init-bind-keys wdired-mode-map
    ([?\C-a] (lambda ()
               (interactive)
               (when (= (point) (dired-move-to-filename))
                 (move-beginning-of-line 1))))))

(with-eval-after-load 'which-func
  (require 's)
  (setq which-func-cleanup-function (lambda (s) (s-truncate 30 s))))


;;; Advice
(define-advice shell-mode (:around (old))
  "Stop `shell-mode' reusing the buffer from defontifying.
See `https://debbugs.gnu.org/cgi/bugreport.cgi?bug=33092'."
  (if (eq major-mode 'shell-mode)
      (remove-hook 'change-major-mode-hook 'font-lock-defontify t))
  (funcall old))

(define-advice battery-update (:around (old))
  "Hide battery status on workstations."
  (let* ((data (and battery-status-function (funcall battery-status-function)))
         (percentage (car (read-from-string (cdr (assq ?p data))))))
    (if (and battery-mode-line-format
             (not (numberp percentage))
             (string= percentage "N/A"))
        (progn
          (setq battery-mode-line-string "")
          (force-mode-line-update t))
      (funcall old))))

(define-advice protobuf-mode (:after (&rest _args))
  "Shorten mode name."
  (setq mode-name "Proto")
  (c-update-modeline))


;;; Hooks
(mir-init-add-hooks after-save-hook
  #'executable-make-buffer-file-executable-if-script-p)
(mir-init-add-hooks comint-preoutput-filter-functions
  #'xterm-color-filter)

;; Mode hooks
(mir-init-add-hooks go-mode-hook
  #'tree-sitter-hl-mode
  (mir-init-setter adaptive-fill-regexp "[ \t]*\\(//\\)?[ \t]*")
  (lambda ()
    (when (fboundp 'gofmt-before-save)
      (add-hook 'before-save-hook
                #'gofmt-before-save t t))))

(mir-init-add-hooks ibuffer-mode-hook
  (lambda () (ibuffer-switch-to-saved-filter-groups "default")))

(mir-init-add-hooks lisp-interaction-mode-hook
  (mir-init-setter lexical-binding t))

(mir-init-add-hooks python-mode-hook
  (mir-init-setter fill-column 72)
  (mir-init-setter dabbrev-case-fold-search nil))

(mir-init-add-hooks sh-mode-hook
  #'flymake-shellcheck-load)

(mir-init-add-hooks shell-mode-hook
  ;; Preserve properties, otherwise ‘comint-delete-output’ unfontifies
  ;; the prompt.
  (mir-init-setter xterm-color-preserve-properties t)
  #'comint-reaper-mode)

;; Minor mode enabling
(mir-init-enable-for-modes abbrev-mode
  prog-mode
  text-mode)

(mir-init-enable-for-modes auto-fill-mode
  org-mode)

(mir-init-enable-for-modes electric-pair-local-mode
  prog-mode
  text-mode)

;; `flyspell-prog-mode' is an unconventional minor mode.
(mir-init-add-to-modes #'flyspell-prog-mode
  prog-mode)

(mir-init-enable-for-modes subword-mode
  go-mode
  js-mode
  python-mode)


;;; Builtin configuration
(setq disabled-command-function nil)
(add-hook 'kill-emacs-hook
          (lambda () (setq gc-cons-threshold most-positive-fixnum))
          -100)

;; Auto mode
(add-to-list 'auto-mode-alist '("\\.gitmodules\\'" . conf-unix-mode))


;;; Builtin keymap customizations
(mir-init-bind-keys global-map
  ;; Builtin commands
  ([remap list-buffers] #'ibuffer)
  ([?\C-h ?M] #'man)
  ([?\C-c ?P] #'list-processes)
  ([?\C-c ?r] #'rgrep)

  ;; Packages
  ([remap repeat-complex-command] #'consult-complex-command)
  ([remap switch-to-buffer] #'consult-buffer)
  ([remap switch-to-buffer-other-window] #'consult-buffer-other-window)
  ([remap switch-to-buffer-other-frame] #'consult-buffer-other-frame)
  ([remap yank-pop] #'consult-yank-pop)

  ([?\C-c ?=] #'er/expand-region)

  ([remap describe-function] #'helpful-callable)
  ([remap describe-variable] #'helpful-variable)
  ([remap describe-key] #'helpful-key)
  ([remap describe-command] #'helpful-command)

  ([?\C-c ?g] (lambda ()
                (interactive)
                (let ((p (project-current)))
                  (when p (project-remember-project p)))
                (call-interactively #'magit-status)))
  ([?\C-c ?G] #'magit-list-repositories)

  ([?\C-c ?t] #'gptel-send)
  ([?\C-c ?T] #'gptel)

  ([?\C-c ?y] #'tiny-expand)

  ([remap async-shell-command] 'with-editor-async-shell-command)
  ([remap shell-command] 'with-editor-shell-command)

  ;; Personal
  ([?\C-c ?s] #'jakuri-shell)
  ([?\C-c ?o] #'gttap-dwim))

(mir-init-bind-keys minibuffer-local-map
  ([?\C-r] #'consult-history))

(mir-init-bind-keys occur-mode-map
  ([?n] #'occur-next)
  ([?p] #'occur-prev))

(mir-init-bind-keys project-prefix-map
  ([?E] #'eglot)
  ([?S] #'vc-git-grep))

;; Bind keys in windmove-mode-map
(windmove-default-keybindings)


;;; Directory classes
;; Cannot use .dir-locals.el since SSH will try to load it.
(mir-init-dir-class ssh
    '((conf-space-mode . ((version-control . nil))))
  "~/.ssh/config.d/")


;;; Miscellaneous package initialization
(unless noninteractive
  ;; also needed for org-protocol
  (server-start))

(unless (display-graphic-p)
  (xterm-mouse-mode))

(when (locate-library "bazel")
  (add-to-list 'auto-mode-alist '("\\.star\\'" . bazel-starlark-mode)))

(when (locate-library "dumb-jump")
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 90))

(when (locate-library "emmet-mode")
  (mir-init-enable-for-modes emmet-mode
    css-mode
    sgml-mode))

(when (locate-library "gn-mode")
  (dolist (v '(("\\.gn\\'" . gn-mode)
               ("\\.gni\\'" . gn-mode)))
    (add-to-list 'auto-mode-alist v)))

(when (locate-library "org")
  (require 'org-protocol))

(when (locate-library "reintegrate")
  (when (getenv "SSH_TTY")
    (reintegrate)))

(when (locate-library "systemd")
  (add-to-list 'auto-mode-alist '("/systemd/.+.path\\'" . systemd-mode)))

(when (locate-library "vimml")
  (vimml-add-rule "python" #'python-mode))

(when (locate-library "vlf")
  (require 'vlf-setup))

(when (locate-library "with-editor")
  (define-advice shell (:around (old &rest args))
    "Wrap `shell' with `with-editor'."
    (with-editor
      (apply old args))))

;; Load extra init files
(let ((f (expand-file-name "~/share/emacs/init.el")))
  (when (file-exists-p f) (load f)))
