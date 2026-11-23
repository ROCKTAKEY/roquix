set -eu
export SLURM_CONF=/etc/slurm/slurm.conf
report_failure() {
    sinfo -R
    tail -n 40 /var/log/slurm*.log
}
trap 'if test "$?" -ne 0; then report_failure; fi' EXIT
for attempt in $(seq 60); do
    if sinfo -h -o %T | grep -qx idle; then break; fi
    if test "$attempt" -eq 60; then exit 1; fi
    sleep 1
done
timeout 60 srun -N1 -n1 sh -c 'grep -E "^0::/system[.]slice/slurmstepd[.]scope/job_${SLURM_JOB_ID}/" /proc/self/cgroup'
herd restart slurmd
timeout 60 srun -N1 -n1 true
