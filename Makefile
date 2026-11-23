# ATLAS workspace helpers. Stack commands live in ai-inference-platform/Makefile.
.DEFAULT_GOAL := help
.PHONY: help update status

help:
	@printf '%s\n' 'ATLAS workspace commands:' \
	  '  make update  - pull this repo and fast-forward every component to its latest main' \
	  '  make status  - show branch, ahead/behind and local changes per component' \
	  'Run the platform from ai-inference-platform/ (see README.md).'

update:
	@git pull --ff-only
	@git submodule update --init
	@git submodule foreach --quiet 'git switch -q main && git pull -q --ff-only && echo "$$name: $$(git log -1 --format="%h %s")"'
	@git status --short

status:
	@git submodule foreach --quiet 'printf "%-30s %s\n" "$$name" "$$(git status -sb | head -1)"; git status --short | sed "s/^/    /"'
