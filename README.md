# Debugging Support for Reactive Programming with RxJS

> A summative master thesis presented for the degree of Master of Science in Engineering

## Build in Docker Container

```shell
# Once:
docker run -it --rm -v `pwd`:/data ghcr.io/swissmanu/pandoc make

# Continuously on change (requires nodemon):
nodemon --watch metadata_thesis.yml --watch "content" --ext md,tex,png --exec "docker run --rm -v `pwd`:/data ghcr.io/swissmanu/pandoc make"
```
