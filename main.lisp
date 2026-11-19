(in-package :cl-cgr)

(defparameter *owlt* 0.1d0
  "One-way light time: propagation delay from sender to receiver in seconds.")

(defparameter *time-window* 43200d0
  "Length of each demand's time window (in seconds). Demands with no route inside the
   time window are considered undeliverable.")

(defplan *toy-scenario*
  "3 satellites (2,3,4) and 1 ground station (1) over 60 seconds,
   with 6 bidirectional contact windows."
  (a contact 0.0 5.0 2 4 115200.0)
  (a contact 0.0 5.0 4 2 115200.0)
  (a contact 3.0 8.0 4 3 115200.0)
  (a contact 3.0 8.0 3 4 115200.0)
  (a contact 5.0 15.0 3 1 115200.0)
  (a contact 5.0 15.0 1 3 115200.0)
  (a contact 10.0 20.0 2 3 115200.0)
  (a contact 10.0 20.0 3 2 115200.0)
  (a contact 30.0 40.0 3 1 115200.0)
  (a contact 30.0 40.0 1 3 115200.0)
  (a contact 50.0 60.0 4 1 115200.0)
  (a contact 50.0 60.0 1 4 115200.0))

(defdemands *toy-demands*
  "Six demands, all to the ground station (node 1)."
  (a demand 0.0 2 1)
  (a demand 6.0 2 1)
  (a demand 16.0 2 1)
  (a demand 20.0 2 1)
  (a demand 0.0 3 1)
  (a demand 10.0 4 1))
