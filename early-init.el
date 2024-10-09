;; -*- lexical-binding: t; -*-

;; This file is for things that need to be done before the GUI starts.

;; Disable GC during init.
(add-hook 'after-init-hook
          `(lambda () (setq gc-cons-threshold ,gc-cons-threshold))
          100)
(setq gc-cons-threshold most-positive-fixnum)

;; Set ‘load-prefer-newer’ so we don’t load stale bytecode.
;; We have to set this before we start loading anything that could
;; have stale bytecode (i.e., not shipped by Emacs or the system).
(setq load-prefer-newer t)

;; Silence native comp warnings.
;; Native comp happens when loading bytecode automatically and
;; asynchronously by default, so we need to set this before loading
;; any files.
(setq native-comp-async-report-warnings-errors 'silent)

;; Allow overriding package directory.
(let ((dir (expand-file-name "~/src/home-emacs-elpa")))
  (when (file-directory-p dir)
    (setq package-user-dir dir)))

;; Load extra init files
(let ((f (expand-file-name "~/share/emacs/early-init.el")))
  (when (file-exists-p f) (load f)))
