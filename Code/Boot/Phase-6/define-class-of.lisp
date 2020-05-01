(cl:in-package #:sicl-boot-phase-6)

(defun define-class-of (e6)
  (setf (sicl-genv:fdefinition 'class-of e6)
        (lambda (object)
          (let ((result (cond ((typep object 'sicl-boot-phase-3::header)
                               (slot-value object 'sicl-boot-phase-3::%class))
                              ((consp object)
                               (sicl-genv:find-class 'cons e6))
                              ((null object)
                               (sicl-genv:find-class 'null e6))
                              ((symbolp object)
                               (sicl-genv:find-class 'symbol e6))
                              ((integerp object)
                               (sicl-genv:find-class 'fixnum e6))
                              ((streamp object)
                               (sicl-genv:find-class 't e6))
                              (t
                               (class-of object)))))
            result))))
