(in-package :cl-cgr)

(defstruct result
  demand
  route
  arrival-time
  routing-time)

(defun bundle-delivered-p (result)
  "Returns T if the demand arrived within the contact window."
  (and (result-route result)
       (result-arrival-time result)))

