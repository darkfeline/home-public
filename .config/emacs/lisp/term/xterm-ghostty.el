;;; xterm-ghostty.el --- ghostty support             -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Allen Li

;; Author: Allen Li <darkfeline@felesatra.moe>
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

;;

;;; Code:

(require 'term/xterm)

(defcustom xterm-ghostty-extra-capabilities
  '(modifyOtherKeys reportBackground getSelection setSelection)
  "Extra capabilities supported under \"xterm-ghostty\"."
  :type xterm--extra-capabilities-type
  :group 'xterm)

(defun terminal-init-xterm-ghostty ()
  "Terminal initialization function for Ghostty."
  (let ((xterm-extra-capabilities xterm-ghostty-extra-capabilities))
    (tty-run-terminal-initialization (selected-frame) "xterm")))

(provide 'term/xterm-ghostty)
;;; xterm-ghostty.el ends here
