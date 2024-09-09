;;;; move-files.lisp

(in-package #:move-files)

(declaim (optimize (speed 0) (safety 3) (debug 3) (space 0)))

(defun calc-collision-free-file-name (fxx)
  "fx is new file name. fx needs to be a string"
  (let* ((fx (merge-pathnames fxx))
		 (fx-type (pathname-type fx))
		 (fx-name (pathname-name fx))
		 (fx-dir (directory-namestring fx))
		 (*print-pretty* nil)
		 (newfn-agn (merge-pathnames fx))
		 (exist (probe-file fx)))
	(debugc 5 (xlogntf "ccffn:-> calc-collision-free-file-name~%    ~s" fx))
	(do ((count 1 (incf count)))
		((not exist))
	  (handler-case
		  (progn
			(debugc 5 (xlogntf "ccffn: exist ~s count ~a" exist count))
 			(setf newfn-agn (make-pathname :directory fx-dir :name (format nil "~a_~a" fx-name count) :type fx-type ))
			(setf exist (probe-file newfn-agn))
			(debugc 5 (xlogntf "ccffn:  newfn-agn->~s~%                  exist is ~a" newfn-agn exist))
			)
		(error (e)
		  (break "ccffn botch: ~s with count ~s" e count))))
	(debugc 5 (xlogntf "ccffn: <- return newfn-agn ~s ~%                  fixed ~s" newfn-agn (file-namestring newfn-agn)))
	(file-namestring newfn-agn)
	newfn-agn))

(defun move-file-to-destination (ixx newfn) ;;  TODO put in handler case
  "answer 1 for error, 0 otherwise"
  (let ((oldfn (probe-file ixx))
		(*print-pretty* nil))
	(debugc 5 (xlogntf "mftd: move-file-to-destination ~%     ixx ~s~%   newfn ~s" ixx newfn))
	(cond (oldfn
		   (let* ((newdn (directory-namestring newfn)))
			 (multiple-value-bind (newps createdp)
				 (ensure-directories-exist newdn :verbose t)
			   (xlogntf "mftd: ensure says ~s and ~a" newps createdp))
			 (let ((new-cf-fn (calc-collision-free-file-name newfn))) ;; this gives just the file namestring
			   (debugc 5 (xlogntf "mftd: supposably renaming~%    oldfn ~s~%    newfn ~s" oldfn new-cf-fn))
			   (multiple-value-bind (new-name old-truename truename-new-name)
				   (rename-file oldfn new-cf-fn)
				 (xlogntf "mtfd: rf says ~% new ~a ~% old ~a ~% tru ~a" new-name old-truename truename-new-name))))
		   0)
		  (t (xlogntf "mtfd: file to be moved ~s does not exist!!" ixx)
			 1))))

(defun move-file-to-delete (ixx delete-folder)
  "The delete-folder must be a subdirectory of the folder containing iix. Answer 1 if error, zero othewise"
  (let* ((oldfn (probe-file ixx))
		 (newdir-list (append (pathname-directory ixx)  (list delete-folder)))
		 (*print-pretty* nil))
	(debugc 5 (xlogntf "mtfdel: move-file-to-delete; entry~%     ~s ~%     ~s" ixx delete-folder))
	(cond (oldfn
		   (let* ((newfn (make-pathname :directory newdir-list :name (pathname-name ixx) :type (pathname-type ixx))))
			 (debugc 5 (xlogntf "mftdel: newfn ~s" newfn))
			 (move-file-to-destination oldfn newfn)))
		  (t (xlogntf "mftdel: no source file as ~s" ixx)
			 1))))
