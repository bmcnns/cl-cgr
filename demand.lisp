(in-package :cl-cgr)

(defstruct demand
  id
  source ; the node the data starts at
  destination ; the ground station
  t0) ; when the data is ready

(defmacro defdemands (name docstring &rest demands)
  `(defparameter ,name
     (list ,@(loop for demand in demands
		 for i from 0
		 collect `(make-demand :id ,i
				       :t0 (coerce ,(third demand) 'double-float)
				       :source ,(fourth demand)
				       :destination ,(fifth demand))))
     ,docstring))

