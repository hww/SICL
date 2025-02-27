(cl:in-package #:asdf-user)

(defsystem #:sicl-ast-evaluator
  :depends-on (#:cleavir-ast
               #:sicl-ast
               #:cleavir-cst-to-ast
               #:cleavir-ast-transformations
               #:cleavir-code-utilities
               #:concrete-syntax-tree
               #:sicl-client
               #:sicl-environment
               #:sicl-source-tracking
               #:sicl-data-and-control-flow-support
               #:sicl-evaluation-and-compilation-support
               #:sicl-loop-support
               #:sicl-cons-support
               #:sicl-iteration-support
               #:sicl-conditions-support
               #:sicl-clos-macro-support
               #:sicl-hir-evaluator
               #:sicl-run-time
               #:sicl-conditionals-support)
  :serial t
  :components
  ((:file "packages")
   (:file "run-time")
   (:file "lexical-environment")
   (:file "translate-ast")
   (:file "translate-character-related-asts")
   (:file "translate-array-related-asts")
   (:file "translate-cons-related-asts")
   (:file "translate-fixnum-related-asts")
   (:file "translate-multiple-value-related-asts")
   (:file "translate-code")
   (:file "eval-ast")))
