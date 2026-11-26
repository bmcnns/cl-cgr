(in-package :cl-cgr)

(defstruct scenario
  name
  contact-plan
  sources
  destinations
  time-window)

(defmacro defscenario (name docstring &key contact-plan sources destinations time-window)
  `(defparameter ,name
     (make-scenario
      :name ,(string-downcase (string-trim "*" (symbol-name name)))
      :contact-plan (load-contact-plan ,contact-plan)
      :sources ',sources
      :destinations ',destinations
      :time-window ,time-window)
     ,docstring))
