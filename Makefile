# sections = $(wildcard content/*/*.md)
thesis_source = content/content.md
thesis_filename = thesis

.PHONY: default clean build build_thesis_pdf

default: clean build

clean:
	@echo "Remove and Recreate out/"
	@rm -rf ./out
	@mkdir ./out

build: build_thesis_pdf

build_thesis_pdf:
	@echo "Build out/${thesis_filename}.pdf"
	@pandoc \
    --template=./templates/thesis.tex \
    --lua-filter=lib/lua-filters/include-files/include-files.lua \
    --metadata=version=${VERSION} \
    --metadata-file=./metadata_thesis.yml \
    -f markdown+raw_tex \
    --citeproc \
    --listings \
    --standalone \
		--output=out/${thesis_filename}.pdf \
		${thesis_source}
