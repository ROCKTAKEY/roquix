(use-modules (srfi srfi-64))

(test-begin "intentional-failure")
(test-assert "an unexpected failure is reported to the caller" #f)
(test-end "intentional-failure")
