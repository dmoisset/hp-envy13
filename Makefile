all: dsdt.aml

install: /boot/dstd.aml

%.aml: %.dsl
	iasl -tc $<

/boot/dstd.aml: dsdt.aml
	sudo cp $< $@