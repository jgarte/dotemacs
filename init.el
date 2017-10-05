;;; init --- my init file
;;; Commentary:
;;; Just another Emacs hacker,
;;; Code:

;; ## Remove visual clutter
;; Put this first so it definitely gets eval'd
(scroll-bar-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)

;; ## Set up package lists & use-package
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (add-to-list 'load-path "~/.emacs.d/chameleon"))

(require 'chameleon-variables)

;; ## Local setup
(my/load-file-if-exists "~/.emacs.d/chameleon-local.el")

;; ## My prefix - bound to <f5> by default
(global-set-key (kbd "<f5>")
                'chameleon-prefix-map)

(require 'chameleon-packages)
(require 'chameleon-prog)

;; ## Major mode hooks
(add-hook 'org-mode-hook
          (lambda ()
            (org-bullets-mode 1)))
(add-hook 'prog-mode-hook #'smartparens-mode)

;; ## Minor Modes
(require 'paren)
(setq show-paren-delay 0)
(show-paren-mode 1)

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)

(global-whitespace-cleanup-mode)
(diminish 'whitespace-cleanup-mode)

(global-diff-hl-mode 1)
(global-page-break-lines-mode 1)
(global-undo-tree-mode 1)
(column-number-mode t)
(which-key-mode)

;; ## Misc. Customization
(require 'chameleon-keys)
(require 'chameleon-rice)

;; Recfile mode - plaintext databases (https://www.gnu.org/software/recutils)
(require 'rec-mode)
(add-to-list 'auto-mode-alist
             '("\\.rec\\'" . rec-mode))

;; Color themes; switch between light and dark theme easily
(setq inhibit-x-resources t) ;; Never load settings from .Xresources

(unless my/local-theme
  (load-file "~/.emacs.d/chameleon/xemacs-chameleon-theme.el")
  (use-package doom-themes
    :config (setq doom-vibrant-brighter-comments t)(setq doom-vibrant-brighter-modeline t)(setq doom-vibrant-comment-bg t))
  (defvar chameleon/themes '(doom-vibrant xemacs-chameleon)
    "Themes to rotate through.")
  (defun chameleon/rotate-themes ()
    "Switch to the next theme in chameleon/themes."
    (interactive)
    (eval-and-compile (require 'dash))
    (mapc (lambda (theme)
            (when (member theme chameleon/themes)
              (disable-theme theme)))
          custom-enabled-themes)
    (smart-mode-line-enable)
    (load-theme (car chameleon/themes)
                t)
    (setq chameleon/themes (-rotate (- (length chameleon/themes)
                                       1)
                                    chameleon/themes))
    (redraw-display))
  (global-set-key (kbd "C-c C-t")
                  'chameleon/rotate-themes)
  (define-key chameleon-prefix-map (kbd "t") 'chameleon/rotate-themes))

;; http://pages.sachachua.com/.emacs.d/Sacha.html
;; Save lots of history
(require 'savehist)
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

;; Enabled commands
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; ## Custom-set
(setq custom-file "~/.emacs.d/chameleon/chameleon-custom.el")
(my/load-file-if-exists "~/.emacs.d/chameleon/chameleon-custom.el") ;; Boot this to another file.
(if my/local-theme
    (enable-theme my/local-theme)
  (enable-theme 'xemacs-chameleon))
(use-package smart-mode-line) ;; Make the modeline suck less; this needs to come after customise
(setq sml/theme 'respectful)
(setq sml/no-confirm-load-theme t)
(sml/setup)
(load-file "~/.emacs.d/chameleon/chameleon-net.el") ;; uses a customized variable

(provide 'init)
;;; init.el ends here
