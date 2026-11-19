(defsystem "cl-cgr"
  :description "Contact graph routing in Common Lisp."
  :author "Bryce MacInnis"
  :serial t
  :components ((:file "package")
	       (:file "main")
	       (:file "contact")
	       (:file "demand")
	       (:file "cgr")))
