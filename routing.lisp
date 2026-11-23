(in-package :cl-cgr)

(defun deliverable-p (demand plan &key (router #'cgr))
  "Returns T if the DEMAND is deliverable under PLAN
   with the ROUTER method."
  (let ((source (demand-source demand))
	(destination (demand-destination demand))
	(t0 (demand-t0 demand)))
    (multiple-value-bind (route arrival-time)
	(funcall router plan source destination :t0 t0)
      (and route (<= (- arrival-time t0) *time-window*)))))

					; The simple direct routing method is put here.

(defun direct (plan source destination &key (t0 0d0))
  "Returns the next direct path from SOURCE to DESTINATION under the contact plan PLAN."
  (loop for contact across plan
	if (and (< t0 (contact-end contact))
		(equalp (contact-from contact) source)
		(equalp (contact-to contact) destination))
	  do (return-from direct (values (list contact) (hop contact t0)))))


(defun stringify-route (contacts &key (t0 0.0))
  "Prints a human-readable version of a planned route."
  (with-output-to-string (s)
    (when (null contacts)
      (return-from stringify-route "[ no route ]"))
    (format s "~A" (contact-from (first contacts)))
    (loop with ready = t0
	  for contact in contacts
	  for departure = (max ready (contact-start contact))
	  for arrival = (+ departure (contact-owlt contact))
	  do (format s " -[~A]-> ~A" departure (contact-to contact))
	     (setf ready arrival))))

(defun route-demand (plan demand &key (router #'cgr))
  "Routes a DEMAND through contact-graph routing (CGR)."
  (let ((start (get-internal-real-time)))
    (multiple-value-bind (route arrival-time)
	(funcall router plan (demand-source demand) (demand-destination demand) :t0 (demand-t0 demand))
      (let* ((elapsed (- (get-internal-real-time) start))
	     (routing-time (float (/ elapsed internal-time-units-per-second) 1d0)))
	(make-result :demand demand :route route :arrival-time arrival-time :routing-time routing-time)))))

(defun route (plan demands &key (router #'cgr))
  "Route each demand in DEMANDS over a contact plan PLAN.
   Returns a list of results, one per demand, in the same order."
  (mapcar (lambda (demand) (route-demand plan demand :router router)) demands))
