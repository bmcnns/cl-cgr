(in-package :cl-cgr)

(defun make-adjacency-list (plan)
  (let ((adjacency-list (make-hash-table)))
    (loop for contact across plan
	  for from = (contact-from contact)
	  do (push contact (gethash from adjacency-list)))
    adjacency-list))

(defun hop (contact time)
  "Returns the time (in seconds) when the bundle will reach the CONTACT's next node
   if the bundle is received at TIME. Returns NIL if CONTACT closes before
   the bundle can depart."
  (let ((departure-time (max time (contact-start contact))))
    (when (< departure-time (contact-end contact))
	(+ departure-time (contact-owlt contact)))))

(defun cgr (plan source destination &key (t0 0d0))
  "Returns the path from SOURCE to DESTINATION with the earliest arrival
   under the contact plan PLAN."
  (let ((arrival-times (make-array (length plan) :initial-element most-positive-double-float))
	(predecessors (make-array (length plan) :initial-element nil))
	(visited (make-array (length plan) :initial-element nil))
	(adj (make-adjacency-list plan)))
    (labels ((relax (node time pred)
	       "Check alternative routes from NODE->CONTACTS.
                If the hop arrives faster, update ARRIVAL-TIMES,
                PREDECESSORS with the faster route."
	       (loop for contact in (gethash node adj)
		     for id = (contact-id contact)
		     for alt = (hop contact time)
		     when (and (not (aref visited id))
			       alt
			       (< alt (aref arrival-times id)))
		       do
			  (setf (aref arrival-times id) alt)
			  (setf (aref predecessors id) pred)))
	     (next-contact ()
	       "Returns the ID of the contact with the smallest arrival time
                or NIL if all contacts have passed."
	       (loop with best = nil
		     with best-time = most-positive-double-float
		     for contact across plan
		     for id from 0
		     when (and (not (aref visited id))
			       (< (aref arrival-times id) best-time))
		       do (setf best id
				best-time (aref arrival-times id))
		     finally (return best)))
	     (reconstruct-path (id)
	       (loop with path = nil
		     while id
		     do (progn
			  (push (aref plan id) path)
			  (setf id (aref predecessors id)))
		     finally (return path))))
      (relax source t0 nil)
      (loop for id = (next-contact)
	    do (if id
		   (progn (setf (aref visited id) t)
			  (if (equalp (contact-to (aref plan id)) destination)
			      (return-from cgr (values (reconstruct-path id) (aref arrival-times id)))
			      (relax (contact-to (aref plan id)) (aref arrival-times id) id)))
		   (return-from cgr nil))))))
		   
