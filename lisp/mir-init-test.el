;;; mir-init-test.el --- mir-init tests  -*- lexical-binding: t; -*-

;; Copyright (C) 2017 Allen Li
;; Keywords: local

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; mir-init tests

;;; Code:

(require 'ert)
(require 'mir-init)

(ert-deftest mir-init--mode-hook ()
  (should (eq (mir-init--mode-hook 'foo-mode) 'foo-mode-hook)))

(ert-deftest mir-init-bind-keys ()
  (let ((global-map (make-sparse-keymap)))
    (mir-init-bind-keys global-map
      ([?a] #'forward-char)
      ([?b] nil))
    (should (equal global-map '(keymap
                                (?b)
                                (?a . forward-char))))))

(ert-deftest mir-init-dir-class ()
  (let (dir-locals-class-alist
        dir-locals-directory-cache)
    (mir-init-dir-class some-class
        '((go-mode . ((gofmt-args . ("-local" "mir")))))
      "~/src/mir"
      "/tmp/mir")
    (should (equal dir-locals-class-alist '((some-class . ((go-mode . ((gofmt-args . ("-local" "mir")))))))))
    (should (equal dir-locals-directory-cache `(("/tmp/mir/" some-class nil)
                                                (,(expand-file-name "~/src/mir/") some-class nil))))))

(provide 'mir-init-test)
;;; mir-init-test.el ends here
