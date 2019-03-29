all: dsdt.aml

install: /boot/dstd.aml

%.aml: %.dsl
	iasl -tc $<

/boot/dsdt.aml: dsdt.aml
	sudo cp $< $@