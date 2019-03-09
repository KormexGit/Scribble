/// @description Text typewriter-ing
///
/// @param json

var _json = argument[0];

var _typewriter_direction = _json[? "typewriter direction" ];
if ( _typewriter_direction != 0 )
{
    //Clear this JSON's events state
    ds_list_clear( _json[? "events triggered list" ] );
    ds_map_clear(  _json[? "events triggered map"  ] );
    ds_map_clear(  _json[? "events changed map"    ] );
    ds_map_clear(  _json[? "events different map"  ] );
    
    var _tw_pos   = _json[? "typewriter position" ];
    var _tw_speed = _json[? "typewriter speed"    ];
    
    #region Advance typewriter
    
    var _do_event_scan = false;
    
    switch( _json[? "typewriter method" ] )
    {
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            if ( _typewriter_direction > 0 )
            {
                _do_event_scan = true;
                var _scan_range_a = _tw_pos;
                var _scan_range_b = _tw_pos + _tw_speed;
            }
            
            var _length = _json[? "length" ];
            _tw_pos += _tw_speed;
            _tw_pos = min( _tw_pos, _length );
            
            _json[? "typewriter position"  ] = _tw_pos;
            _json[? "char fade t"          ] = ((_typewriter_direction < 0)? 1 : 0) + clamp( _tw_pos / _length, 0, 1 );
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            var _lines = _json[? "lines" ];
            
            if ( _typewriter_direction > 0 )
            {
                var _list = _json[? "lines list" ];
                if ( floor(_tw_pos) > floor(_tw_pos - _tw_speed) )
                {
                    var _line_a = _list[| floor( _tw_pos ) ];
                    var _line_b = _list[| min( floor( _tw_pos + _tw_speed ), _lines-1 ) ];
                    var _scan_range_a = _line_a[ __E_SCRIBBLE_LINE.FIRST_CHAR ];
                    var _scan_range_b = _line_b[ __E_SCRIBBLE_LINE.LAST_CHAR  ];
                    _do_event_scan = true;
                }
            }
            
            _tw_pos += _tw_speed;
            _tw_pos = min( _tw_pos, _lines );
            
            _json[? "typewriter position" ] = _tw_pos;
            _json[? "line fade t"         ] = ((_typewriter_direction < 0)? 1 : 0) + clamp( _tw_pos / _lines, 0, 1 );
        break;
        
        default:
            show_error( "Typewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_PER_CHARACTER or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false );
        break;
    }
    
    if ( _do_event_scan ) __scribble_scan_events( _json, _scan_range_a, _scan_range_b );
    
    #endregion
}