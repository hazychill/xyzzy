;; need docstring support!
(deftest fix-previous-pseudo-frame-test ()
  "(previous-pseudo-frame) caused \"appframe not found\" error."
  (previous-pseudo-frame)
  => nil)

(defun make-test-package (&rest options)
  (let ((name (format nil "temporary-package-for-test-~D" (test-uid))))
    (apply #'make-package name options)))

(deftest fix-list-all-packages-test ()
  "(list-all-packages) should return 'a copy of' system package list."
  (let* ((pkg (make-test-package))
         (name (package-name pkg))
	 (pkglist (list-all-packages)))
    (delete pkg pkglist)
    (eq pkg (find-package name)))
  => t)

(let ((os-version (list (os-major-version) (os-minor-version)))
      (os-features '(:windows-8 :windows-7 :windows-vista :windows-xp :windows-2000)))
  ;; Windows 2000
  (when (equalp '(5 0) os-version)
    (deftest os-features-2000-test ()
      "*features* contains :windows-2000, :windows-nt"
      (mapcar #'(lambda (k) (not (null (featurep k)))) os-features)
      => (nil nil nil nil t))
    (deftest os-platform-2000-test ()
      "(os-platform) should return :windows-2000"
      (os-platform)
      => windows-2000)
    (deftest user-config-path-and-dump-image-path-2000-test ()
      "(user-config-path) and (si:dump-image-path) should return w2k"
      (values (pathname-name (user-config-path))
              (pathname-type (si:dump-image-path)))
      => "w2k"
      => "w2k"))
  ;; Windows XP
  (when (equalp '(5 1) os-version)
    (deftest os-features-xp-test ()
      "*features* contains :windows-xp, :windows-2000, :windows-nt"
      (mapcar #'(lambda (k) (not (null (featurep k)))) os-features)
      => (nil nil nil t t))
    (deftest os-platform-xp-test ()
      "(os-platform) should return :windows-xp"
      (os-platform)
      => windows-xp)
    (deftest user-config-path-and-dump-image-path-xp-test ()
      "(user-config-path) and (si:dump-image-path) should return wxp"
      (values (pathname-name (user-config-path))
              (pathname-type (si:dump-image-path)))
      => "wxp"
      => "wxp"))
  ;; Windows Vista
  (when (equalp '(6 0) os-version)
    (deftest os-features-vista-test ()
      "*features* contains :windows-vista, :windows-xp, :windows-2000, :windows-nt"
      (mapcar #'(lambda (k) (not (null (featurep k)))) os-features)
      => (nil nil t t t))
    (deftest os-platform-vista-test ()
      "(os-platform) should return :windows-vista"
      (os-platform)
      => windows-vista)
    (deftest user-config-path-and-dump-image-path-vista-test ()
      "(user-config-path) and (si:dump-image-path) は wxp のまま。0.2.2.235 でもパスする"
      (values (pathname-name (user-config-path))
              (pathname-type (si:dump-image-path)))
      => "wxp"
      => "wxp"))
  ;; Windows 7
  (when (equalp '(6 1) os-version)
    (deftest os-features-7-test ()
      "*features* contains :windows-7, :windows-vista, :windows-xp, :windows-2000, :windows-nt"
      (mapcar #'(lambda (k) (not (null (featurep k)))) os-features)
      => (nil t t t t))
    (deftest os-platform-7-test ()
      "(os-platform) should return :windows-7"
      (os-platform)
      => windows-7)
    (deftest user-config-path-and-dump-image-path-7-test ()
      "(user-config-path) and (si:dump-image-path) は wxp のまま。0.2.2.235 でもパスする"
      (values (pathname-name (user-config-path))
              (pathname-type (si:dump-image-path)))
      => "wxp"
      => "wxp"))
  ;; Windows 8
  (when (equalp '(6 2) os-version)
    (deftest os-features-8-test ()
      "*features* contains :windows-8, :windows-7, :windows-vista, :windows-xp, :windows-2000, :windows-nt"
      (mapcar #'(lambda (k) (not (null (featurep k)))) os-features)
      => (t t t t t))
    (deftest os-platform-8-test ()
      "(os-platform) should return :windows-8"
      (os-platform)
      => windows-8)
    (deftest user-config-path-and-dump-image-path-8-test ()
      "(user-config-path) and (si:dump-image-path) は wxp のまま。0.2.2.235 でもパスする"
      (values (pathname-name (user-config-path))
              (pathname-type (si:dump-image-path)))
      => "wxp"
      => "wxp"))
  )


(deftest lisp-implementation-type ()
  (lisp-implementation-type)
  => "xyzzy")

(deftest lisp-implementation-version ()
  (string= (software-version) (lisp-implementation-version))
  => t)


(deftest machine-instance ()
  (string= (machine-instance) (machine-name))
  => t)

(deftest machine-type ()
  (machine-type)
  => #+x86 "x86" #+x64 "x64" #+ia64 "IA64")

(deftest machine-version ()
  (string= (machine-version) (si:getenv "PROCESSOR_IDENTIFIER"))
  => t)


(deftest test-cl-char-Backspace ()
  "Backspace 文字が使えるか"
  (let ((c (read-from-string "#\\Backspace")))
    (values
     (char= c #\C-h)
     (char-code c)
     (char-name c)))
  => t
  => 8
  => "backspace")

(deftest test-cl-char-Tab ()
  "文字名の大文字小文字の区別はしないので、これは 0.2.2.235 でもパスする"
  (let ((c (read-from-string "#\\Tab")))
    (values
     (char= c #\TAB)
     (char-code c)
     (char-name c)))
  => t
  => 9
  => "horizontal_tabulation")

(deftest test-cl-char-Newline ()
  "Newline 文字が使えるか"
  (let ((c (read-from-string "#\\Newline")))
    (values
     (char= c #\LFD)
     (char-code c)
     (char-name c)))
  => t
  => 10
  => "line_feed")

(deftest test-cl-char-Linefeed ()
  "Linefeed 文字が使えるか"
  (let ((c (read-from-string "#\\Linefeed")))
    (values
     (char= c #\LFD)
     (char-code c)
     (char-name c)))
  => t
  => 10
  => "line_feed")

(deftest test-cl-char-Page ()
  "Page 文字が使えるか"
  (let ((c (read-from-string "#\\Page")))
    (values
     (char= c #\C-l)
     (char-code c)
     (char-name c)))
  => t
  => 12
  => "form_feed")

(deftest test-cl-char-Return ()
  "Return 文字が使えるか"
  (let ((c (read-from-string "#\\Return")))
    (values
     (char= c #\RET)
     (char-code c)
     (char-name c)))
  => t
  => 13
  => "carriage_return")

(deftest test-cl-char-Space ()
  "Space 文字が使えるか"
  (let ((c (read-from-string "#\\Space")))
    (values
     (char= c #\SPC)
     (char-code c)
     (char-name c)))
  => t
  => 32
  => "space")

(deftest test-cl-char-Rubout ()
  "Rubout 文字が使えるか"
  (let ((c (read-from-string "#\\Rubout")))
    (values
     (char= c #\DEL)
     (char-code c)
     (char-name c)))
  => t
  => 127
  => "delete")

(deftest test-coerce-to-package ()
  (let ((name (gensym "no-such-package-name")))
    (handler-case
        (lisp::coerce-to-package name)
      (simple-error (c)
        (equal `(,name) (simple-error-format-arguments c)))))
  => t)

(deftest test-defpackage-parse-options-1 ()
  (lisp::defpackage-parse-options
   :foo
   '((:shadowing-import-from :lisp :car)
     (:shadowing-import-from :lisp :cadr)
     (:shadow :caddr)))
  => nil
  => ("caddr")
  => (car cadr)
  => nil
  => nil
  => nil
  => nil
  => nil
  => nil
  => nil)

(deftest test-defpackage-parse-options-2 ()
  (handler-case
      (lisp::defpackage-parse-options
       :foo
       '((:import-from :lisp :cadr)
         (:shadowing-import-from :lisp :car)
         (:shadow :car)))
    (simple-error (c)
      (simple-error-format-arguments c)))
  => (:shadow :shadowing-import-from "car"))

(deftest test-defpackage-parse-options-3 ()
  (handler-case
      (lisp::defpackage-parse-options
       :foo
       '((:import-from :lisp :car)
         (:shadowing-import-from :lisp :car)
         (:shadow :caddr)))
    (simple-error (c)
      (simple-error-format-arguments c)))
  => (:shadowing-import-from :import-from "car"))

(deftest test-defpackage-parse-options-4 ()
  (handler-case
      (lisp::defpackage-parse-options
       :foo
       '((:import-from :lisp :car)
         (:shadowing-import-from :lisp :cadr)
         (:shadow :car)))
    (simple-error (c)
      (simple-error-format-arguments c)))
  => (:shadow :import-from "car"))

(deftest test-defpackage-parse-options-5 ()
  (handler-case
      (lisp::defpackage-parse-options
       :foo
       '((:import-from :lisp :cadr)
         (:shadowing-import-from :lisp :car)
         (:shadow :car)))
    (simple-error (c)
      (simple-error-format-arguments c)))
  => (:shadow :shadowing-import-from "car"))

(deftest test-defpackage-parse-options-6 ()
  (handler-case
      (lisp::defpackage-parse-options
       :foo
       '((:import-from :lisp :cdr :car)
         (:shadowing-import-from :lisp :cddr :car)
         (:shadow :cdddr :car)))
    (simple-error (c)
      (simple-error-format-arguments c)))
  => (:shadow :shadowing-import-from "car"))

(deftest test-defpackage-parse-options-7 ()
  (handler-case
      (lisp::defpackage-parse-options
       :foo
       '((:import-from :lisp :car)
         (:shadowing-import-from :lisp :car)))
    (simple-error (c)
      (simple-error-format-arguments c)))
  => (:shadowing-import-from :import-from "car"))

(deftest test-defpackage-parse-options-8 ()
  (handler-case
      (lisp::defpackage-parse-options
       :foo
       '((:import-from :lisp :cdr)
         (:import-from :lisp :car)
         (:import-from :lisp :car)))
    (simple-error (c)
      (simple-error-format-arguments c)))
  => (:import-from :import-from "car"))

(deftest test-defpackage-parse-options-9 ()
  (handler-case
      (lisp::defpackage-parse-options
       :foo
       '((:import-from :lisp :cdr)
         (:import-from :lisp :car)
         (:shadowing-import-from :lisp :cddr)
         (:shadowing-import-from :lisp :car)))
    (simple-error (c)
      (simple-error-format-arguments c)))
  => (:shadowing-import-from :import-from "car"))

(deftest test-defpackage-parse-options-10 ()
  (handler-case
      (lisp::defpackage-parse-options
       :foo
       '((:shadow :cdr :car :cddr)
         (:shadowing-import-from :lisp :cdddr)
         (:shadowing-import-from :lisp :car)))
    (simple-error (c)
      (simple-error-format-arguments c)))
  => (:shadow :shadowing-import-from "car"))


(deftest test-defstruct-print-function-1 ()
  "print-function を事前に定義。0.2.2.235 でもパスする"
  (let* ((struct-name (gensym "struct-"))
         (print-function-name (gensym "print-function-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     `(defun ,print-function-name (o s p)
        (format s "#<test>")))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:print-function ,print-function-name))
                           '(a b c)))
    (format nil "~A" (eval `(,ctor))))
  => "#<test>")

(deftest test-defstruct-print-function-2 ()
  "print-function を lambda form で定義。0.2.2.235 でもパスする"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     `(let ((v 1))
        ,(si::defstruct-helper `(,struct-name
                                 (:print-function (lambda (o s p) (format s "#<test ~A>" v))))
                               '(a b c))))
    (format nil "~A" (eval `(,ctor))))
  => "#<test 1>")

(deftest test-defstruct-print-function-3 ()
  "print-function をクロージャで定義した場合、警告が出る"
  (let* ((struct-name (gensym "struct-"))
         (print-function-name (gensym "print-function-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     `(defun ,print-function-name (o s p)
        (format s "#<test>")))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:print-function #',print-function-name))
                           '(a b c)))
    (format nil "~A" (eval `(,ctor))))
  => "#<test>")

(deftest test-defstruct-print-function-4 ()
  "print-function をクロージャ (lambda form) で定義した場合、警告が出る"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     `(let ((v 1))
        ,(si::defstruct-helper `(,struct-name
                                 (:print-function #'(lambda (o s p) (format s "#<test ~A>" v))))
                               '(a b c))))
    (format nil "~A" (eval `(,ctor))))
  => "#<test 1>")

(deftest test-defstruct-print-function-5 ()
  "print-function を後で定義する場合"
  (let* ((struct-name (gensym "struct-"))
         (print-function-name (gensym "print-function-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:print-function ,print-function-name))
                           '(a b c)))
    (eval
     `(defun ,print-function-name (o s p)
        (format s "#<test>")))
    (format nil "~A" (eval `(,ctor))))
  => "#<test>")

(deftest test-defstruct-print-function-6 ()
  "print-function を再定義する場合"
  (let* ((struct-name (gensym "struct-"))
         (print-function-name (gensym "print-function-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     `(defun ,print-function-name (o s p)
        (format s "#<test>")))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:print-function ,print-function-name))
                           '(a b c)))
    (eval
     `(defun ,print-function-name (o s p)
        (format s "#<test2>")))
    (format nil "~A" (eval `(,ctor))))
  => "#<test2>")


(deftest test-defstruct-parent-print-function-1 ()
  "親の print-function を継承しない場合コンパイルできる。0.2.2.235 でもパスする"
  (let* ((struct-name1 (gensym "struct-"))
         (struct-name2 (gensym "struct-")))
    (eval
     (si::defstruct-helper `(,struct-name1
                             (:print-function (lambda (o s p) (format o "#<test>"))))
                           '(a b c)))
    (compile nil `(lambda ()
                    ,@(si::defstruct-helper `(,struct-name2
                                              (:print-function (lambda (o s p) (format o "#<test2>")))
                                              (:include ,struct-name1))
                                            '(d)))))
  => non-nil)

(deftest test-defstruct-parent-print-function-2 ()
  "親の print-function を継承する場合コンパイルできる (lambda form)"
  (let* ((struct-name1 (gensym "struct-"))
         (struct-name2 (gensym "struct-")))
    (declare (special struct-name1 struct-name2))
    (eval
     (si::defstruct-helper `(,struct-name1
                             (:print-function (lambda (o s p) (format o "#<test>"))))
                           '(a b c)))
    (compile nil `(lambda ()
                    ,@(si::defstruct-helper `(,struct-name2
                                              (:include ,struct-name1))
                                            '(d)))))
  => non-nil)

(deftest test-defstruct-parent-print-function-3 ()
  "親の print-function を継承する場合コンパイルできる (symbol)"
  (let* ((struct-name1 (gensym "struct-"))
         (struct-name2 (gensym "struct-"))
         (print-function-name1 (gensym "print-function-"))
         (ctor2 (intern (format nil "make-~A" struct-name2))))
    (declare (special struct-name1 struct-name2))
    (eval
     `(defun ,print-function-name1 (o s p)
        (format s "#<test>")))
    (eval
     (si::defstruct-helper `(,struct-name1
                             (:print-function ,print-function-name1))
                           '(a b c)))
    (compile nil `(lambda ()
                    ,@(si::defstruct-helper `(,struct-name2
                                              (:include ,struct-name1))
                                            '(d)))))
  => non-nil)


(deftest test-defstruct-default-constructor-1 ()
  ":constructor 指定がない場合デフォルトコンストラクタが作成される"
  (let* ((struct-name (gensym "struct-"))
         (default-ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name)
                           '(a b c)))
    (values
     (fboundp default-ctor)
     (typep (eval `(,default-ctor)) struct-name)))
  => t
  => t)

(deftest test-defstruct-default-constructor-2 ()
  ":constructor 指定がない場合デフォルトコンストラクタが作成される"
  (let* ((struct-name (gensym "struct-"))
         (default-ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor))
                           '(a b c)))
    (values
     (fboundp default-ctor)
     (typep (eval `(,default-ctor)) struct-name)))
  => t
  => t)

(deftest test-defstruct-default-constructor-3 ()
  "デフォルトコンストラクタと違う名前で :constructor 指定がある場合、
デフォルトコンストラクタは作成されない"
  (let* ((struct-name (gensym "struct-"))
         (default-ctor (intern (format nil "make-~A" struct-name)))
         (other-ctor (intern (format nil "make-~A-2" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,other-ctor))
                           '(a b c)))
    (values
     (fboundp default-ctor)
     (fboundp other-ctor)
     (typep (eval `(,other-ctor)) struct-name)))
  => nil
  => t
  => t)

(deftest test-defstruct-default-constructor-4 ()
  "デフォルトコンストラクタと同じ名前で :constructor 指定がある場合、
デフォルトコンストラクタは作成されない"
  (let* ((struct-name (gensym "struct-"))
         (default-ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,default-ctor (a b c)))
                           '(a b c)))
    (values
     (fboundp default-ctor)
     (typep (eval `(,default-ctor 1 2 3)) struct-name)))
  => t
  => t)


(deftest test-defstruct-constructor-arg-1 ()
  "コンストラクタで引数をすべて指定した場合。0.2.2.235 でもパスする"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A-2" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (a b c)))
                           '(a b c)))
    (let ((o (eval `(,ctor 1 2 3))))
      (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c))))
  => (1 2 3))

(deftest test-defstruct-constructor-arg-2 ()
  "コンストラクタで引数を一部指定した場合"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A-2" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (a c)))
                           '(a b c)))
    (let ((o (eval `(,ctor 1 3))))
      (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c))))
  => (1 nil 3))

(deftest test-defstruct-constructor-arg-3 ()
  "コンストラクタで引数を指定した場合 (&optional)"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A-2" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (a &optional c (d 4))))
                           '(a b c d)))
    (let ((o (eval `(,ctor 1 3))))
      (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c :d))))
  => (1 nil 3 4))

(deftest test-defstruct-constructor-arg-4 ()
  "コンストラクタで引数を指定した場合 (&key)"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A-2" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (a &key (c 3) d)))
                           '(a b c d)))
    (let ((o (eval `(,ctor 1 :d 4))))
      (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c :d))))
  => (1 nil 3 4))


(deftest test-defstruct-default-constructor-arg-1 ()
  "コンストラクタで引数をすべて指定した場合"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (a b c)))
                           '(a b c)))
    (let ((o (eval `(,ctor 1 2 3))))
      (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c))))
  => (1 2 3))

(deftest test-defstruct-default-constructor-arg-2 ()
  "コンストラクタで引数を一部指定した場合"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (a c)))
                           '(a b c)))
    (let ((o (eval `(,ctor 1 3))))
      (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c))))
  => (1 nil 3))

(deftest test-defstruct-default-constructor-arg-3 ()
  "コンストラクタで引数を指定した場合 (&optional)"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (a &optional c (d 4))))
                           '(a b c d)))
    (let ((o (eval `(,ctor 1 3))))
      (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c :d))))
  => (1 nil 3 4))

(deftest test-defstruct-default-constructor-arg-4 ()
  "コンストラクタで引数を指定した場合 (&key)"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (a &key (c 3) d)))
                           '(a b c d)))
    (let ((o (eval `(,ctor 1 :d 4))))
      (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c :d))))
  => (1 nil 3 4))


(deftest test-defstruct-constructor-with-slots-1 ()
  "コンストラクタを指定してもスロット定義の初期値が無視されない"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (a b)))
                           '((a 1) (b 2) (c 3) (d 4))))
    (macrolet ((test (&rest args)
                 `(let ((o (eval `(,ctor ,,@args))))
                    (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c :d)))))
      (values (test 10 20)
              (test nil nil)
              )))
  => (10 20 3 4)
  => (nil nil 3 4))

(deftest test-defstruct-constructor-with-slots-2 ()
  "コンストラクタを指定してもスロット定義の初期値が無視されない"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (a b &optional (c 30))))
                           '((a 1) (b 2) (c 3) (d 4))))
    (macrolet ((test (&rest args)
                 `(let ((o (eval `(,ctor ,,@args))))
                    (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c :d)))))
      (values (test 10 20)
              (test 10 20 300)
              (test nil nil nil)
              )))
  => (10 20 30 4)
  => (10 20 300 4)
  => (nil nil nil 4))

(deftest test-defstruct-constructor-with-slots-3 ()
  "コンストラクタを指定してもスロット定義の初期値が無視されない"
  (let* ((struct-name (gensym "struct-"))
         (ctor (intern (format nil "make-~A" struct-name))))
    (eval
     (si::defstruct-helper `(,struct-name
                             (:constructor ,ctor (&optional (c 30))))
                           '(a b c (d 40))))
    (macrolet ((test (&rest args)
                 `(let ((o (eval `(,ctor ,,@args))))
                    (mapcar #'(lambda (slot) (si:*slot-value o slot)) '(:a :b :c :d)))))
      (values (test)
              (test 300)
              (test nil)
              )))
  => (nil nil 30 40)
  => (nil nil 300 40)
  => (nil nil nil 40))


(defmacro with-lispmode-bed (&body body)
  `(with-temp-buffer
     (lisp-mode)
     ,@body))

(defmacro user::smart-indentation-test (&whole whole &environment env vars &body body)
  `(prog ,vars ,@body))

(deftest lispmode-smart-indentation-for-macro-form-test ()
  "smart indentation for macro function symbol without
lisp-indent-hook property"
  (let ((*lisp-body-indent* 2)
	(*lisp-body-indention* 2))
    (with-lispmode-bed
      (setq *buffer-package* "user")
      (insert "(smart-indentation-test (a b)")
      (goto-char 23)
      #0=(lisp-newline-and-indent)
      (values #1=(current-column)
	      (and (goto-char (point-max)) #0# #1#))))
  => 4
  => 2)

(deftest fix-truename-1 ()
  (let ((path (merge-pathnames "drivers/etc/hosts" (get-system-directory))))
    (path-equal path (truename path)))
  => t)

(deftest fix-truename-2 ()
  (let ((path (merge-pathnames "drivers/etc" (get-system-directory))))
    (path-equal path (truename path)))
  => t)

(deftest fix-truename-3 ()
  (let ((path (merge-pathnames "drivers" (get-system-directory))))
    (path-equal path (truename path)))
  => t)

(deftest fix-truename-4 ()
  (let ((path (merge-pathnames "System32" (si:getenv "SystemRoot"))))
    (path-equal path (truename path)))
  => t)

#+wow64
(deftest fix-truename-5 ()
  (let ((path (merge-pathnames "SysWOW64" (si:getenv "SystemRoot"))))
    (path-equal path (truename path)))
  => t)

#+wow64
(deftest fix-truename-6 ()
  (let ((path (merge-pathnames "Sysnative" (si:getenv "SystemRoot"))))
    (path-equal path (truename path)))
  => t)

(deftest test-defpackage-parse-options-1 ()
  (lisp::defpackage-parse-options
   :foo
   '((:documentation "hogehoge")
     (:documentation "fugafuga")))
  => nil
  => nil
  => nil
  => nil
  => nil
  => nil
  => nil
  => nil
  => nil
  => "fugafuga")

(deftest defpackage-documentation ()
  (let* ((pkg-name (gensym "pkg-")))
    (eval
     `(defpackage ,pkg-name
        (:documentation "test package")))
    (documentation (find-package pkg-name) t))
  => "test package")

(deftest defpackage-documentation-wrong-doc-type ()
  (let* ((pkg-name (gensym "pkg-")))
    (eval
     `(defpackage ,pkg-name
        (:documentation "test package")))
    (documentation (find-package pkg-name) nil))
  !! si::check-type-error)
