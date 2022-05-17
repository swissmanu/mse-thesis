# Debugging Support for Reactive Programming with RxJS

> A summative master thesis presented for the degree of Master of Science in Engineering

## Abstract

Software engineers use numerous software tools in their daily working routine. These tools help them to streamline complex and repetitive tasks. Integrated development environments bundle such utilities ready-to-hand. This way, engineers benefit from a seamless developer experience where every tool *feels* and *looks* like a part of its host application and is only a keypress away. Of course, debuggers are a vital component of this toolset.

Debuggers built into contemporary development environments are tailored to work best with programs following an imperative programming style. However, when used with different programming paradigms, such as reactive programming, these tools do not adequately assist the engineers. This is why software engineers resort to more simple debugging techniques like manual print statements instead.

This summative thesis documents the debugging techniques engineers employ to debug programs implemented using RxJS, a popular library providing reactive programming functionality for JavaScript. First, it reveals why engineers abstain from using specialized reactive debugging tools by identifying a critical success factor for such utilities: A reactive debugger must be ready-to-hand, integrating with the engineers' overall developer experience. Subsequently, the thesis illustrates the iterative research and development process of a ready-to-hand reactive debugger for Microsoft Visual Studio Code. "RxJS Debugging for Visual Studio Code" provides with *Operator Log Points* a novel reactive debugging utility. To my knowledge, this is the first reactive debugger that allows engineers to inspect RxJS applications' runtime behavior without leaving their development environment or adding manual print statements.

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
