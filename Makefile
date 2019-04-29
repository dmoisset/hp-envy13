all: dsdt.aml

install: /boot/dsdt.aml

%.aml: %.dsl
	iasl -tc $<

/boot/dsdt.aml: dsdt.aml
	sudo cp $< $@
