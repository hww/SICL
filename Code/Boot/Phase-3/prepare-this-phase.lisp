(cl:in-package #:sicl-boot-phase-3)

(defun prepare-this-phase (e1 e2 e3)
  (setf (env:fdefinition (env:client e3) e3 'sicl-boot:ast-eval)
        (lambda (ast)
          (sicl-ast-evaluator:eval-ast (env:client e3) e3 ast)))
  (sicl-boot:copy-macro-functions e2 e3)
  (enable-typep e2)
  (enable-object-creation e1 e2)
  (enable-defgeneric e1 e2 e3)
  (enable-class-initialization e3)
  (enable-defclass e1 e2 e3)
  (enable-defmethod e1 e2 e3))
