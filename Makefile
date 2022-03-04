WORKING_DIRECTORY    = "$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))"

SEB_URL  			 = "https://github.com/Alessandro-Salerno/SalernOS-EFI-Bootloader"
KERN_URL 			 = "https://github.com/Alessandro-Salerno/SalernOS-Kernel-Private"
SEB_DIR				 = SalernOS-EFI-Bootloader
KERN_DIR			 = SalernOS-Kernel-Private
SEB_TARGET			 = bootloader
KERN_TARGET			 = kernel

ASSETS_DIR			 = Assets
OUTPUT_DIR			 = Output

MAKE				 = make
GIT  				 = git
DOCKER	 			 = docker
DOCKER_INPUT		 = Docker
DOCKER_OUTPUT 		 = salernos-buildenv
DOCKER_PLATFORM      = linux/x86_64
DOCKER_GLOBAL_ARGS   = --rm -it -v $(WORKING_DIRECTORY):/root/env --platform $(DOCKER_PLATFORM)


buildall:
	cd $(SEB_DIR)/; \
	$(MAKE) $(SEB_TARGET)
	cd $(KERN_DIR)/; \
	$(MAKE) $(KERN_TARGET)


buildimg:
	dd if=/dev/zero of=$(OUTPUT_DIR)/SalernOS.img bs=512 count=93750
	mformat -i $(OUTPUT_DIR)/SalernOS.img -f 1440 ::
	
	mmd -i     $(OUTPUT_DIR)/SalernOS.img ::/EFI
	mmd -i     $(OUTPUT_DIR)/SalernOS.img ::/EFI/BOOT
	mmd -i     $(OUTPUT_DIR)/SalernOS.img ::/openbit
	mmd -i     $(OUTPUT_DIR)/SalernOS.img ::/openbit/bin
	mmd -i     $(OUTPUT_DIR)/SalernOS.img ::/openbit/assets

	mcopy -i   $(OUTPUT_DIR)/SalernOS.img $(ASSETS_DIR)/startup.nsh             ::
	mcopy -i   $(OUTPUT_DIR)/SalernOS.img $(SEB_DIR)/x86_64/bootloader/main.efi ::/EFI/BOOT
	mcopy -i   $(OUTPUT_DIR)/SalernOS.img $(KERN_DIR)/bin/kernel.elf            ::/openbit/bin
	mcopy -i   $(OUTPUT_DIR)/SalernOS.img $(ASSETS_DIR)/kernelfont.psf          ::/openbit/assets


download:
	$(GIT) clone $(SEB_URL)
	$(GIT) clone $(KERN_URL)
	$(DOCKER) build $(DOCKER_INPUT) --platform $(DOCKER_PLATFORM) -t $(DOCKER_OUTPUT)


setup:
	@mkdir -p Output
	cd $(SEB_DIR)/; \
	$(MAKE)
	cd $(KERN_DIR)/; \
	$(MAKE) setup


enter:
	$(DOCKER) run $(DOCKER_GLOBAL_ARGS) $(DOCKER_OUTPUT)
