# sections = $(wildcard content/*/*.md)
thesis_source = content/content.md
thesis_filename = thesis
icse_review_source = content/papers/icse/review.md
icse_review_filename = icse-review

.PHONY: default clean build build_thesis_pdf

default: clean build

clean:
	@echo "Remove and Recreate out/"
	@rm -rf ./out
	@mkdir ./out

build: build_icse_review_pdf build_thesis_pdf clean_icse_review_pdf

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

build_icse_review_pdf:
	@echo "Build out/${icse_review_filename}.pdf"
	@pandoc \
    -f markdown+raw_tex \
		--output=out/${icse_review_filename}.pdf \
		${icse_review_source}

clean_icse_review_pdf:
	@echo "Delete out/${icse_review_filename}.pdf"
	@rm out/${icse_review_filename}.pdf
