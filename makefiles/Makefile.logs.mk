# Makefile.logs.mk
# Makefile with logs-* targets for working with logs in AWS

.PHONY: *

logs-api: SINCE ?= 1d
logs-api: FILTER ?= { $$.httpMethod = "*" }
logs-api: \
	require-aws \
	assert-LOGS_GROUP \
	assert-SINCE \
	assert-FILTER
	$(call _announce_target, $@)
	aws logs tail \
		$(LOGS_GROUP) \
		--format json \
		--since $(SINCE) \
		--filter '$(FILTER)' \
		--follow

logs-lambda: SINCE ?= 1d
logs-lambda: FILTER ?= { $$.level = "*" }
logs-lambda: \
	require-aws \
	assert-LOGS_GROUP_PREFIX \
	assert-LAMBDA_NAME \
	assert-SINCE \
	assert-FILTER
	$(call _announce_target, $@)
	@aws logs tail \
		$(LOGS_GROUP_PREFIX)-$(LAMBDA_NAME) \
		--format json \
		--since $(SINCE) \
		--filter '$(FILTER)' \
		--follow

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
