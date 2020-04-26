(cl:in-package #:sicl-boot-phase-4)

(defun enable-generic-function-initialization (boot)
  (with-accessors ((e4 sicl-boot:e4)) boot
    (import-functions-from-host
     '(cleavir-code-utilities:parse-generic-function-lambda-list
       cleavir-code-utilities:required)
     e4)
    ;; MAKE-LIST is called from the :AROUND method on
    ;; SHARED-INITIALIZE specialized to GENERIC-FUNCTION.
    (import-function-from-host 'make-list e4)
    ;; SET-DIFFERENCE is called by the generic-function initialization
    ;; protocol to verify that the argument precedence order is a
    ;; permutation of the required arguments.
    (import-function-from-host 'set-difference e4)
    ;; STRINGP is called by the generic-function initialization
    ;; protocol to verify that the documentation is a string.
    (import-function-from-host 'stringp e4)
    (load-fasl "CLOS/generic-function-initialization-support.fasl" e4)
    (load-fasl "CLOS/generic-function-initialization-defmethods.fasl" e4)))

(defun load-accessor-defgenerics (e5)
  (load-fasl "CLOS/specializer-direct-generic-functions-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-specializer-direct-generic-functions-defgeneric.fasl" e5)
  (load-fasl "CLOS/specializer-direct-methods-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-specializer-direct-methods-defgeneric.fasl" e5)
  (load-fasl "CLOS/eql-specializer-object-defgeneric.fasl" e5)
  (load-fasl "CLOS/unique-number-defgeneric.fasl" e5)
  (load-fasl "CLOS/class-name-defgeneric.fasl" e5)
  (load-fasl "CLOS/class-direct-subclasses-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-class-direct-subclasses-defgeneric.fasl" e5)
  (load-fasl "CLOS/class-direct-default-initargs-defgeneric.fasl" e5)
  (load-fasl "CLOS/documentation-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-documentation-defgeneric.fasl" e5)
  (load-fasl "CLOS/class-finalized-p-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-class-finalized-p-defgeneric.fasl" e5)
  (load-fasl "CLOS/class-precedence-list-defgeneric.fasl" e5)
  (load-fasl "CLOS/precedence-list-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-precedence-list-defgeneric.fasl" e5)
  (load-fasl "CLOS/instance-size-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-instance-size-defgeneric.fasl" e5)
  (load-fasl "CLOS/class-direct-slots-defgeneric.fasl" e5)
  (load-fasl "CLOS/class-direct-superclasses-defgeneric.fasl" e5)
  (load-fasl "CLOS/class-default-initargs-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-class-default-initargs-defgeneric.fasl" e5)
  (load-fasl "CLOS/class-slots-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-class-slots-defgeneric.fasl" e5)
  (load-fasl "CLOS/class-prototype-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-class-prototype-defgeneric.fasl" e5)
  (load-fasl "CLOS/entry-point-defgenerics.fasl" e5)
  (load-fasl "CLOS/environment-defgenerics.fasl" e5)
  (load-fasl "CLOS/dependents-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-dependents-defgeneric.fasl" e5)
  (load-fasl "CLOS/generic-function-name-defgeneric.fasl" e5)
  (load-fasl "CLOS/generic-function-lambda-list-defgeneric.fasl" e5)
  (load-fasl "CLOS/generic-function-argument-precedence-order-defgeneric.fasl" e5)
  (load-fasl "CLOS/generic-function-declarations-defgeneric.fasl" e5)
  (load-fasl "CLOS/generic-function-method-class-defgeneric.fasl" e5)
  (load-fasl "CLOS/generic-function-method-combination-defgeneric.fasl" e5)
  (load-fasl "CLOS/generic-function-methods-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-generic-function-methods-defgeneric.fasl" e5)
  (load-fasl "CLOS/initial-methods-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-initial-methods-defgeneric.fasl" e5)
  (load-fasl "CLOS/call-history-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-call-history-defgeneric.fasl" e5)
  (load-fasl "CLOS/specializer-profile-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-specializer-profile-defgeneric.fasl" e5)
  (load-fasl "CLOS/method-function-defgeneric.fasl" e5)
  (load-fasl "CLOS/method-generic-function-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-method-generic-function-defgeneric.fasl" e5)
  (load-fasl "CLOS/method-lambda-list-defgeneric.fasl" e5)
  (load-fasl "CLOS/method-specializers-defgeneric.fasl" e5)
  (load-fasl "CLOS/method-qualifiers-defgeneric.fasl" e5)
  (load-fasl "CLOS/accessor-method-slot-definition-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-accessor-method-slot-definition-defgeneric.fasl" e5)
  (load-fasl "CLOS/slot-definition-name-defgeneric.fasl" e5)
  (load-fasl "CLOS/slot-definition-allocation-defgeneric.fasl" e5)
  (load-fasl "CLOS/slot-definition-type-defgeneric.fasl" e5)
  (load-fasl "CLOS/slot-definition-initargs-defgeneric.fasl" e5)
  (load-fasl "CLOS/slot-definition-initform-defgeneric.fasl" e5)
  (load-fasl "CLOS/slot-definition-initfunction-defgeneric.fasl" e5)
  (load-fasl "CLOS/slot-definition-storage-defgeneric.fasl" e5)
  (load-fasl "CLOS/slot-definition-readers-defgeneric.fasl" e5)
  (load-fasl "CLOS/slot-definition-writers-defgeneric.fasl" e5)
  (load-fasl "CLOS/slot-definition-location-defgeneric.fasl" e5)
  (load-fasl "CLOS/setf-slot-definition-location-defgeneric.fasl" e5)
  (load-fasl "CLOS/variant-signature-defgeneric.fasl" e5)
  (load-fasl "CLOS/template-defgeneric.fasl" e5)
  (load-fasl "Package-and-symbol/symbol-name-defgeneric.fasl" e5)
  (load-fasl "Package-and-symbol/symbol-package-defgeneric.fasl" e5)
  (load-fasl "Compiler/Code-object/generic-functions.fasl" e5))

(defun define-accessor-generic-functions (boot)
  (with-accessors ((e3 sicl-boot:e3)
                   (e4 sicl-boot:e4)
                   (e5 sicl-boot:e5))
      boot
    (import-functions-from-host
     '(cdr)
     e4)
    (import-functions-from-host '(listp) e3)
    (sicl-hir-interpreter:fill-environment e5)
    (import-function-from-host 'funcall e5)
    (import-function-from-host '(setf sicl-genv:function-lambda-list) e5)
    (import-function-from-host '(setf sicl-genv:function-type) e5)
    (enable-defgeneric e3 e4 e5)
    (load-fasl "CLOS/invalidate-discriminating-function.fasl" e4)
    (enable-generic-function-initialization boot)
    (load-accessor-defgenerics e5)))
