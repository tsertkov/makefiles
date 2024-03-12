# makefiles

Reusable Makefiles collection.

## Usage

Include base makefile with `include makefiles/Makefile.base.mk` in your Makefile.

Include additional makefiles as needed.

## List of makefiles

- `Makefile.base.mk` - base makefile
- `Makefile.logs.mk` - makefile with `logs-*` targets
- `Makefile.aws.mk` - makefile with `aws-*` targets

### Makefile.base.mk

Base makefile that must be included in your Makefile.

Targets:

- `list` - prints HELP_SCREEN variable
- `require-%` - guard asserting executable
- `assert-%` - guard asserting environment variable

Functions:

- `_announce_target` - call with `$(call _announce_target, $@)` to print target name

### Makefile.logs.mk

Logs targets:

- `logs-lambda` - tail lambda logs
- `logs-access` - CloudFront access logs with `goaccess`

## Testing

Run `make test` to ensure that all makefiles have valid syntax.

### Makefile.aws.mk

Aws target:

- `aws-cf-outputs` - print cloudformation stack outputs

Functions:

- `$(call aws_cf_output,$(STACK_NAME),$(AWS_REGION),$(OUTPUT_NAME))` - get cloudformation stack single output value
- `$(call aws_region_to_short_name,$(AWS_REGION))` - convert region full name to region code
