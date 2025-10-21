lint-nix-files:
	@out=0; \
		for i in $(find . -name '*.nix'); do \
			cat $i | nixfmt -c --filename "##$i" || out=$(( out + 1 ));  \
		done; \
		exit $out

lint: lint-nix-files

fmt:
    @find . -name '*.nix' | xargs nixfmt
