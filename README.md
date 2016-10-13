
# reprs

reprs provides a safe and blazing-fast implementation for python `repr` and `eval` like string encoding/decoding: `reprs` and `evals`. 

Behold!

```python

>>> from reprs import reprs, evals
>>> a = "asdf;lkjs\x00\n\xff\xaafasdf"

>>> print reprs(a)
asdf;lkjs\x00\n\xff\xaafasdf

>>> evals(reprs(a)) == a
True
```

## speed test


```python
In [1]: import random
In [2]: from reprs import reprs, evals, pyreprs, pyevals

In [3]: t = ''.join(chr(random.choice(range(256))) for _ in range(1024))

In [4]: len(t)
Out[4]: 1024

In [5]: %timeit reprs(t)
100000 loops, best of 3: 3.22 µs per loop

In [6]: %timeit repr(t)
10000 loops, best of 3: 64.2 µs per loop

In [7]: %timeit pyreprs(t)
1000 loops, best of 3: 742 µs per loop

In [8]: x = reprs(t)

In [9]: len(x)
Out[9]: 2983

In [10]: %timeit evals(x)
100000 loops, best of 3: 3.68 µs per loop

In [11]: %timeit pyevals(x)
1000 loops, best of 3: 941 µs per loop

In [12]: xx = '"' + x + '"'

In [13]: %timeit eval(xx)
10000 loops, best of 3: 42.1 µs per loop

In [14]: evals(x) == t
Out [14]: True

In [15]: eval(xx) == t
Out [15]: True
```

As seen above, the speed for `reprs` vs `repr` vs `pyreprs` is roughly `200:10:1`.

The speed for `evals` vs `eval` for `pyevals` is roughly `280:20:1`.

## Safety

`evals` is implemented using pure string manipulation, don't worried about being pwned(which is a necessary concern when calling `eval`)!

## Interface

### repr related

`reprs` is the c implementation. `pyreprs` is implemented using pure python, which is slow.

 - param: `str`, any str input
 - return: `str`, the human readable representation of the input

```python
>>> from reprs import reprs, evals, pyreprs, pyevals
>>> import random
>>> t = ''.join(chr(random.choice(range(256))) for _ in range(20))
>>> t
'K\xffE\xe7\xd9\x93:\x1f\x96\xb5k/=]6\x8d-`\xae\xb4'

>>> reprs(t)
'K\\xffE\\xe7\\xd9\\x93:\\x1f\\x96\\xb5k/=]6\\x8d-`\\xae\\xb4'

>>> print reprs(t)
K\xffE\xe7\xd9\x93:\x1f\x96\xb5k/=]6\x8d-`\xae\xb4

>>> reprs(t) == pyreprs(t)
True
```


### evals related

`evals` is the c implementation, `pyevals` is implemented using pure python, which is slow.

`unreprs` is an alias for `evals`, `pyunreprs` is an alias for `pyevals`.


