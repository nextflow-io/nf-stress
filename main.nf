nextflow.enable.dsl = 2

params.duration = '60s'
params.cpus     = 1
params.memory   = '1 GB'

process stress {
    conda 'conda-forge::stress-ng'

    cpus   params.cpus
    memory params.memory

    publishDir '.', mode: 'copy'

    output:
    path 'stress.log'

    script:
    """
    stress-ng --cpu ${task.cpus} \\
              --vm 1 --vm-bytes ${task.memory.toBytes()} --vm-hang 0 \\
              --timeout ${params.duration} \\
              --metrics-brief --verbose 2>&1 | tee stress.log
    """
}

workflow {
    stress()
}
