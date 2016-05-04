package main

var hexdigit []byte = []byte{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'}

%%{
    machine reprs_fsm;

    alphtype byte;
    
    need_escape = ('"' @ { out = append(out, '"')  } 
                |  "'" @ { out = append(out, '\'') }
                |  '\\'@ { out = append(out, '\\') }
                | '\t' @ { out = append(out, 't') }
                | '\n' @ { out = append(out, 'n') }
                | '\r' @ { out = append(out, 'r') }
            ) > { out = append(out, '\\') };

    normal = ((0x20 .. 0x7e) - need_escape) @ { out = append(out, fc); };

    octet = normal | need_escape 
        | (any - normal - need_escape) @ { 
            out = append(out, "\\x"...)
            out = append(out, hexdigit[fc / 16])
            out = append(out, hexdigit[fc % 16])
        };

    main := octet*;
}%%

%% write data;

func Reprs(data []byte) []byte {
    cs, p, pe := 0, 0, len(data)

    out := make([]byte, 0, len(data) * 4)

    %% write init;
    %% write exec;

    return out
}

var hexvalue []int32 = []int32{
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
}


%%{
    machine evals_fsm;

    alphtype byte;

    escape = 0x5c;

    escape_sequence = escape escape @ { value = '\\' }
                    | escape 't'    @ { value = '\t' }
                    | escape 'b'    @ { value = '\b' }
                    | escape 'n'    @ { value = '\n' }
                    | escape 'r'    @ { value = '\r' }
                    | escape 'v'    @ { value = '\v' }
                    | escape 'f'    @ { value = '\f' }
                    | escape 'a'    @ { value = '\a' }
                    | escape '"'    @ { value = '"'  }
                    | escape "'"    @ { value = '\'' }
                    | escape 'x' @ { value = byte(0) } (xdigit @ {
                          value = byte(int32(value) * 16 + hexvalue[(uint32)(fc)])
                    }){2};

    main := |*
        any => { out = append(out, fc) };
        escape_sequence => { out = append(out, value) };
    *|;
}%%

%% write data;

func Evals(data []byte) []byte {
    cs, p, pe, eof := 0, 0, len(data), len(data)

    ts, te := 0, 0
    _ = ts

    act := 0
    _ = act

    var value byte

    out := make([]byte, 0, len(data) * 4)

    %% write init;
    %% write exec;

    return out
}

