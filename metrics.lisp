(in-package :cl-cgr)

(defun log! (results file-name)
  (ensure-directories-exist file-name)
  (with-open-file (stream file-name
			  :direction :output
			  :if-exists :supersede
			  :if-does-not-exist :create)
    (format stream "source destination creation-time delivery-time routing-time hop-count~%")    
    (loop for result in results
	  for demand = (result-demand result)
	  do (format stream "~A ~A ~A ~,7F ~,7F ~A~%"
		     (demand-source demand)
		     (demand-destination demand)
		     (demand-t0 demand)
		     (- (result-arrival-time result) (demand-t0 demand))
		     (result-routing-time result)
		     (length (result-route result))))))
