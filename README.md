# Debugging Support for Reactive Programming with RxJS

> A summative master thesis presented for the degree of Master of Science in Engineering

## PDF Access

This master thesis was published in the official [Eastern Switzerland University of Applied Sciences (OST) eprints](https://eprints.ost.ch/id/eprint/1031/) repository. It is further available via this Git repositories [Releases](https://github.com/swissmanu/mse-thesis/releases) page.

## Guides

### Build in Docker Container

```shell
# Once:
docker run -it --rm -v `pwd`:/data ghcr.io/swissmanu/pandoc make

# Continuously on change (requires nodemon):
nodemon --watch metadata_thesis.yml --watch "content" --ext md,tex,png --exec "docker run --rm -v `pwd`:/data ghcr.io/swissmanu/pandoc make"
```
