(in-package :cl-cgr)

(defun parse-contact/parse-range (line)
  "Parse either a contact or a range."
  (let ((form (uiop:split-string line)))
    (append (list (first form) (second form))
	    (mapcar #'read-from-string (cddr form)))))

(defun load-contact-plan (file-name)
  "Loads an ION-format contact plan from the file-system."
  (with-open-file (stream file-name
			  :direction :input
			  :if-does-not-exist :error)
    (labels ((read-contact-plan ()
	       (loop for line = (read-line stream nil)
		     while line
		     for form = (parse-contact/parse-range line)
		     if (string= (second form) "contact")
		       collect form into contacts
		     else if (string= (second form) "range")
			    collect form into ranges
		     finally (return (values contacts ranges))))
	     (generate-ranges (ranges)
	       (let ((range-table (make-hash-table :test #'equal)))
		 (loop for (a range start end from to owlt) in ranges
			do (setf (gethash (list start end from to) range-table) owlt))
		 range-table))
	     (generate-contacts (contacts range-table)
	       (coerce (loop for (a contact start end from to rate) in contacts
			     for id from 0
 			     collect (make-contact :id id
						   :start (truncate start)
						   :end (truncate end)
						   :from from
						   :to to
						   :rate rate
						   :owlt (gethash (list start end from to) range-table))) 'vector)))
      (multiple-value-bind (contacts ranges)
	  (read-contact-plan)
	(let ((range-table (generate-ranges ranges)))
	  (generate-contacts contacts range-table))))))
      
