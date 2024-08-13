# Copyright (c) 2022 AccelByte Inc. All Rights Reserved.
# This is licensed software from AccelByte Inc, for limitations
# and restrictions contact your company contract manager.

SHELL := /bin/bash

CERTS_DIR := certs

certificate:
	docker run --rm -u $$(id -u):$$(id -g) -v "$(PWD)":/data nginx:1.23.2 \
			/data/generate-certs.sh "/data/$(CERTS_DIR)"
