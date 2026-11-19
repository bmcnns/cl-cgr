(in-package :cl-cgr)

(defstruct contact
  id
  from
  to
  start
  end
  rate)

(defmacro defplan (name docstring &rest contacts)
  "Define a contact plan in ION format."
  `(defparameter ,name
     (vector ,@(loop for contact in contacts
		     for i from 0
		     collect `(make-contact :id ,i
					    :start (coerce ,(third contact) 'double-float)
					    :end (coerce ,(fourth contact) 'double-float)
					    :from ,(fifth contact)
					    :to ,(sixth contact)
					    :rate (coerce ,(seventh contact) 'double-float))))
     ,docstring))
