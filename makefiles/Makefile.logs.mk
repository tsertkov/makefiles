# Makefile.logs.mk
# Makefile with logs-* targets for working with logs in AWS

.PHONY: *

logs-lambda: SINCE ?= 1d
logs-lambda: FILTER ?= { $$.level = "*" }
logs-lambda: \
	require-aws \
	assert-LAMBDA_NAME_PREFIX \
	assert-LAMBDA_NAME \
	assert-SINCE \
	assert-FILTER

	$(call _announce_target, $@)
	aws logs tail \
		$(LAMBDA_NAME_PREFIX)-$(LAMBDA_NAME) \
		--format json \
		--since $(SINCE) \
		--follow \
		--filter '$(FILTER)'

logs-access-sync: LOGS_BUCKET = $(shell $(MAKE) infra-outputs | jq -r '.[] | select(.Key=="LogsBucket").Value')
logs-access-sync: \
	require-aws \
	assert-LOGS_BUCKET

	$(call _announce_target, $@)
	@aws s3 sync s3://$(LOGS_BUCKET) ./logs/$(ENV)

logs-access-show: \
	require-goaccess \
	require-find \
	require-gzcat \
	require-open \
	assert-ENV

	$(call _announce_target, $@)
	@find logs/$(ENV) -name "*.gz" | xargs gzcat | \
		goaccess \
			--log-format CLOUDFRONT \
			--date-format CLOUDFRONT \
			--time-format CLOUDFRONT \
			--output logs/$(ENV)/index.html \
	&& open logs/$(ENV)/index.html

logs-access: logs-access-sync logs-access-show
