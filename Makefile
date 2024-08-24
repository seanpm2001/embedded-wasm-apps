
.PHONY: all clean

APP ?= assemblyscript

all:
	-@rm apps/$(APP)/app.wasm
	cd apps/$(APP) && ./build.sh
	@cp apps/$(APP)/app.wasm ./
	wasm2c app.wasm -o wasm-app.c
	@mv wasm-app.* ./src
	@rm app.wasm

clean:
	-@rm ./src/wasm-app.*
	-@rm apps/*/app.wasm apps/*/app.wat
	-@rm -rf ./build ./.pio
	-@rm *_firmware_*.bin


### Particle helpers

DEVICE   ?= "Photon"
DEV_TYPE ?= photon

particle_compile: all
	@particle compile $(DEV_TYPE) ./src

particle_erase:
	@particle usb dfu
	@particle flash --usb tinker

particle_upload: all
	@particle flash $(DEVICE) ./src/

particle_upload_usb: particle_compile
	@particle usb dfu
	@particle flash --usb *_firmware_*.bin
	-@rm *_firmware_*.bin

particle_monitor:
	@particle serial monitor --follow

particle_run: particle_upload particle_monitor


### PlatformIO helpers

ENV     ?= esp32

pio_compile: all
	@pio run -e $(ENV)

pio_upload: all
	@pio run -e $(ENV) -t upload

pio_monitor:
	@pio device monitor --quiet

pio_run: pio_upload pio_monitor

