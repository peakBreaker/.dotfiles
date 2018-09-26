;;; init.el -- My Emacs configuration
;-*-Emacs-Lisp-*-

;;; Commentary:
;;
;; I have nothing substantial to say here.
;;
;;; Code:

;; Leave this here, or package.el will just add it again.
(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(add-to-list 'exec-path "/usr/local/bin")

; (require 'init-utils)
; (require 'init-elpa)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Settings

;; For larger packages we get configs from their respective files
(require 'init-evil)

;; Org Mode
(add-to-list 'load-path (expand-file-name "periodic-commit-minor-mode" user-emacs-directory))
(require 'init-org)

;; Theme
(load-theme 'dakrone t)

(provide 'init)
