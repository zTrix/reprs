#include <Python.h>
#include <stdio.h>
#include <stdint.h>

/* Docstrings */
static char module_docstring[] = "This module provides reprs interface for python";
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

/* Initialize the module */
PyMODINIT_FUNC init_reprs(void) {
    Py_InitModule3("_reprs", module_methods, module_docstring);
}

static char hexdigit[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

%%{
    machine reprs_fsm;

    alphtype unsigned char;
    
    need_escape = ('"' @ { *out++ = '"';  } 
                |  "'" @ { *out++ = '\'';  }
                |  '\\'@ { *out++ = '\\'; }
                | '\t' @ { *out++ = 't'; }
                | '\n' @ { *out++ = 'n'; }
                | '\r' @ { *out++ = 'r'; }
            ) > { *out++ = '\\';};

    normal = ((0x20 .. 0x7e) - need_escape) @ { *out++ = fc; };

    octet = normal | need_escape 
        | (any - normal - need_escape) @ { 
            *out++ = '\\';
            *out++ = 'x';
            *out++ = hexdigit[fc / 16];
            *out++ = hexdigit[fc % 16];
        };

    main := octet*;
}%%

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"
%% write data;
#pragma GCC diagnostic pop

static PyObject *_reprs(PyObject *self, PyObject *args, PyObject *kwargs) {
    int size;
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

    %% write init;
    %% write exec;

    PyObject * ret = PyString_FromStringAndSize(buffer, out-buffer);

    free(buffer);

    return ret;
}

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

%%{
    machine evals_fsm;

    alphtype unsigned char;

    escape = 0x5c;

    escape_sequence = escape escape @ { value = '\\'; } 
                    | escape 't'    @ { value = '\t'; }
                    | escape 'b'    @ { value = '\b'; }
                    | escape 'n'    @ { value = '\n'; }
                    | escape 'r'    @ { value = '\r'; }
                    | escape 'v'    @ { value = '\v'; }
                    | escape 'f'    @ { value = '\f'; }
                    | escape 'a'    @ { value = '\a'; }
                    | escape '"'    @ { value = '"'; }
                    | escape "'"    @ { value = '\''; }
                    | escape 'x' @ { value = 0; } (xdigit @ {
                          value = value * 16 + hexvalue[(uint32_t)(fc)];
                    }){2};

    main := |*
        any => { *out++ = fc; };
        escape_sequence => { *out++ = (uint8_t)value; };
    *|;
}%%

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"
%% write data;
#pragma GCC diagnostic pop


static PyObject *_evals(PyObject *self, PyObject *args, PyObject *kwargs) {
    int size;
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

    %% write init;
    %% write exec;

    PyObject * ret = PyString_FromStringAndSize(buffer, (char *)out-buffer);

    free(buffer);

    return ret;
}

