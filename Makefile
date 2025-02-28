RFLAGS="-C link-arg=-s"

build: lint rhea

lint:
	@cargo fmt --all
	@cargo clippy --fix --allow-dirty --allow-staged

rhea: contracts/rhea
	$(call local_build_wasm,rhea,rhea)

count:
	@tokei ./contracts/rhea/src/ --files

release:
	$(call build_release_wasm,rhea,rhea)

clean:
	cargo clean
	rm -rf res/

define local_build_wasm
	$(eval PACKAGE_NAME := $(1))
	$(eval WASM_NAME := $(2))

	@mkdir -p res
	@rustup target add wasm32-unknown-unknown
	@cargo near build --manifest-path ./contracts/${PACKAGE_NAME}/Cargo.toml --no-docker --no-abi
	@cp target/near/${WASM_NAME}/$(WASM_NAME).wasm ./res/$(WASM_NAME).wasm
endef

define build_release_wasm
	$(eval PACKAGE_NAME := $(1))
	$(eval WASM_NAME := $(2))

	@mkdir -p res
	@rustup target add wasm32-unknown-unknown
	@cargo near build --manifest-path ./contracts/${PACKAGE_NAME}/Cargo.toml
	@cp target/near/${WASM_NAME}/$(WASM_NAME).wasm ./res/$(WASM_NAME)_release.wasm
endef