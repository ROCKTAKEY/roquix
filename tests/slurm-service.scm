(use-modules (gnu)
             (gnu system vm)
             (gnu tests)
             (guix gexp)
             (roquix services slurm))

(define config
  (plain-file "slurm.conf"
              "ClusterName=test
SlurmctldHost=komputilo
SlurmUser=slurm
AuthType=auth/slurm
CredType=cred/slurm
StateSaveLocation=/var/lib/slurm/controller
SlurmctldPidFile=/run/slurmctld/slurmctld.pid
SlurmdPidFile=/run/slurmd/slurmd.pid
SlurmdSpoolDir=/var/lib/slurm/node
ProctrackType=proctrack/cgroup
TaskPlugin=task/none
SelectType=select/cons_tres
NodeName=komputilo CPUs=1 State=UNKNOWN
PartitionName=test Nodes=komputilo Default=YES State=UP
"))

(define os
  (simple-operating-system
   (simple-service 'vm-network static-networking-service-type
                   (list (static-networking
                          (addresses (list (network-address
                                            (device "ens3")
                                            (value "10.0.2.15/24"))))
                          (provision '(networking)))))
   (simple-service 'service-test etc-service-type
                   (list (list "service-test" (local-file "slurm-service.sh"))))
   (service slurm-service-type
            (slurm-configuration (slurm-conf config)))))

(virtual-machine
 (graphic? #f)
 (cpu-count 1)
 (memory-size 1024)
 (operating-system
  (operating-system
   (inherit os)
   (file-systems (append %control-groups (operating-system-file-systems os))))))
