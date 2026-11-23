(in-package :cl-cgr)

(defun random-elt (sequence)
  "Randomly choosen an element ELT from a SEQUENCE."
  (elt sequence (random (length sequence))))

(defun mean (sequence)
  "Mean average of a sequence."
  (/ (reduce #'+ sequence) (length sequence)))

(defun std (sequence)
  "Sample-based standard deviation."
  (let ((mean (mean sequence)))
    (sqrt (/ (reduce #'+ (mapcar (lambda (x) (expt (- x mean) 2)) sequence))
	     (1- (length sequence))))))
   
