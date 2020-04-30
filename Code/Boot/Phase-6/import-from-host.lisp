(cl:in-package #:sicl-boot-phase-6)

(defun import-from-host (boot)
  (with-accessors ((e5 sicl-boot:e5)
                   (e6 sicl-boot:e6)
                   (e7 sicl-boot:e7))
      boot
  (sicl-hir-interpreter:fill-environment e7)
    (import-functions-from-host
     '((setf sicl-genv:constant-variable)
       sicl-conditionals:cond-expander
       sicl-conditionals:and-expander
       listp sort every
       mapc 1+ 1- subseq butlast position identity nthcdr equal
       find-if-not mapcar remove-duplicates union reduce count last
       copy-list
       gensym values rest second error
       get-properties
       atom cddr (setf cdr) <
       not
       remove-if-not reverse find (setf sicl-genv:constant-variable))
     e5)
    (import-functions-from-host
     '(cleavir-code-utilities:parse-generic-function-lambda-list
       cleavir-code-utilities:required
       cleavir-code-utilities:parse-specialized-lambda-list
       cleavir-code-utilities:separate-function-body
       cleavir-code-utilities:proper-list-p
       (setf sicl-genv:type-expander)
       (setf sicl-genv:find-class)
       sicl-genv:typep
       (setf sicl-genv:special-variable)
       sicl-genv:find-class
       sicl-genv:fdefinition
       (setf sicl-genv:fdefinition)
       sicl-genv:macro-function
       (setf sicl-genv:macro-function)
       sicl-genv:get-setf-expansion
       sicl-genv:fboundp
       sicl-genv:find-method-combination-template
       (setf sicl-genv:find-method-combination-template)
       sicl-method-combination::define-method-combination-expander
       sicl-clos::add-path
       sicl-clos::extract-transition-information
       sicl-clos::make-automaton
       sicl-loop::list-car sicl-loop::list-cdr
       cons car cdr cadr cddr caddr cdddr (setf cdr) rplacd first
       nth assoc reverse
       copy-list list list* append length
       null atom eq not member symbolp functionp stringp consp
       make-list set-difference remove find find-if adjoin remove
       eql equal set-exclusive-or
       sort mapcar subseq 1+ elt position position-if
       apply endp coerce
       error
       + 1+ floor = /=)
     e6)
    (import-functions-from-host
     '(funcall
       (setf sicl-genv:function-lambda-list)
       (setf sicl-genv:function-type))
     e7)))
