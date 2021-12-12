# Debugging Support for Reactive Programming with RxJS

> A summative master thesis presented for the degree of Master of Science in Engineering

## Build in Docker Container

```shell
# Once:
docker run -it --rm -v `pwd`:/data ghcr.io/swissmanu/pandoc make

# Continously on change (requires nodemon):
nodemon --watch "content" --ext md,tex --exec "docker run --rm -v `pwd`:/data ghcr.io/swissmanu/pandoc make
```
