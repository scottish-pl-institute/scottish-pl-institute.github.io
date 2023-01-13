PANDOC=pandoc

start: all

SUPPRESS=>/dev/null

STATICS=$(wildcard images/*) css/default.css
PAGES_FILES=$(shell ls -1 pages | sed "s/^/pages\//" | sort)
PAGES=$(shell echo $(PAGES_FILES) | sed 's/\.[^\s]*$$/ /g' | sed 's/\.[^\s]* / /g' | sed "s/pages\///g")
PDFS=$(shell ls -1 pdfs)
BLUE=$(shell tput setaf 4)
PALEBLUE=$(shell tput setaf 12)
GREY=$(shell tput setaf 8)
BOLD=$(shell tput bold)
GREEN=$(shell tput setaf 10)
YELLOW=$(shell tput setaf 3)
PURPLE=$(shell tput setaf 5)
SGR0=$(shell tput sgr0)

$(PDFS:%=out/%): out/%: pdfs/%
	@echo '$(PALEBLUE)Copying static PDF $(BOLD)$<$(SGR0)'
	@cp $< $@

$(STATICS:%=out/%): out/%: %
	@echo '$(PALEBLUE)Copying static file $(BOLD)$<$(SGR0)'
	@mkdir -p $(@D) && cp $< $@

out:
	@mkdir out

all: out $(PAGES:%=out/%.html) $(PDFS:%=out/%) $(STATICS:%=out/%) out/index.html

preview:
	@cd out && python -m SimpleHTTPServer 8000

clean:
	@rm -rf out/* page_list.md page_list.html

page_list.md: $(PAGES_FILES)
	@echo 'Generating $(BOLD)page list$(SGR0)'
	@rm -f page_list.md
	@for post in $^; do\
          echo "$(GREY)  entry for:$(SGR0) " $$post; \
          $(PANDOC) $$post -t plain --lua-filter=page_list.lua  $(SUPPRESS);\
        done

page_list.html: page_list.md
	@echo 'Generating $(BOLD)page list HTML$(SGR0)'
	@$(PANDOC) page_list.md -o page_list.html

out/index.html: out/00-index.html
	@mv out/00-index.html out/index.html

out/%.html: pages/%.md page_list.html
	@echo "$(BOLD)`basename $(@F) .md`:$(SGR0) Generating post html"
	@cd pages \
        && $(PANDOC) --include-before-body=../page_list.html -s -T "Scottish Programming Languages Institute" \
                     --data-dir=.. -t html5 --highlight-style=tango $(<F) \
                     -o ../out/$(@F) $(SUPPRESS)
