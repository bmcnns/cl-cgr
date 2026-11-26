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

(defun generate-demand (scenario)
  (let ((contact-plan (scenario-contact-plan scenario))
	(sources (scenario-sources scenario))
	(destinations (scenario-destinations scenario))
	(time-window (scenario-time-window scenario)))
    (make-demand :source (random-elt sources)
		 :destination (random-elt destinations)
		 :t0 (random (- (floor (plan-end contact-plan)) time-window)))))

