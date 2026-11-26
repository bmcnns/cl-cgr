(in-package :cl-cgr)

(defun log! (results file-name)
  "Record metrics per demand such as arrival time, routing time and the number of hops
   to the file-system."
  (ensure-directories-exist file-name)
  (with-open-file (stream file-name
			  :direction :output
			  :if-exists :supersede
			  :if-does-not-exist :create)
    (format stream "source destination creation-time delivery-time routing-time hop-count~%")    
    (loop for result in results
	  for demand = (result-demand result)
	  for source = (demand-source demand)
	  for destination = (demand-destination demand)
	  for creation-time = (demand-t0 demand)for delivered = (bundle-delivered-p result)
	  for delivery-time = (if delivered (- (result-arrival-time result) creation-time) "NaN")
	  for routing-time = (result-routing-time result)
	  for hop-count = (if delivered (length (result-route result)) "NaN")
	  do (format stream "~A ~A ~,7F ~,7F ~,7F ~A~%"
		     source destination creation-time delivery-time
		     routing-time hop-count))))
