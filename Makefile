.PHONY: all clean

all: _reprs.c setup.py
	python setup.py build_ext --build-lib .

_reprs.c: reprs.rl
	ragel -G2 $< -o$@

clean:
	rm -f _reprs.c
	rm -f _reprs.so
