(define-module (roquix services process-exporter)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:use-module (roquix packages process-exporter)
  #:export (process-exporter-configuration process-exporter-configuration?
                                           process-exporter-service-type))

(define-record-type* <process-exporter-configuration>
                     process-exporter-configuration
                     make-process-exporter-configuration
  process-exporter-configuration?
  (package
    process-exporter-configuration-package
    (default process-exporter))
  (listen-address process-exporter-configuration-listen-address
                  (default ":9256"))
  (config-file process-exporter-configuration-config-file
               (default (plain-file "process-exporter.yml"
                                    "process_names:
  - name: '{{.Comm}}'
    cmdline: ['.*']
"))))

(define (process-exporter-shepherd-services config)
  (list (shepherd-service (provision '(process-exporter))
                          (requirement '(networking user-processes))
                          (documentation
                           "Collect CPU, memory and I/O metrics grouped by process name.")
                          (start #~(make-forkexec-constructor (list #$(file-append
                                                                       (process-exporter-configuration-package
                                                                        config)
                                                                       "/bin/process-exporter")
                                                               "-config.path"
                                                               #$(process-exporter-configuration-config-file
                                                                  config)
                                                               "-web.listen-address"
                                                               #$(process-exporter-configuration-listen-address
                                                                  config)
                                                               "-threads=false"
                                                               "-children=false"
                                                               "-gather-smaps=true")
                                    #:log-file "/var/log/process-exporter.log"))
                          (stop #~(make-kill-destructor)))))

(define process-exporter-service-type
  (service-type (name 'process-exporter)
                (extensions (list (service-extension
                                   shepherd-root-service-type
                                   process-exporter-shepherd-services)))
                (default-value (process-exporter-configuration))
                (description
                 "Export process groups to Prometheus.  Runs as root to read
smaps and I/O counters belonging to every user.  The configuration file defines
ordered matching rules; the default groups all processes by their comm name.")))
