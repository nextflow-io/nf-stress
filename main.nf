params.requestCpus     = 1
params.requestDuration = '60s'
params.requestMemory   = '1 GB'

params.usageCpus     = params.requestCpus
params.usageDuration = params.requestDuration
params.usageMemory   = params.requestMemory

process stress {
    conda 'conda-forge::stress-ng conda-forge::cpulimit'

    cpus   params.requestCpus
    memory params.requestMemory

    publishDir '.', mode: 'copy'

    output:
    path 'stress.log'

    script:
    def usageMemoryBytes = (params.usageMemory instanceof nextflow.util.MemoryUnit
        ? params.usageMemory
        : new nextflow.util.MemoryUnit(params.usageMemory.toString())).toBytes()
    def usageCpusDouble = params.usageCpus as double
    def cpuLimitPct     = (usageCpusDouble * 100) as int
    def cpuWorkers      = Math.max(1, Math.ceil(usageCpusDouble) as int)
    """
    cpulimit --limit=${cpuLimitPct} --include-children -- \\
        stress-ng --cpu ${cpuWorkers} \\
                  --vm 1 --vm-bytes ${usageMemoryBytes} --vm-hang 0 \\
                  --timeout ${params.usageDuration} \\
                  --metrics-brief --verbose 2>&1 | tee stress.log
    """
}

workflow {
    stress()
}
