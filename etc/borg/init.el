;; -*- lexical-binding: t; -*-

;; So Borg compilation never uses stale compiled dependencies.
;; Note that `borg.el' is loaded before this file (`borg.el' is responsible for
;; loading this file).
;; We set `load-prefer-newer' in EMACS_EXTRA also to fix this.
(setq load-prefer-newer t)
