(add-hook 'python-mode-hook
          (lambda () (when (boundp 'yas-indent-line)
                       (setq-local yas-indent-line 'fixed))))

;; Local Variables:
;; no-byte-compile: t
;; End:
