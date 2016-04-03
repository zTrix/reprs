#!/usr/bin/env python2
#-*- coding:utf-8 -*-

import os, sys

import _reprs
from _reprs import reprs

__ALL__ = ['reprs', 'pyreprs', 'pyevals', 'pyunreprs']

def pyreprs(s, excludes=None):
    escape_chars = ['"', "'", "\\", "\t", "\n", "\r"]
    if excludes:
        for i in excludes:
            escape_chars.remove(i)
    ret = []
    for i in s:
        if i in escape_chars:
            ret.append("\\")
            if i == '\t':
                ret.append('t')
            elif i == '\n':
                ret.append('n')
            elif i == '\r':
                ret.append('r')
            else:
                ret.append(i)
        elif ord(i) < ord(' ') or ord(i) >= 0x7f:
            ret.append('\\x%s' % format(ord(i), '02x'))
        else:
            ret.append(i)
    return ''.join(ret)

def pyevals(s):
    st = 0      # 0 for normal, 1 for escape, 2 for \xXX
    ret = []
    i = 0
    while i < len(s):
        if st == 0:
            if s[i] == '\\':
                st = 1
            else:
                ret.append(s[i])
        elif st == 1:
            if s[i] in ('"', "'", "\\", "t", "n", "r"):
                if s[i] == 't':
                    ret.append('\t')
                elif s[i] == 'n':
                    ret.append('\n')
                elif s[i] == 'r':
                    ret.append('\r')
                else:
                    ret.append(s[i])
                st = 0
            elif s[i] == 'x':
                st = 2
            else:
                raise Exception('invalid repr of str %s' % s)
        else:
            num = int(s[i:i+2], 16)
            assert 0 <= num < 256
            ret.append(chr(num))
            st = 0
            i += 1
        i += 1
    return ''.join(ret)

pyunreprs = pyevals

def printreprs(inpath, outpath=None):
    if not os.path.exists(inpath):
        print >> sys.stderr, 'reprs: %s: No such file or directory'
        return 10
    fin = open(inpath, 'rb')
    if not outpath or outpath == '-':
        fout = sys.stdout
    else:
        fout = open(outpath, 'w')

    bufsize = 4096 * 10
    while True:
        buf = fin.read(bufsize)
        if len(buf) == 0:
            break
        fout.write(_reprs.reprs(buf))

    if fout.fileno() != sys.stdout.fileno():
        fout.close()

    # TODO: reimplement using c
    # _reprs.printreprs(fin.fileno(), fout.fileno())
    return 0

def usage():
    print >> sys.stderr, """usage:
    
    $ reprs infile [outfile]

options:
    
    -h, --help              help page, you are reading this now!
"""

def main():
    argv = sys.argv[1:]
    import getopt
    try:
        opts, args = getopt.getopt(argv, 'h', ['help'])
    except getopt.GetoptError as err:
        usage()
        return 10
    for o, a in opts:
        if o in ('-h', '--help'):
            usage()
            sys.exit(0)

    if len(args) < 1:
        usage()
        return 11
    inpath = args[0]
    outpath = None
    if len(args) >= 2:
        outpath = args[1]

    return printreprs(inpath, outpath)

if __name__ == '__main__':
    sys.exit(main())

