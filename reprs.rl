#include <Python.h>
#include <stdio.h>
#include <stdint.h>

/* Docstrings */
static char module_docstring[] = "This module provides reprs interface for python";
static char reprs_docstring[] = "reprs function return a repr like interface to handle str";

/* Available functions */
static PyObject *_reprs(PyObject *self, PyObject *args, PyObject *kwargs);

/* Module specification */
static PyMethodDef module_methods[] = {
    {"reprs", (PyCFunction)_reprs, METH_VARARGS | METH_KEYWORDS, reprs_docstring},
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

