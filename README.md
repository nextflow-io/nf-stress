# nf-stress

A minimal Nextflow pipeline to stress a task for a given duration, CPU count, and memory.
Uses [`stress-ng`](https://github.com/ColinIanKing/stress-ng) wrapped with [`cpulimit`](https://github.com/opsengine/cpulimit) (both from conda-forge); the container is built on the fly by [Wave](https://seqera.io/wave/) — no local Docker image required.

## Usage

```bash
nextflow run . --requestCpus 4 --requestMemory '2 GB' --requestDuration 2m
```

To request more resources than the workload actually consumes (e.g. to simulate over-provisioning), set the `usage*` params explicitly. `usageCpus` accepts fractional values (e.g. `0.3` = 30% of one core, `1.5` = 1.5 cores):

```bash
nextflow run . \
    --requestCpus 4 --requestMemory '4 GB' --requestDuration 5m \
    --usageCpus 1.5 --usageMemory '2 GB'  --usageDuration 2m
```

### Parameters

The pipeline has two parameter groups:

- **`request*`** — drive the Nextflow process directives (`cpus`, `memory`), i.e. what the scheduler allocates.
- **`usage*`** — drive the actual workload, i.e. what the task really consumes. Each defaults to its matching `request*` value.

| Param               | Default              | Description                                             |
|---------------------|----------------------|---------------------------------------------------------|
| `--requestCpus`     | `1`                  | CPUs requested (sets `cpus` directive, integer)         |
| `--requestMemory`   | `1 GB`               | Memory requested (sets `memory` directive)              |
| `--requestDuration` | `60s`                | Default duration when `--usageDuration` is not set      |
| `--usageCpus`       | `requestCpus`        | CPU cores actually consumed (supports fractions)        |
| `--usageMemory`     | `requestMemory`      | Memory actually allocated                               |
| `--usageDuration`   | `requestDuration`    | How long the workload runs                              |

### How fractional CPU usage works

`stress-ng` is wrapped with `cpulimit --limit=N --include-children`, where `N = usageCpus × 100`. cpulimit throttles the whole process tree (including stress-ng's `--vm` worker) via SIGSTOP/SIGCONT, so the observed CPU usage tracks `usageCpus` accurately regardless of how many internal workers stress-ng spawns.

## Requirements

- Nextflow 25.10+
- Docker
