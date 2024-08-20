# Copyright (c) 2024 AccelByte Inc. All Rights Reserved.
# This is licensed software from AccelByte Inc, for limitations
# and restrictions contact your company contract manager.

SHELL := /bin/bash

ngrok:
	@which ngrok || (echo "ngrok is not installed" ; exit 1)
	@test -n "$(NGROK_AUTHTOKEN)" || (echo "NGROK_AUTHTOKEN is not set" ; exit 1)
	ngrok tcp 10000		# gRPC server Envoy proxy