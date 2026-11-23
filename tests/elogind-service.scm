(use-modules (gnu)
             (gnu services dbus)
             (gnu services desktop)
             (gnu system vm)
             (gnu tests)
             (roquix services elogind))

(virtual-machine
 (graphic? #f)
 (operating-system
  (simple-operating-system
   (simple-service 'service-test etc-service-type
                   (list (list "service-test" (local-file "elogind-service.sh"))))
   (simple-service 'login-user account-service-type
                   (list (user-account (name "tester") (group "users")
                                       (password ""))))
   (service dbus-root-service-type)
   (service polkit-service-type)
   (service unified-elogind-service-type))))
