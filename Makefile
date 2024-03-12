include makefiles/Makefile.base.mk
include makefiles/Makefile.logs.mk
include makefiles/Makefile.aws.mk

define HELP_SCREEN
  test - run tests
endef

.PHONY: test
test:
	$(info Makefiles were loaded successfully)
	@echo -n
