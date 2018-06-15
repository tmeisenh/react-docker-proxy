.PHONY = checkNpm package deploy startshell shell start stop rm

REQUIRED_NPM_VERSION = 6.0.1
NPM_VERSION := $(shell npm --version)

# Application Version
APP_VERSION := $(shell node -pe "require('./package.json').version")
APP_VERSION_BASH := $(shell cat package.json | grep version | head -n 1 | cut -d : -f 2 | sed -e 's/[",]//g' | tr -d '[[:space:]]')
GIT_SHA := $(shell git rev-parse HEAD)
LONG_VERSION := ${APP_VERSION}-${GIT_SHA}

HHOSTNAME := $(shell hostname)

## Docker Variables
DOCKER_NAMESPACE = tmeisenh
DOCKER_RESOURCE = react-playground
DOCKER_TAG := ${DOCKER_NAMESPACE}/${DOCKER_RESOURCE}:${LONG_VERSION}
DOCKER_NAME := $(DOCKER_RESOURCE)-${HHOSTNAME}

# The following two variables are space separated lists.
PORTS_TO_BIND = -p 8080:3000
ENV_FOR_CONTAINER = -e ENV_NAME=local -e LONG_VERSION=$(LONG_VERSION) # TODO: not sure how safe this is with unusual chars

checkNpm:
ifeq "${NPM_VERSION}" "${REQUIRED_NPM_VERSION}"
	@echo "Good news! You have the right version of npm installed."
else
	@echo "You don't have the right version of npm installed.  I'll take care of that for you."
	@npm install --global npm@${REQUIRED_NPM_VERSION}
endif

clean:
	@rm -rf build
	@rm -rf node_modules

dist: checkNpm clean
	@npm install
	@npm run build

package: 
	@echo "APP_VERSION: $(APP_VERSION)"
	@echo "APP_VERSION_BASH: $(APP_VERSION_BASH)"
	@echo "GIT_SHA: $(GIT_SHA)"
	@echo "building docker $(DOCKER_TAG)..."
	@docker build -t $(DOCKER_TAG) .
	@echo "Done."

deploy: package
	@echo docker push $(DOCKER_TAG) .

# starts a container and shells into it
startshell:
	@docker run --rm --tty --name $(DOCKER_NAME) --interactive $(PORTS_TO_BIND) $(ENV_FOR_CONTAINER) $(DOCKER_TAG) /bin/sh

# shells into a running container
shell:
	@docker exec --interactive --tty $(DOCKER_NAME) /bin/sh

start:
	@docker run --rm --detach --tty --name $(DOCKER_NAME) $(PORTS_TO_BIND) $(ENV_FOR_CONTAINER) $(DOCKER_TAG)

stop:
	@docker stop $(DOCKER_NAME)

rm:
	@docker image rmi $(DOCKER_TAG)
