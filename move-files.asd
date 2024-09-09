;;;; move-files.asd

(asdf:defsystem #:move-files
  :description "Describe move-files here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version #.(with-open-file
                 (vers (merge-pathnames "system-version.expr" *load-truename*))
               (read vers))
  :serial t
  :depends-on (#:xlog)
  :components ((:file "move-files-pkg")
               (:file "move-files")))
