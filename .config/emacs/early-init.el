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

;; Configure options affecting frames so they take effect for the initial frame.
;; These should be set with `custom.el' also for consistency.
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)
(custom-set-faces
 '(default ((t (:inherit nil :extend nil :stipple nil :background "gray20" :foreground "white smoke" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "ADBO" :family "Source Code Pro")))))
