(in-package :cl-cgr)

(defstruct contact
  id
  from
  to
  start
  end
  rate
  (owlt 0.1d0))

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

(defun satellites (contact-plan)
  "All satellite IDs in the contact plan."
  (remove-duplicates
   (loop for contact across contact-plan
	 collect (contact-from contact)
	 collect (contact-to contact))))

(defun plan-end (contact-plan)
  "The time when the last contact ends."
  (reduce #'max contact-plan :key #'contact-end))
