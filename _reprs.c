
#line 1 "reprs.rl"
#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stdio.h>
#include <stdint.h>

/* Docstrings */
static char module_docstring[] = "This module provides blazing-fast reprs and evals implementation for python\n";
static char reprs_docstring[] = "reprs function return repr(str) for string";
static char evals_docstring[] = "evals function return eval(str) for string";

/* Available functions */
static PyObject *_reprs(PyObject *self, PyObject *args, PyObject *kwargs);
static PyObject *_evals(PyObject *self, PyObject *args, PyObject *kwargs);

/* Module specification */
static PyMethodDef module_methods[] = {
    {"reprs", (PyCFunction)_reprs, METH_VARARGS | METH_KEYWORDS, reprs_docstring},
    {"evals", (PyCFunction)_evals, METH_VARARGS | METH_KEYWORDS, evals_docstring},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef reprs = {
    PyModuleDef_HEAD_INIT,
    "reprs", /* name of module */
    module_docstring, /* module documentation, may be NULL */
    -1,   /* size of per-interpreter state of the module, or -1 if the module keeps state in global variables. */
    module_methods
};

PyMODINIT_FUNC PyInit__reprs(void) {
    return PyModule_Create(&reprs);
}

static char hexdigit[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};


#line 60 "reprs.rl"


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#pragma GCC diagnostic ignored "-Wunused-const-variable"

#line 48 "_reprs.c"
static const int reprs_fsm_start = 0;
static const int reprs_fsm_first_final = 0;
static const int reprs_fsm_error = -1;

static const int reprs_fsm_en_main = 0;


#line 67 "reprs.rl"
#pragma GCC diagnostic pop

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
static PyObject *_reprs(PyObject *self, PyObject *args, PyObject *kwargs) {
    Py_ssize_t size;
    const char * str;

    static char *kwlist[] = {
        "str",
        NULL
    };

    /* Parse the input tuple */
    if (!PyArg_ParseTupleAndKeywords(args, kwargs, "s#", kwlist, &str, &size)) {
        return NULL;
    }

    if (str == NULL || size == 0) {
        Py_INCREF(Py_None);
        return Py_None;
    }

    char * buffer = (char *)malloc(size * 4);
    if (buffer == NULL) {
        return NULL;
    }
    char * out = buffer;

    uint8_t *p = (uint8_t*) str;
    uint8_t *pe = p + size;

    int cs;

    
#line 92 "_reprs.c"
	{
	cs = reprs_fsm_start;
	}

#line 102 "reprs.rl"
    
#line 99 "_reprs.c"
	{
	if ( p == pe )
		goto _test_eof;
	switch ( cs )
	{
tr0:
#line 52 "reprs.rl"
	{ 
            *out++ = '\\';
            *out++ = 'x';
            *out++ = hexdigit[(*p) / 16];
            *out++ = hexdigit[(*p) % 16];
        }
	goto st0;
tr1:
#line 47 "reprs.rl"
	{ *out++ = '\\';}
#line 44 "reprs.rl"
	{ *out++ = 't'; }
	goto st0;
tr2:
#line 47 "reprs.rl"
	{ *out++ = '\\';}
#line 45 "reprs.rl"
	{ *out++ = 'n'; }
	goto st0;
tr3:
#line 47 "reprs.rl"
	{ *out++ = '\\';}
#line 46 "reprs.rl"
	{ *out++ = 'r'; }
	goto st0;
tr4:
#line 49 "reprs.rl"
	{ *out++ = (*p); }
	goto st0;
tr5:
#line 47 "reprs.rl"
	{ *out++ = '\\';}
#line 41 "reprs.rl"
	{ *out++ = '"';  }
	goto st0;
tr6:
#line 47 "reprs.rl"
	{ *out++ = '\\';}
#line 42 "reprs.rl"
	{ *out++ = '\'';  }
	goto st0;
tr7:
#line 47 "reprs.rl"
	{ *out++ = '\\';}
#line 43 "reprs.rl"
	{ *out++ = '\\'; }
	goto st0;
st0:
	if ( ++p == pe )
		goto _test_eof0;
case 0:
#line 158 "_reprs.c"
	switch( (*p) ) {
		case 9u: goto tr1;
		case 10u: goto tr2;
		case 13u: goto tr3;
		case 34u: goto tr5;
		case 39u: goto tr6;
		case 92u: goto tr7;
	}
	if ( 32u <= (*p) && (*p) <= 126u )
		goto tr4;
	goto tr0;
	}
	_test_eof0: cs = 0; goto _test_eof; 

	_test_eof: {}
	}

#line 103 "reprs.rl"

    PyObject * ret = PyBytes_FromStringAndSize(buffer, out-buffer);

    free(buffer);

    return ret;
}
#pragma GCC diagnostic pop

static int hexvalue[] = {
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  -1, -1, -1, -1, -1, -1, -1, 10, 11, 12, 13, 14, 15, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, 10, 11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
};


#line 151 "reprs.rl"


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#pragma GCC diagnostic ignored "-Wunused-const-variable"

#line 209 "_reprs.c"
static const int evals_fsm_start = 2;
static const int evals_fsm_first_final = 2;
static const int evals_fsm_error = -1;

static const int evals_fsm_en_main = 2;


#line 158 "reprs.rl"
#pragma GCC diagnostic pop


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
static PyObject *_evals(PyObject *self, PyObject *args, PyObject *kwargs) {
    Py_ssize_t size;
    const char * str;

    static char *kwlist[] = {
        "str",
        NULL
    };

    /* Parse the input tuple */
    if (!PyArg_ParseTupleAndKeywords(args, kwargs, "s#", kwlist, &str, &size)) {
        return NULL;
    }

    if (str == NULL || size == 0) {
        Py_INCREF(Py_None);
        return Py_None;
    }

    char * buffer = (char *)malloc(size);
    if (buffer == NULL) {
        return NULL;
    }
    uint8_t * out = (uint8_t *)buffer;

    uint8_t *p = (uint8_t*) str;
    uint8_t *pe = p + size;
    uint8_t *eof = pe;

    int cs, act;

    uint8_t *ts, *te;

    int value = 0;

    
#line 259 "_reprs.c"
	{
	cs = evals_fsm_start;
	ts = 0;
	te = 0;
	act = 0;
	}

#line 199 "reprs.rl"
    
#line 269 "_reprs.c"
	{
	if ( p == pe )
		goto _test_eof;
	switch ( cs )
	{
tr0:
#line 148 "reprs.rl"
	{{p = ((te))-1;}{ *out++ = (*p); }}
	goto st2;
tr2:
#line 143 "reprs.rl"
	{
                          value = value * 16 + hexvalue[(uint32_t)((*p))];
                    }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
tr3:
#line 148 "reprs.rl"
	{te = p+1;{ *out++ = (*p); }}
	goto st2;
tr5:
#line 148 "reprs.rl"
	{te = p;p--;{ *out++ = (*p); }}
	goto st2;
tr6:
#line 141 "reprs.rl"
	{ value = '"'; }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
tr7:
#line 142 "reprs.rl"
	{ value = '\''; }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
tr8:
#line 133 "reprs.rl"
	{ value = '\\'; }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
tr9:
#line 140 "reprs.rl"
	{ value = '\a'; }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
tr10:
#line 135 "reprs.rl"
	{ value = '\b'; }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
tr11:
#line 139 "reprs.rl"
	{ value = '\f'; }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
tr12:
#line 136 "reprs.rl"
	{ value = '\n'; }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
tr13:
#line 137 "reprs.rl"
	{ value = '\r'; }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
tr14:
#line 134 "reprs.rl"
	{ value = '\t'; }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
tr15:
#line 138 "reprs.rl"
	{ value = '\v'; }
#line 149 "reprs.rl"
	{te = p+1;{ *out++ = (uint8_t)value; }}
	goto st2;
st2:
#line 1 "NONE"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof2;
case 2:
#line 1 "NONE"
	{ts = p;}
#line 363 "_reprs.c"
	if ( (*p) == 92u )
		goto tr4;
	goto tr3;
tr4:
#line 1 "NONE"
	{te = p+1;}
	goto st3;
st3:
	if ( ++p == pe )
		goto _test_eof3;
case 3:
#line 375 "_reprs.c"
	switch( (*p) ) {
		case 34u: goto tr6;
		case 39u: goto tr7;
		case 92u: goto tr8;
		case 97u: goto tr9;
		case 98u: goto tr10;
		case 102u: goto tr11;
		case 110u: goto tr12;
		case 114u: goto tr13;
		case 116u: goto tr14;
		case 118u: goto tr15;
		case 120u: goto tr16;
	}
	goto tr5;
tr16:
#line 143 "reprs.rl"
	{ value = 0; }
	goto st0;
st0:
	if ( ++p == pe )
		goto _test_eof0;
case 0:
#line 398 "_reprs.c"
	if ( (*p) < 65u ) {
		if ( 48u <= (*p) && (*p) <= 57u )
			goto tr1;
	} else if ( (*p) > 70u ) {
		if ( 97u <= (*p) && (*p) <= 102u )
			goto tr1;
	} else
		goto tr1;
	goto tr0;
tr1:
#line 143 "reprs.rl"
	{
                          value = value * 16 + hexvalue[(uint32_t)((*p))];
                    }
	goto st1;
st1:
	if ( ++p == pe )
		goto _test_eof1;
case 1:
#line 418 "_reprs.c"
	if ( (*p) < 65u ) {
		if ( 48u <= (*p) && (*p) <= 57u )
			goto tr2;
	} else if ( (*p) > 70u ) {
		if ( 97u <= (*p) && (*p) <= 102u )
			goto tr2;
	} else
		goto tr2;
	goto tr0;
	}
	_test_eof2: cs = 2; goto _test_eof; 
	_test_eof3: cs = 3; goto _test_eof; 
	_test_eof0: cs = 0; goto _test_eof; 
	_test_eof1: cs = 1; goto _test_eof; 

	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 3: goto tr5;
	case 0: goto tr0;
	case 1: goto tr0;
	}
	}

	}

#line 200 "reprs.rl"

    PyObject * ret = PyBytes_FromStringAndSize(buffer, (char *)out-buffer);

    free(buffer);

    return ret;
}
#pragma GCC diagnostic pop

