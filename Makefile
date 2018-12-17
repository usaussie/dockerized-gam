#########################
#						#
#   USAGE				#
#						#
#########################

# Use like any regular *nix Makefile.
# syntax: make <command>
# Example: make build-image-no-proxy

#########################
#						#
#   MAKEFILE VARS		#
#						#
#########################

ENV ?= dev


#########################
#						#
#   DOCKER SPECIFICS	#
#						#
#########################

# NOTE: instance may need to be restarted again if the local folders do not exist already before the first run.

build-image:
	docker build -t img-gam .

run-instance:
	docker run -it --rm \
       -v $(CURDIR)/environments/$(ENV)/mounted-volume:/root/mounted-volume/:Z \
       -v $(CURDIR)/environments/$(ENV)/auth/oauth2.txt:/opt/gam/src/oauth2.txt \
       -v $(CURDIR)/environments/$(ENV)/auth/oauth2service.json:/opt/gam/src/oauth2service.json \
       -v $(CURDIR)/environments/$(ENV)/auth/client_secrets.json:/opt/gam/src/client_secrets.json \
       -e TZ=America/New_York \
       --name instance-gam-$(ENV) \
       img-gam

#########################
#						#
#   MAINTENANCE SETS	#
#						#
#########################

prune-images:
	docker image prune --force

