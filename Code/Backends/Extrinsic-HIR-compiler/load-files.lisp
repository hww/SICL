(cl:in-package #:sicl-extrinsic-hir-compiler)

(defun rp (filename)
  (asdf:system-relative-pathname :sicl-extrinsic-hir-compiler filename))

(load (rp "../../Evaluation-and-compilation/lambda.lisp"))
(load (rp "../../Environment/multiple-value-bind.lisp"))
(load (rp "../../Data-and-control-flow/setf.lisp"))
(load (rp "../../Environment/defun.lisp"))
(load (rp "../../Data-and-control-flow/fboundp.lisp"))
(load (rp "../../Data-and-control-flow/fdefinition.lisp"))
