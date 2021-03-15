(cl:in-package #:sicl-clos)

;;; This function returns the unique number of the class, assigned
;;; when the class is initialized or reinitialized.
(defgeneric unique-number (class))

;;; For the specification of this generic function, see
;;; http://metamodular.com/CLOS-MOP/class-name.html
(defgeneric class-name (class))

(defclass class (specializer)
  ((%unique-number 
    ;; FIXME: the unique numbers should be assigned during class
    ;; finalization, and not here.
    :initform (prog1 *class-unique-number* (incf *class-unique-number*))
    :reader unique-number)
   (%name 
    :initform nil
    :initarg :name 
    ;; There is a specified function named (SETF CLASS-NAME), but it
    ;; is not an accessor.  Instead it works by calling
    ;; REINITIALIZE-INSTANCE with the new name.
    :reader class-name)
   (%direct-subclasses 
    :initform '() 
    :initarg :direct-subclasses
    :accessor class-direct-subclasses)))
