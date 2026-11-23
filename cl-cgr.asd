(defsystem "cl-cgr"
  :description "Contact graph routing in Common Lisp."
  :author "Bryce MacInnis"
  :serial t
  :components ((:file "package")
	       (:file "utils")
	       (:file "contact")
	       (:file "demand")
	       (:file "cgr")
	       (:file "routing")
	       (:file "file-system")
	       (:file "main")))
