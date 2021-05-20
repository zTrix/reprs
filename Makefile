.PHONY: all clean

all: _reprs.c reprs.go setup.py
	python setup.py build_ext --build-lib .

_reprs.c: reprs.rl
	ragel -G2 $< -o$@

reprs.go: reprs.go.rl
	ragel -G2 -Z $< -o$@

clean:
	rm -f _reprs.c
	rm -f _reprs.so _reprs.*.so
