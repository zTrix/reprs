try:
    from setuptools import setup, Extension
except ImportError:
    from distutils.core import setup, Extension

c_ext = Extension('_reprs', sources = ['_reprs.c'])

setup(
    name='reprs',
    version='1.0.0',

    author='Wenlei Zhu',
    author_email='i@ztrix.me',
    url='https://github.com/zTrix/reprs',

    license='LICENSE.txt',
    keywords="repr reprs evals",
    description='represent string just like repr function in python',
    long_description=open('README.txt').read(),

    py_modules = ['reprs'],
    ext_modules=[c_ext],

    # Refers to test/test.py
    # test_suite='test.test',

    entry_points = {
        'console_scripts': [
            'reprs=reprs:main'
        ]
    },
    classifiers = [
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Operating System :: POSIX',
        'Operating System :: MacOS :: MacOS X',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Topic :: Software Development',
        'Topic :: System',
        'Topic :: Terminals',
        'Topic :: Utilities',
    ],
)

