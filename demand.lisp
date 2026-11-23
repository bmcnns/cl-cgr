(in-package :cl-cgr)

(defstruct demand
  source ; the node the data starts at
  destination ; the ground station
  t0) ; when the data is ready

(defmacro defdemands (name docstring &rest demands)
  `(defparameter ,name
     (list ,@(loop for demand in demands
		 for i from 0
		 collect `(make-demand :t0 (coerce ,(third demand) 'double-float)
				       :source ,(fourth demand)
				       :destination ,(fifth demand))))
     ,docstring))

(defun generate-demand (contact-plan &key (seed *random-state*))
  (make-demand :source (random-elt (satellites contact-plan))
	       :destination 1
	       :t0  (random (- (floor ( plan-end contact-plan)) *time-window*) seed)))
