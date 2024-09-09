;;;; package.lisp

(defpackage #:move-files
  (:use #:cl #:xlog)
  (:export :calc-collision-free-file-name
		   :move-file-to-delete
		   :move-file-to-destination))

