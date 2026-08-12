##############################################################################
# Run:
#    make
#    make start
#
# Go to:
#
#     http://localhost:3000
#
##############################################################################
# SETUP MAKE
#
## Defensive settings for make: https://tech.davis-hansson.com/p/make/
SHELL:=bash
.ONESHELL:
# for Makefile debugging purposes add -x to the .SHELLFLAGS
.SHELLFLAGS:=-eu -o pipefail -O inherit_errexit -c
.SILENT:
.DELETE_ON_ERROR:
MAKEFLAGS+=--warn-undefined-variables
MAKEFLAGS+=--no-builtin-rules

# Colors
# OK=Green, warn=yellow, error=red
ifeq ($(TERM),)
# no colors if not in terminal
	MARK_COLOR=
	OK_COLOR=
	WARN_COLOR=
	ERROR_COLOR=
	NO_COLOR=
else
	MARK_COLOR=`tput setaf 6`
	OK_COLOR=`tput setaf 2`
	WARN_COLOR=`tput setaf 3`
	ERROR_COLOR=`tput setaf 1`
	NO_COLOR=`tput sgr0`
endif

##############################################################################

# Top-level targets
.PHONY: all
all: develop

.PHONY: develop
develop:    	## Runs missdev in the local project (mrs.developer.json should be present)
	npx -p mrs-developer missdev --config=jsconfig.json --output=packages --fetch-https
	NODE_OPTIONS="--max-old-space-size=16384" pnpm install

.PHONY: install
install:		## Install project and add-ons
	NODE_OPTIONS="--max-old-space-size=16384" pnpm install

.PHONY: build
build:			## Build frontend
	NODE_OPTIONS="--max-old-space-size=16384" pnpm build

.PHONY: bundlewatch
bundlewatch:
	pnpm exec bundlewatch --config .bundlewatch.config.json

.PHONY: start
start:			## Start frontend
	NODE_OPTIONS="--max-old-space-size=16384" pnpm start

.PHONY: relstorage
relstorage:		## Start frontend w/ RelStorage Plone Backend
	NODE_OPTIONS="--max-old-space-size=16384" RAZZLE_DEV_PROXY_API_PATH=http://localhost:8080/Plone pnpm start

.PHONY: staging
staging:		## Start frontend w/ Staging Plone Backend
	NODE_OPTIONS="--max-old-space-size=16384" RAZZLE_API_PATH=https://staging.example.com RAZZLE_INTERNAL_API_PATH=https://staging.example.com pnpm start

.PHONY: demo
demo:		## Start frontend w/ Demo Plone Backend
	NODE_OPTIONS="--max-old-space-size=16384" RAZZLE_API_PATH=https://demo.example.com RAZZLE_INTERNAL_API_PATH=https://demo.example.com pnpm start

.PHONY: cypress
cypress:		## Run Cypress acceptance tests (uses baseUrl from cypress.config.js)
	pnpm exec cypress run --config-file cypress.config.js

.PHONY: cypress-open
cypress-open:		## Open Cypress interactive test runner
	pnpm exec cypress open --config-file cypress.config.js

.PHONY: help
help:			## Show this help.
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"
	head -n 14 Makefile
