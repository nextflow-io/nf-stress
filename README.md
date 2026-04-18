# nf-stress

A minimal Nextflow pipeline to stress a task for a given duration, CPU count, and memory.
Uses [`stress-ng`](https://github.com/ColinIanKing/stress-ng) from conda-forge; the container is built on the fly by [Wave](https://seqera.io/wave/) — no local Docker image required.

## Usage

```bash
nextflow run . --requestCpus 4 --requestMemory '2 GB' --requestDuration 2m
```

To request more resources than the workload actually consumes (e.g. to simulate over-provisioning), set the `usage*` params explicitly:

```bash
nextflow run . \
    --requestCpus 4 --requestMemory '4 GB' --requestDuration 5m \
    --usageCpus   2 --usageMemory   '2 GB' --usageDuration   2m
```

### Parameters

The pipeline has two parameter groups:

- **`request*`** — drive the Nextflow process directives (`cpus`, `memory`), i.e. what the scheduler allocates.
- **`usage*`** — drive the actual `stress-ng` workload, i.e. what the task really consumes. Each defaults to its matching `request*` value.

| Param               | Default              | Description                                             |
|---------------------|----------------------|---------------------------------------------------------|
| `--requestCpus`     | `1`                  | CPUs requested (sets `cpus` directive)                  |
| `--requestMemory`   | `1 GB`               | Memory requested (sets `memory` directive)              |
| `--requestDuration` | `60s`                | Default duration for `stress-ng` when `--usageDuration` is not set |
| `--usageCpus`       | `requestCpus`        | Number of CPU workers used by `stress-ng`               |
| `--usageMemory`     | `requestMemory`      | Memory actually allocated by `stress-ng`                |
| `--usageDuration`   | `requestDuration`    | How long `stress-ng` runs                               |

## Requirements

- Nextflow 25.10+
- Docker
