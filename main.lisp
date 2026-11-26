(in-package :cl-cgr)

					; Low Earth Orbit Scenarios 

(defscenario *leo-a*
  "LEO A is a small constellation of 12 satellites in two orbital planes,
   relaying data down to a single ground station in Argentina over four days."
  :contact-plan "data/eval/leo-a"
  :sources (2 3 4 5 6 7 8 9 10 11 12 13)
  :destinations (1)
  :time-window 43200)

(defscenario *leo-b*
  "LEO B is a constellation of 16 satellites in two orbital planes,
   relaying data down to a single ground station in Argentina over four days."
  :contact-plan "data/eval/leo-b"
  :sources (2 3 4 5 6 7 8 9 10 11 12 13)
  :destinations (1)
  :time-window 43200)

(defscenario *leo-c*
  "LEO C is a constellation of 16 satellites in four orbital planes,
   relaying data down to a single ground station in Argentina over four days."
  :contact-plan "data/eval/leo-c"
  :sources (2 3 4 5 6 7 8 9 10 11 12 13)
  :destinations (1)
  :time-window 43200)

(defscenario *leo-d*
  "LEO D is a constellation of 24 satellites in three orbital planes,
   relaying data down to a single ground station in Argentina over four days."
  :contact-plan "data/eval/leo-d"
  :sources (2 3 4 5 6 7 8 9 10 11 12 13)
  :destinations (1)
  :time-window 43200)

					; Lunar Orbit Scenarios

(defscenario *moon-a*
  "MOON A is a lunar relay network of 8 satellites carrying data from far-side sensors
   to Earth, through ground stations at both poles and two high latitudes, over seven days."
  :contact-plan "data/eval/moon-a"
  :sources (10 11 12 13 14 15 16 17)
  :destinations (1 2 3)
  :time-window 388800)

(defscenario *moon-a-isl*
  "MOON A with inter-satellite links, so satellites can also pass data between each other
   on the way to Earth."
  :contact-plan "data/eval/moon-a-isl"
  :sources (10 11 12 13 14 15 16 17)
  :destinations (1 2 3)
  :time-window 388800)

(defscenario *moon-b*
  "MOON B is a lunar relay network of 8 satellites carrying data from far-side sensors
   to Earth, through ground stations at both poles and two low latitudes, over seven days."
  :contact-plan "data/eval/moon-b"
  :sources (10 11 12 13 14 15 16 17)
  :destinations (1 2 3)
  :time-window 388800)

(defscenario *moon-b-isl*
  "MOON B with inter-satellite links, so satellites can also pass data between each other
   on the way to Earth."
  :contact-plan "data/eval/moon-b"
  :sources (10 11 12 13 14 15 16 17)
  :destinations (1 2 3)
  :time-window 388800)

(defun benchmark! (scenario results-dir)
  "Compares how quickly each router delivers the same random demands across a scenario,
   and logs the results to the file-system at RESULTS-DIR."
  (let* ((scenario-name (scenario-name scenario))
	 (contact-plan (scenario-contact-plan scenario))
	 (demands (loop for demand = (generate-demand scenario)
			if (deliverable-p demand scenario :router #'cgr)
			  collect demand into demands
			  and count t into kept
			until (= kept 5000)
			finally (return demands)))
	 (direct (route contact-plan demands :router #'direct))
	 (cgr (route contact-plan demands :router #'cgr)))
    (log! direct (format nil "~A/~A-direct" results-dir scenario-name))
    (log! cgr (format nil "~A/~A-cgr" results-dir scenario-name))))

 (loop for scenario in (list *leo-a* *leo-b* *leo-c* *leo-d* *moon-a* *moon-a-isl* *moon-b* *moon-b-isl*)
       do (format t "Starting ~A~%" (scenario-name scenario))
 	 (benchmark! scenario "~/Research/cl-cgr/"))
