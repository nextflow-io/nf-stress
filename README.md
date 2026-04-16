# nf-stress

A minimal Nextflow pipeline to stress a task for a given duration, CPU count, and memory.
Uses [`stress-ng`](https://github.com/ColinIanKing/stress-ng) from conda-forge; the container is built on the fly by [Wave](https://seqera.io/wave/) — no local Docker image required.

## Usage

```bash
nextflow run . --duration 2m --cpus 4 --memory '2 GB'
```

### Parameters

| Param       | Default | Description                                  |
|-------------|---------|----------------------------------------------|
| `--duration`| `60s`   | How long to run the stressor (`30s`, `2m`, …)|
| `--cpus`    | `1`     | Number of CPU workers (also sets `cpus` directive) |
| `--memory`  | `1 GB`  | Memory to allocate (also sets `memory` directive)  |

The `time` directive is set to `duration + 30s` to leave scheduler headroom.

## Requirements

- Nextflow 25.10+
- Docker
