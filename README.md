# ecl-challenge

## Build instructions

```
docker build . -t ecl-license
```

## Execution instructions
- validate:
```
docker run --rm  --mount type=bind,source="$(pwd)",target=/share ecl-license  validate [key_to_check] [file:optional]
```
- get:
```
docker run --rm  --mount type=bind,source="$(pwd)",target=/share ecl-license  validate [key_to_check] [file:optional]
```

##  disclaimers

1. I did several assumptions to avoid asking to clarify some FRs
2. I'm not all handling potential failures, time constraint.
