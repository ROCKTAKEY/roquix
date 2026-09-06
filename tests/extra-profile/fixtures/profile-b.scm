(use-modules (extra-profile fixtures packages)
             (guix profiles))

(packages->manifest (list fixture-profile-b))
