HP Envy 13 ah0003-na with Linux
===============================

I bought an HP laptop (envy 13 ah0003-na) and had some troubles making it work
with Linux, but I managed to get it running. I'm sharing here what I did.

DISCLAIMER: This worked for me, and I can not guarantee it will work for you.
Use at your own risk.

Installing Linux without crashing
=================================

I tried to install Ubuntu 18.04 LTS and the installer entered a boot loop (from
a quick try, the Ubuntu 18.10 installer had solved that, but I wanted to install
an LTS version and 18.04 is the most recent at the time of writing this). It's
possible to sidestep that by editing the GRUB command line and adding the
following kernel parameter (See 
https://askubuntu.com/questions/19486/how-do-i-add-a-kernel-boot-parameter for
details):

```
acpi_osi=""
```

(I added this after the `quiet splash` kernel options)


Being able to boot without crashing
===================================

Once you complete your install, I found the same boot crash (because the
installed system requires the same change in boot parameters). To be able to
boot each time I still needed to take the same steps that I did with the
installer (editing the grub kernel command line). To make the
change permanent, I added the parameters to `/etc/default/grub`. After playing
a bit I found that the best setup is a slightly different kernel command line:

```
$ sudo nano /etc/default/grub
```

There I edited the line that looks like
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

And changed it to
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_osi=! acpi_osi=\"Windows 2009\""
```

After that I saved, reinstalled with

```
$ sudo update-grub
```

And then I was able to reboot all time

Touchscreen support
===================

The touchscreen was not working after boot. This seems to be caused by some
slight bugs/incompatibilities between the ACPI code (some hardware description
bultin with the laptop) and the Linux ACPI implementation. To fix that I needed
to make an alternative ACPI code and load that instead of the one included with
the laptop.

WARNING: this probably may not work if your laptop is even a single bit different
to mine hardware-wise, or even if it has a different BIOS version (at the time of
writing this, mine has TODO).

So I installed the ACPI code compiler:

```
$ sudo apt install acpica-tools
``` 

And then decompiled and edited my current laptop ACPI code, resulting on the
source files that are in this repo. I then can compile those going to a clone
of this repo and running:

```
$ make
$ make install
```

The alter will require your root password. This added a `dsdt.aml` file in 
`/boot`, which contains the updated and compiled ACPI code. This code needs
to be loaded by the grubloader, but it's not a linux kernel option; this
requires an extra line in the bootloader (right after the `linux ...` line)
saying

```
acpi /boot/dsdt.aml
``` 

You can trying editing the grub2 command line again, and you may have a working
touchscreen.

To make it permanent, you can put the `grub/10_linux` script on top of the
existing `/etc/grub.d/10_linux` file and rerun `update-grub`. Note that this
script is based on my version of `grub-common` (2.02-2ubuntu8.9) so may break 
stuff if you have a different version
