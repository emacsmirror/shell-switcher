(require 'rswitcher)
(require 'ert)

(ert-deftest rswitcher-test-add-increment-length ()
  "rswitcher-add increases length"
  (let ((s (rswitcher-make)))
    (should (equal 0 (rswitcher-length s)))
    (rswitcher-add s 'c)
    (should (equal 1 (rswitcher-length s)))
    (rswitcher-add s 'b)
    (should (equal 2 (rswitcher-length s)))))

(ert-deftest rswitcher-test-delete-head ()
  "rswitcher--delete removes head correctly"
  (let ((s (rswitcher-make)))
    (rswitcher-add s 'c)
    (rswitcher-add s 'b)
    (rswitcher-add s 'a)
    (should (equal '(a b c) (rswitcher--elements s)))
    (should (equal 'a (rswitcher-most-recent s)))
    (should (equal 'a (rswitcher--delete s 0)))
    (should (equal '(b c) (rswitcher--elements s)))
    (should (equal 'b (rswitcher-most-recent s))))
  (let ((s (rswitcher-make)))
    (rswitcher-add s 'a)
    (should (equal '(a) (rswitcher--elements s)))
    (should (equal 'a (rswitcher--delete s 0)))
    (should (equal '() (rswitcher--elements s)))
    (should (equal nil (rswitcher-most-recent s)))))

(ert-deftest rswitcher-test-delete-last ()
  "rswitcher--delete removes last correctly"
  (let ((s (rswitcher-make)))
    (rswitcher-add s 'c)
    (rswitcher-add s 'b)
    (rswitcher-add s 'a)
    (should (equal '(a b c) (rswitcher--elements s)))
    (should (equal 'a (rswitcher-most-recent s)))
    (should (equal 'c (rswitcher--delete s 2)))
    (should (equal 'a (rswitcher-most-recent s)))
    (should (equal '(a b) (rswitcher--elements s)))))

(ert-deftest rswitcher-test-delete-middle ()
  "rswitcher--delete removes middle correctly"
  (let ((s (rswitcher-make)))
    (rswitcher-add s 'c)
    (rswitcher-add s 'b)
    (rswitcher-add s 'a)
    (should (equal '(a b c) (rswitcher--elements s)))
    (should (equal 'a (rswitcher-most-recent s)))
    (should (equal 'b (rswitcher--delete s 1)))
    (should (equal 'a (rswitcher-most-recent s)))
    (should (equal '(a c) (rswitcher--elements s)))))

(ert-deftest rswitcher-test-delete-after-switch ()
  (let ((s (rswitcher-make)))
    (rswitcher-add s 'c)
    (rswitcher-add s 'b)
    (rswitcher-add s 'a)
    (should (equal 'a (rswitcher-most-recent s)))
    (rswitcher-switch-full s)
    (rswitcher-switch-partial s)
    (should (equal 'c (rswitcher-most-recent s)))
    (should (equal '(a b c) (rswitcher--elements s)))
    (rswitcher--delete s 2)
    (should (equal '(a b) (rswitcher--elements s)))
    (should (equal 'a (rswitcher-most-recent s)))))

(ert-deftest rswitcher-test-add-make-most-recent ()
  "rswitcher-add makes new element most-recent"
  (let ((s (rswitcher-make)))
    (rswitcher-add s 'a)
    (should (equal (rswitcher-most-recent s) 'a))
    (rswitcher-add s 'b)
    (should (equal (rswitcher-most-recent s) 'b))))

(ert-deftest rswitcher-test-switch-full ()
  "simple scenario for switch-full"
  (let ((s (rswitcher-make)))
    (rswitcher-add s 'a)
    (rswitcher-add s 'b)
    (should (equal (rswitcher-most-recent s) 'b))
    (rswitcher-switch-full s)
    (should (equal (rswitcher-most-recent s) 'a))
    (rswitcher-switch-full s)
    (should (equal (rswitcher-most-recent s) 'b))
    (rswitcher-add s 'c)
    (should (equal (rswitcher-most-recent s) 'c))
    (rswitcher-switch-full s)
    (should (equal (rswitcher-most-recent s) 'b))
    (rswitcher-switch-full s)
    (should (equal (rswitcher-most-recent s) 'c))
    (rswitcher-switch-full s)
    (should (equal (rswitcher-most-recent s) 'b))))

(ert-deftest rswitcher-test-switch-partial ()
  "simple scenario for switch-partial"
  (let ((s (rswitcher-make)))
    (rswitcher-add s 'a)
    (rswitcher-add s 'b)
    (should (equal (rswitcher-most-recent s) 'b))
    (rswitcher-switch-full s)
    (should (equal (rswitcher-most-recent s) 'a))
    (rswitcher-switch-partial s)
    (should (equal (rswitcher-most-recent s) 'b))
    (rswitcher-switch-partial s)
    (should (equal (rswitcher-most-recent s) 'a))))

(ert-deftest rswitcher-test-mixing-partial-and-full-with-2-elts ()
  "mixing use of partial and full"
  (let ((s (rswitcher-make)))
    (rswitcher-add s 'a)
    (rswitcher-add s 'b)
    (should (equal 'b (rswitcher-most-recent s)))
    (rswitcher-switch-full s)
    (should (equal 'a (rswitcher-most-recent s)))
    (rswitcher-switch-partial s)
    (should (equal 'b (rswitcher-most-recent s)))
    (rswitcher-switch-partial s)
    (should (equal 'a (rswitcher-most-recent s)))
    (rswitcher-switch-partial s)
    (should (equal 'b (rswitcher-most-recent s)))
    (rswitcher-switch-full s)
    (should (equal 'a (rswitcher-most-recent s)))
    (rswitcher-switch-full s)
    (should (equal 'b (rswitcher-most-recent s)))
    (rswitcher-switch-full s)
    (should (equal 'a (rswitcher-most-recent s)))))

(ert-deftest rswitcher-test-mixing-partial-and-full ()
  "mixing use of partial and full"
  (let ((s (rswitcher-make)))
    (rswitcher-add s 'a)
    (rswitcher-add s 'b)
    (rswitcher-add s 'c)
    (should (equal 'c (rswitcher-most-recent s)))
    (rswitcher-switch-full s)
    (should (equal 'b (rswitcher-most-recent s)))
    (rswitcher-switch-partial s)
    (should (equal 'a (rswitcher-most-recent s)))
    (rswitcher-switch-partial s)
    (should (equal 'c (rswitcher-most-recent s)))
    (rswitcher-switch-partial s)
    (should (equal 'b (rswitcher-most-recent s)))
    (rswitcher-switch-partial s)
    (should (equal 'a (rswitcher-most-recent s)))
    (rswitcher-switch-full s)
    (should (equal 'c (rswitcher-most-recent s)))
    (rswitcher-switch-full s)
    (should (equal 'a (rswitcher-most-recent s)))
    (rswitcher-switch-full s)
    (should (equal 'c (rswitcher-most-recent s)))))
