DISTCLEAN_TARGETS += clean-mans

A2X = a2x 
POD2MAN = pod2man

MAN_ASCII := $(wildcard man/*.man)
MAN_TROFF := $(MAN_ASCII:.man=.1)

%.1: %.man man/asciidoc.conf
	@echo A2X $@
	@$(A2X) -f manpage --asciidoc-opts="-f man/asciidoc.conf" $<

man: $(MAN_TROFF) $(MAN_ASCII) man/asciidoc.conf

.PHONY: clean-man
clean-man:
	rm $(MAN_TROFF)
