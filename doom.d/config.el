;; (setq browse-url-browser-function 'eww-browse-url)

;; https://stackoverflow.com/questions/9547912/emacs-calendar-show-more-than-3-months
(defun ja/year-calendar (&optional year)
  (interactive)
  (require 'calendar)
  (let* (
      (current-year (number-to-string (nth 5 (decode-time (current-time)))))
      (month 0)
      (year (if year year (string-to-number (format-time-string "%Y" (current-time))))))
    (switch-to-buffer (get-buffer-create calendar-buffer))
    (when (not (eq major-mode 'calendar-mode))
      (calendar-mode))
    (setq displayed-month month)
    (setq displayed-year year)
    (setq buffer-read-only nil)
    (erase-buffer)
    ;; horizontal rows
    (dotimes (j 4)
      ;; vertical columns
      (dotimes (i 3)
        (calendar-generate-month
          (setq month (+ month 1))
          year
          ;; indentation / spacing between months
          (+ 5 (* 25 i))))
      (goto-char (point-max))
      (insert (make-string (- 10 (count-lines (point-min) (point-max))) ?\n))
      (widen)
      (goto-char (point-max))
      (narrow-to-region (point-max) (point-max)))
    (widen)
    (goto-char (point-min))
    (setq buffer-read-only t)))

(defun ja/scroll-year-calendar-forward (&optional arg event)
  "Scroll the yearly calendar by year in a forward direction."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     last-nonmenu-event))
  (unless arg (setq arg 0))
  (save-selected-window
    (if (setq event (event-start event)) (select-window (posn-window event)))
    (unless (zerop arg)
      (let* (
              (year (+ displayed-year arg)))
        (ja/year-calendar year)))
    (goto-char (point-min))
    (run-hooks 'calendar-move-hook)))

(defun ja/scroll-year-calendar-backward (&optional arg event)
  "Scroll the yearly calendar by year in a backward direction."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     last-nonmenu-event))
  (ja/scroll-year-calendar-forward (- (or arg 1)) event))

(map! :leader
      :desc "Scroll year calendar backward" "<left>" #'ja/scroll-year-calendar-backward
      :desc "Scroll year calendar forward" "<right>" #'ja/scroll-year-calendar-forward)

(defalias 'year-calendar 'ja/year-calendar)

(use-package! calfw)
(use-package! calfw-org)

(use-package dashboard
  :init      ;; tweak dashboard config before loading it
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
(setq doom-fallback-buffer "*dashboard*")
  (setq dashboard-banner-logo-title "\nKEYBINDINGS:\
\nFind file               (SPC .)     \
Open buffer list    (SPC b i)\
\nFind recent files       (SPC f r)   \
Open the eshell     (SPC e s)\
\nOpen dired file manager (SPC d d)   \
List of keybindings (SPC h b b)")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "~/.doom.d/gura.png")  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 5)
                          (projects . 5)
                          ))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book"))))

(require 'elfeed-goodies)
(elfeed-goodies/setup)
(setq elfeed-goodies/entry-pane-size 0.5)
(add-hook 'elfeed-show-mode-hook 'visual-line-mode)
(setq elfeed-feeds (quote
                    (("https://postep.org.pl/feed" based)
                     ("https://hyperreal.info/rss.xml" based)
                     ("http://feeds.soundcloud.com/users/soundcloud:users:284471201/sounds.rss" based)
                     ("http://strajk.eu/feed/" based)
                     ("http://goodereader.com/blog/feed/" ereader)
                     ("http://feeds.the-ebook-reader.com/feedburner/cmWU" ereader)
                     ("https://swiatczytnikow.pl/" ereader)
                     ("https://climateandeconomy.com/feed/" news)
                     ("http://codziennikfeministyczny.pl/feed/" news)
                     ("http://queer.pl/rss/" news)
                     ("http://feeds.feedburner.com/niebezpiecznik/" security)
                     ("https://feeds.feedburner.com/TheHackersNews" security)
                     ("http://feeds.feedburner.com/Torrentfreak" security)
                     ("https://zaufanatrzeciastrona.pl/feed/" security)
                     ("https://www.androidpolice.com/feed/" tech)
                     ("https://opensource.com/rss.xml" tech)
                     ("http://www.antipsychiatry.org/" psychiatry)
                     ("https://antipsychiatry.net/" psychiatry)
                     ("https://distrowatch.com/news/dw.xml" linux)
                     ("https://feeds.feedburner.com/ItsFoss" linux)
                     ("https://www.linuxjournal.com/" linux)
                     ("https://www.g-central.com/feed/" watch))))

(emms-all)
(emms-default-players)
(emms-mode-line 1)
(emms-playing-time 1)
(setq emms-source-file-default-directory "~/Muzyka/"
      emms-playlist-buffer-name "*Muzyka*"
      emms-info-asynchronously t
      emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)
(map! :leader
      (:prefix ("a" . "EMMS audio player")
       :desc "Go to emms playlist" "a" #'emms-playlist-mode-go
       :desc "Emms pause track" "x" #'emms-pause
       :desc "Emms stop track" "s" #'emms-stop
       :desc "Emms play previous track" "p" #'emms-previous
       :desc "Emms play next track" "n" #'emms-next))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

;(require 'exwm)
;(require 'exwm-config)
;(exwm-config-default)
;(require 'exwm-randr)
;(setq exwm-randr-workspace-output-plist '(0 "HDMI-0"))
;(add-hook 'exwm-randr-screen-change-hook
;          (lambda ()
;            (start-process-shell-command
;             "xrandr" nil "xrandr --output HDMI-0 00mode 1920x1080 --pos 0x0 --rotate normal ")))
;(exwm-randr-enable)
;; (require 'exwm-systemtray)
;; (exwm-systemtray-enable)

;; (server-start)
;(defvar efs/polybar-process nil
;  "Holds the process of the running Polybar instance, if any")
;(defun efs/kill-panel ()
;  (interactive)
;  (when efs/polybar-process
;    (ignore-errors
;      (kill-process efs/polybar-process)))
;  (setq efs/polybar-process nil))
;(defun efs/start-panel ()
;  (interactive)
;  (efs/kill-panel)
;  (setq efs/polybar-process (start-process-shell-command "polybar" nil "polybar panel")))
;(defun efs/send-polybar-hook (module-name hook-index)
;  (start-process-shell-command "polybar-msg" nil (format "polybar-msg hook %s %s" module-name hook-index)))
;(defun efs/send-polybar-exwm-workspace ()
;  (efs/send-polybar-hook "exwm-workspace" 1))
;;; Update panel indicator when workspace changes
;(add-hook 'exwm-workspace-switch-hook #'efs/send-polybar-exwm-workspace)

(setq doom-font (font-spec :family "mononoki Nerd Font" :size 12)
      doom-variable-pitch-font (font-spec :family "Cantarell" :size 12)
      doom-big-font (font-spec :family "mononoki Nerd Font" :size 20))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))
;; (def-package! highlight-indent-guides
  ;; :commands highlight-indent-guides-mode
  ;; :hook (prog-mode . highlight-indent-guides-mode)
  ;; :config
  ;; (setq highlight-indent-guides-method 'character
        ;; highlight-indent-guides-character ?/->
        ;; highlight-indent-guides-delay 0.01
        ;; highlight-indent-guides-responsive 'top
        ;; highlight-indent-guides-auto-enabled nil
        ;; ))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))
(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package magit
  :ensure t)

(defun toggle-maximize-buffer () "Maximize buffer"
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_)
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))
;; Bind it to a key.
(global-set-key [(super shift return)] 'toggle-maximize-buffer)

(require 'org-mime)
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e/")
(require 'mu4e)
(setq mu4e-maildir (expand-file-name "~/Maildir"))
; get mail
(setq mu4e-get-mail-command "mbsync -c ~/.emacs.d/mu4e/.mbsyncrc -a"
  ;; mu4e-html2text-command "w3m -T text/html" ;;using the default mu4e-shr2text
  mu4e-view-prefer-html t
  mu4e-update-interval 180
  mu4e-headers-auto-update t
  mu4e-compose-signature-auto-include nil
  mu4e-compose-format-flowed t)
;; to view selected message in the browser, no signin, just html mail
(add-to-list 'mu4e-view-actions
  '("ViewInBrowser" . mu4e-action-view-in-browser) t)
;; enable inline images
(setq mu4e-view-show-images t)
;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))
;; every new email composition gets its own frame!
(setq mu4e-compose-in-new-frame t)
;; don't save message to Sent Messages, IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)
(add-hook 'mu4e-view-mode-hook #'visual-line-mode)
;; <tab> to navigate to links, <RET> to open them in browser
(add-hook 'mu4e-view-mode-hook
  (lambda()
;; try to emulate some of the eww key-bindings
(local-set-key (kbd "<RET>") 'mu4e~view-browse-url-from-binding)
(local-set-key (kbd "<tab>") 'shr-next-link)
(local-set-key (kbd "<backtab>") 'shr-previous-link)))
;; from https://www.reddit.com/r/emacs/comments/bfsck6/mu4e_for_dummies/elgoumx
(add-hook 'mu4e-headers-mode-hook
      (defun my/mu4e-change-headers ()
        (interactive)
        (setq mu4e-headers-fields
              `((:human-date . 25) ;; alternatively, use :date
                (:flags . 6)
                (:from . 22)
                (:thread-subject . ,(- (window-body-width) 70)) ;; alternatively, use :subject
                (:size . 7)))))
;; if you use date instead of human-date in the above, use this setting
;; give me ISO(ish) format date-time stamps in the header list
;(setq mu4e-headers-date-format "%Y-%m-%d %H:%M")
;; spell check
(add-hook 'mu4e-compose-mode-hook
    (defun my-do-compose-stuff ()
       "My settings for message composition."
       (visual-line-mode)
       (org-mu4e-compose-org-mode)
           (use-hard-newlines -1)
       (flyspell-mode)))
(require 'smtpmail)
;;rename files when moving
;;NEEDED FOR MBSYNC
(setq mu4e-change-filenames-when-moving t)
;;set up queue for offline email
;;use mu mkdir  ~/Maildir/acc/queue to set up first
(setq smtpmail-queue-mail nil)  ;; start in normal mode
;;from the info manual
(setq mu4e-attachment-dir  "~/Downloads")
(setq message-kill-buffer-on-exit t)
(setq mu4e-compose-dont-reply-to-self t)
(require 'org-mu4e)
;; convert org mode to HTML automatically
(setq org-mu4e-convert-to-html t)
;;from vxlabs config
;; show full addresses in view message (instead of just names)
;; toggle per name with M-RET
(setq mu4e-view-show-addresses 't)
;; don't ask when quitting
(setq mu4e-confirm-quit nil)
;; mu4e-context
(setq mu4e-context-policy 'pick-first)
(setq mu4e-compose-context-policy 'always-ask)
(setq mu4e-contexts
  (list
   (make-mu4e-context
    :name "work" ;;for acc1-gmail
    :enter-func (lambda () (mu4e-message "Entering context work"))
    :leave-func (lambda () (mu4e-message "Leaving context work"))
    :match-func (lambda (msg)
                  (when msg
                (mu4e-message-contact-field-matches
                 msg '(:from :to :cc :bcc) "k.derwich96@gmail.com")))
    :vars '((user-mail-address . "k.derwich96@gmail.com")
            (user-full-name . "User Account1")
            (mu4e-sent-folder . "/acc1-gmail/[acc1].Sent Mail")
            (mu4e-drafts-folder . "/acc1-gmail/[acc1].drafts")
            (mu4e-trash-folder . "/acc1-gmail/[acc1].Bin")
            (mu4e-compose-signature . (concat "Formal Signature\n" "Emacs 25, org-mode 9, mu4e 1.0\n"))
            (mu4e-compose-format-flowed . t)
            (smtpmail-queue-dir . "~/Maildir/acc1-gmail/queue/cur")
            (message-send-mail-function . smtpmail-send-it)
            (smtpmail-smtp-user . "acc1")
            (smtpmail-starttls-credentials . (("smtp.gmail.com" 587 nil nil)))
            (smtpmail-auth-credentials . (expand-file-name "~/.authinfo.gpg"))
            (smtpmail-default-smtp-server . "smtp.gmail.com")
            (smtpmail-smtp-server . "smtp.gmail.com")
            (smtpmail-smtp-service . 587)
            (smtpmail-debug-info . t)
            (smtpmail-debug-verbose . t)
            (mu4e-maildir-shortcuts . ( ("/acc1-gmail/INBOX"            . ?i)
                                        ("/acc1-gmail/[acc1].Sent Mail" . ?s)
                                        ("/acc1-gmail/[acc1].Bin"       . ?t)
                                        ("/acc1-gmail/[acc1].All Mail"  . ?a)
                                        ("/acc1-gmail/[acc1].Starred"   . ?r)
                                        ("/acc1-gmail/[acc1].drafts"    . ?d)
                                        ))))))

(setq org-directory "~/Dokumenty/org/org-agenda")

(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
   "/DONE" 'tree))

(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

 (use-package org
   :ensure org-plus-contrib)
 (use-package org-notify
   :ensure nil
   :after org
   :config
   (org-notify-start))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Dokumenty/org/org-roam")
  (setq org-roam-dailies-directory "~/Dokumenty/org/org-roam/daily")
 (custom-set-faces
   '((org-roam-link org-roam-link-current)
     :foreground "#e24888" :underline t))
  (org-roam-completion-everywhere t)
  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* %<%I:%M %p>: %?"
       :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  (org-roam-capture-templates
  '(("d" "default" plain
     "%?"
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
     :unnarrowed t))
    ("b" "book notes" plain (file "~/Dokumenty/org/org-roam/templates/BookNoteTemplate.org")
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
     :unnarrowed t)
    ("p" "project" plain "~/Dokumenty/org/org-roam/templates/ProjectTemplate.org"
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
     :unnarrowed t))
   :bind (("C-c n l" . org-roam-buffer-toggle)
          ("C-c n f" . org-roam-node-find)
          ("C-c n i" . org-roam-node-insert)
          :map org-mode-map
          ("C-M-i" . completion-at-point)
          :map org-roam-dailies-map
          ("Y" . org-roam-dailies-capture-yesterday)
          ("T" . org-roam-dailies-capture-tomorrow))
   :bind-keymap
   ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode)
  (org-roam-setup))

(use-package org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-groups '((:name "Today"
                                   :time-grid t
                                  :scheduled today)
                           (:name "Due today"
                                  :deadline today)
                           (:name "Important"
                                  :priority "A")
                           (:name "Overdue"
                                  :deadline past)
                           (:name "Due soon"
                                  :deadline future)
                           (:name "Big Outcomes"
                                   :tag "bo"))))

(add-hook 'org-mode-hook 'pandoc-mode)

(setq shell-file-name "/bin/fish")

(setq doom-theme 'doom-catppuccin)
(setq fancy-splash-image "~/.doom.d/gura.png")

(setq frame-resize-pixelwise t)
(setq display-line-numbers-type t)
