(defsystem "cl-cgr"
  :description "Contact graph routing in Common Lisp."
  :author "Bryce MacInnis"
  :serial t
  :components ((:file "package")
	       (:file "utils")
	       (:file "contact")
	       (:file "scenario")
	       (:file "demand")
	       (:file "result")
	       (:file "cgr")
	       (:file "routing")
	       (:file "file-system")
	       (:file "main")))
