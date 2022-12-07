# Copyright (c) 2022 AccelByte Inc. All Rights Reserved.
# This is licensed software from AccelByte Inc, for limitations
# and restrictions contact your company contract manager.

SHELL := /bin/bash

ifndef CERT_TARGET_DIR
override CERT_TARGET_DIR = compose-config/certs
endif

certificate:
	docker run --rm -v ${PWD}:/workspace nginx:latest /workspace/generate-cert.sh "/workspace/$(CERT_TARGET_DIR)"