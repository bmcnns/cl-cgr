(in-package :cl-cgr)

(defstruct result
  demand
  route
  arrival-time
  routing-time)

(defparameter *time-window* 43200d0
  "Length of each demand's time window (in seconds). Demands with no route inside the
   time window are considered undeliverable.")

(defparameter *leo-a*
  (load-contact-plan "data/eval/leo-a")
  "LEO A is a small constellation of 12 satellites in two orbital planes,
   relaying data down to a single ground station in Argentina over four days.")

(defparameter *demands*
  (loop for demand = (generate-demand *leo-a*)
        if (deliverable-p demand *leo-a* :router #'cgr)
          collect demand into demands
          and count t into kept
        until (= kept 5000)
        finally (return demands)))

(log! (route *leo-a* *demands* :router #'cgr) "~/Research/cl-cgr/leo-a-cgr")
(log! (route *leo-a* *demands* :router #'direct) "~/Research/cl-cgr/leo-a-direct")
