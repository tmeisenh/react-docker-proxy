.PHONY = package deploy startshell shell start stop rm

# Application Version
APP_VERSION := $(shell cat package.json | grep version | head -n 1 | cut -d : -f 2 | sed -e 's/[",]//g' | tr -d '[[:space:]]')
GIT_SHA := $(shell git rev-parse HEAD)
#export LONG_VERSION := ${APP_VERSION}-${GIT_SHA}
export LONG_VERSION = local

clean:
	@rm -rf build
	@rm -rf node_modules
	@docker-compose rm --force

package: 
	@echo "APP_VERSION: $(APP_VERSION)"
	@echo "GIT_SHA: $(GIT_SHA)"
	@LONG_VERSION=$(LONG_VERSION) docker-compose up --build
	@echo "Done."

deploy: package
	@echo "docker push ???"
