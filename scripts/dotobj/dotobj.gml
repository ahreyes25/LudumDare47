#macro DOTOBJ_OUTPUT_DEBUG          true    //Outputs extra debug info (this is useful to check the library is working properly!)
#macro DOTOBJ_OUTPUT_WARNINGS       true    //Outputs warning messages to the console
#macro DOTOBJ_OUTPUT_LOAD_TIME      true    //Outputs the amount of time taken to load a .obj file to the console
#macro DOTOBJ_OUTPUT_COMMENTS       false   //Outputs comments found in .obj files to the console
#macro DOTOBJ_IGNORE_LINES          true    //Some .obj files use line primitives for visualisation in editors. We don't support line primitives so we usually want to ignore this data when loading
#macro DOTOBJ_OBJECTS_ARE_GROUPS    true    //Process all objects as if they were groups
#macro DOTOBJ_DEFAULT_VERTEX_COLOR  c_white //The default vertex colour if not specified in a model's source files

/// @function dotobj_init()
function dotobj_init() {
    //Create a global map to store all our material definitions
    global.__dotobj_mtl_file_loaded  = ds_map_create();
    global.__dotobj_material_library = ds_map_create();
    global.__dotobj_sprite_map       = ds_map_create();

    //Create a default material
    dotobj_ensure_material(__DOTOBJ_DEFAULT_MATERIAL_LIBRARY, __DOTOBJ_DEFAULT_MATERIAL_SPECIFIC);

    #region Internal macros

    //Always date your work!
    #macro __DOTOBJ_VERSION  "5.0.0"
    #macro __DOTOBJ_DATE     "2020/06/18"

    //Some strings to use for defaults. Change these if you so desire.
    #macro __DOTOBJ_DEFAULT_GROUP              "__dotobj_group__"
    #macro __DOTOBJ_DEFAULT_MATERIAL_LIBRARY   "__dotobj_library__"
    #macro __DOTOBJ_DEFAULT_MATERIAL_SPECIFIC  "__dotobj_material__"
    #macro __DOTOBJ_DEFAULT_MATERIAL_NAME      (__DOTOBJ_DEFAULT_MATERIAL_LIBRARY + "." + __DOTOBJ_DEFAULT_MATERIAL_SPECIFIC)
    
    //Define the vertex formats we want to use
    vertex_format_begin();
    vertex_format_add_position_3d();                          //              12
    vertex_format_add_normal();                               //            + 12
    vertex_format_add_colour();                               //            +  4
    vertex_format_add_texcoord();                             //            +  8
    global.__dotobj_pnct_vertex_format = vertex_format_end(); //vertex size = 36
	#macro VERTEX_FORMAT global.__dotobj_pnct_vertex_format
    
    #endregion
}

/// @function dotobj_class_model()
function dotobj_class_model() constructor {
    group_map	= ds_map_create();
    group_list	= ds_list_create();
	x			= 0;
	y			= 0;
	z			= 0;
	xangle		= 90;
	yangle		= 0;
	zangle		= 0;
	xscale		= 1;
	yscale		= 1;
	zscale		= 1;
    
    submit	= function() {
        var _g = 0;
		matrix_set(matrix_world, matrix_build(x, y, z, xangle, yangle, zangle, xscale, yscale, zscale));
        repeat (ds_list_size(group_list)) {
            group_map[? group_list[| _g]].submit();
            ++_g;
        }
		matrix_set(matrix_world, matrix_build_identity());
    }
	update	= function() {}
	scale	= function(_scale) {
		xscale = _scale;	
		yscale = _scale;	
		zscale = _scale;	
	}
	cleanup = function() {
		ds_map_destroy(group_map);
		ds_list_destroy(group_list);
	}
}

/// @function dotobj_class_group(model, name, line)
function dotobj_class_group(_model, _name, _line) constructor {
    //Groups collect together meshes. Most groups will only have a single mesh!
    //The DOTOBJ_OBJECTS_ARE_GROUPS macro allows for objects to be read as groups.

    var _group_map  = _model.group_map;
    var _group_list = _model.group_list;
    
    line      = _line;
    name      = _name;
    mesh_list = ds_list_create();
    
    submit = function()
    {
        var _m = 0;
        repeat(ds_list_size(mesh_list))
        {
             mesh_list[| _m].submit();
            ++_m;
        }
    }
    
    _group_map[? _name] = self;
    ds_list_add(_group_list, _name);
    
    if (DOTOBJ_OUTPUT_DEBUG) show_debug_message("dotobj_class_group(): Created group \"" + string(_name) + "\"");
}

/// @function dotobj_ensure_group(model, name, line)
function dotobj_ensure_group(_model, _name, _line) {
    if (ds_map_exists(_model.group_map, _name))
    {
        if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_ensure_group(): Warning! Group \"" + string(_name) + "\" has the same name as another group. (ln=" + string(_line) + ")");
        return _model.group_map[? _name];
    }
    else
    {
        return new dotobj_class_group(_model, _name, _line);
    }
}

/// @function dotobj_class_mesh(group, name)
function dotobj_class_mesh(_group, _name) constructor {
    //Meshes are children of groups. Meshes contain a single vertex buffer that drawn via
    //used with vertex_submit(). A mesh has an associated vertex list (really a list of
    //triangles, one vertex at a time), and an associated material. Material definitions
    //come from the .mtl library files. Material libraries (.mtl) must be loaded before
    //any .obj file that uses them.
    
    group_name		= _group.name;
    vertex_list		= ds_list_create();
    vertex_buffer	= undefined;
    material		= _name;
    
    submit = function() {
        //If a mesh failed to create a vertex buffer then it'll hold the value <undefined>
        //We need to check for this to avoid crashes
        if (vertex_buffer != undefined)
        {
            //Find the material for this mesh from the global material library
            var _material_struct = global.__dotobj_material_library[? material];
            
            //If a material cannot be found, it'll return <undefined>
            //Again, we need to check for this to avoid crashes
            if (!is_struct(_material_struct)) _material_struct = global.__dotobj_material_library[? __DOTOBJ_DEFAULT_MATERIAL_NAME];
            
            //Find the texture for the material
            var _diffuse_texture_struct = _material_struct.diffuse_map;
            
            if (is_struct(_diffuse_texture_struct))
            {
                //If the texture is a struct then that means it's using a diffuse map
                //We get the texture pointer for the texture...
                var _diffuse_texture_pointer = _diffuse_texture_struct.pointer;
                    
                //...then submit the vertex buffer using the texture
                vertex_submit(vertex_buffer, pr_trianglelist, _diffuse_texture_pointer);
            }
            else
            {
                //If the texture *isn't* a struct then that means it's using a flat diffuse colour
                //We get the texture pointer for the texture...
                var _diffuse_colour = _material_struct.diffuse;
                    
                //If the diffuse colour is undefined then render the mesh in whatever default we've set
                if (_diffuse_colour == undefined) _diffuse_colour = DOTOBJ_DEFAULT_VERTEX_COLOR;
                
                //Hijack the fog system to force the blend colour, and submit the vertex buffer
                gpu_set_fog(true, _diffuse_colour, 0, 0);
                vertex_submit(vertex_buffer, pr_trianglelist, -1);
                gpu_set_fog(false, c_fuchsia, 0, 0);
            }
        }
    }

    ds_list_add(_group.mesh_list, self);
}

/// @function dotobj_class_material(library_name, material_name)
function dotobj_class_material(_library_name, _material_name) constructor {
    //Materials are collected together in .mtl files (a.k.a. "material libraries")
    library            = _library_name;  // 0) string
    name               = _material_name; // 1) string
    ambient            = undefined;      // 2) u24 RGB
    diffuse            = undefined;      // 3) u24 RGB
    emissive           = undefined;      // 4) u24 RGB
    specular           = undefined;      // 5) u24 RGB
    specular_exp       = undefined;      // 6) f64
    transparency       = undefined;      // 7) f64
    transmission       = undefined;      // 8) u24 RGB
    illumination_model = undefined;      // 9) u8 index
    dissolve           = undefined;      //10) f64
    sharpness          = undefined;      //11) f64
    optical_density    = undefined;      //12) f64
    ambient_map        = undefined;      //13) Texture struct (see dotobj_class_texture)
    diffuse_map        = undefined;      //14) Texture struct (see dotobj_class_texture)
    emissive_map       = undefined;      //15) Texture struct (see dotobj_class_texture)
    specular_map       = undefined;      //16) Texture struct (see dotobj_class_texture)
    specular_exp_map   = undefined;      //17) Texture struct (see dotobj_class_texture)
    dissolve_map       = undefined;      //18) Texture struct (see dotobj_class_texture)
    decal_map          = undefined;      //19) Texture struct (see dotobj_class_texture)
    displacement_map   = undefined;      //20) Texture struct (see dotobj_class_texture)
    normal_map         = undefined;      //21) Texture struct (see dotobj_class_texture)
    
    var _name = _library_name + "." + _material_name;
    global.__dotobj_material_library[? _name] = self;

    if (DOTOBJ_OUTPUT_DEBUG) show_debug_message("dotobj_class_material(): Created material \"" + string(_name) + "\"");
}

/// @function dotobj_enusre_material(library_name, material_name)
function dotobj_ensure_material(_library_name, _material_name) {
    var _name = _library_name + "." + _material_name;
    if (ds_map_exists(global.__dotobj_material_library, _name))
    {
        show_debug_message("dotobj_ensure_material(): Warning! Material \"" + string(_name) + "\" already exists");
        return global.__dotobj_material_library[? _name];
    }
    else
    {
        return new dotobj_class_material(_library_name, _material_name);
    }
}

/// @function dotobj_class_texture(sprite, index, filename)
function dotobj_class_texture(_sprite, _index, _filename) constructor {
    filename          = _filename;
    sprite            = _sprite;
    index             = _index;
    pointer           = sprite_get_texture(_sprite, _index);
    blend_u           = undefined;
    blend_v           = undefined;
    bump_multiplier   = undefined;
    sharpness_boost   = undefined;
    colour_correction = undefined;
    channel           = undefined;
    scalar_range      = undefined;
    uv_clamp          = undefined;
    uv_offset         = undefined;
    uv_scale          = undefined;
    turbulence        = undefined;
    resolution        = undefined;
    invert_v          = undefined;
}

/// @function dotobj_add_external_sprite(filename)
function dotobj_add_external_sprite(_filename) {
    if (ds_map_exists(global.__dotobj_sprite_map, _filename)) return global.__dotobj_sprite_map[? _filename];

    var _sprite = sprite_add(_filename, 1, false, false, 0, 0);
    if (_sprite > 0)
    {
        global.__dotobj_sprite_map[? _filename] = _sprite;
        if (DOTOBJ_OUTPUT_DEBUG) show_debug_message("dotobj_add_external_sprite(): Loaded \"" + string(_filename) + "\" (spr=" + string(_sprite) + ")");
    }
    else
    {
        if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_add_external_sprite(): Warning! Failed to load \"" + string(_filename) + "\"");
    }

    return _sprite;
}

/// @function dotobj_material_load(library_name, buffer)
function dotobj_material_load(_library_name, _buffer) {
	/// Adds materials from an ASCII .mtl file, stored in a buffer, to the global material library.
	
    if (DOTOBJ_OUTPUT_LOAD_TIME) var _timer = get_timer();

    //We keep a list of data per line
    var _line_data_list = ds_list_create();
    
    var _material_struct = undefined;
    var _texture_struct  = undefined;

    var _meta_line = 0;

    //Start at the start of the buffer...
    var _buffer_size = buffer_get_size(_buffer);
    var _old_tell = buffer_tell(_buffer);
    buffer_seek(_buffer, buffer_seek_start, 0);

    //And let's iterate over the entire buffer, byte-by-byte
    var _line_started = false;
    var _value_read_start   = 0;
    var _i = 0;
    repeat(_buffer_size)
    {
        //Grab a value
        var _value = buffer_read(_buffer, buffer_u8);
        ++_i;
    
        if (!_line_started)
        {
            //If we haven't found a valid starting character yet (i.e. a character that has ASCII code > 32)...
        
            if (_value > 32)
            {
                //If we find a valid starting character, update the line-start position and start reading the line!
                _value_read_start = buffer_tell(_buffer)-1;
                _line_started = true;
            }
        }
        else
        {
            if ((_value == 10) || (_value == 13) || (_value == 32) || (_i >= _buffer_size))
            {
                //Put in a null character at the breaking character so we can easily read the value
                if (_i < _buffer_size) buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, 0);
            
                //Jump back to the where the value started, then read it in as a string
                buffer_seek(_buffer, buffer_seek_start, _value_read_start);
                ds_list_add(_line_data_list, buffer_read(_buffer, buffer_string));
            
                //And reset our value read position for the next value
                _value_read_start = buffer_tell(_buffer);
            
                if (_value != 32)
                {
                    //If we've reached the end of a line or the end of the buffer, process the line
                
                    if (_line_data_list[| 0] == "newmtl")
                    {
                        //Create a new material
                        var _material_name = "";
                        var _i = 1;
                        var _size = ds_list_size(_line_data_list);
                        repeat(_size-1)
                        {
                            _material_name += _line_data_list[| _i] + ((_i < _size-1)? " " : "");
                            ++_i;
                        }
                        
                        var _material_struct = dotobj_ensure_material(_library_name, _material_name);
                    }
                    else if (_line_data_list[| 0] == "#")
                    {
                        //Handle comments
                        if (DOTOBJ_OUTPUT_COMMENTS)
                        {
                            var _string = "";
                            var _i = 1;
                            var _size = ds_list_size(_line_data_list);
                            repeat(_size-1)
                            {
                                _string += _line_data_list[| _i] + ((_i < _size-1)? " " : "");
                                ++_i;
                            }
                        
                            show_debug_message("dotobj_material_load(): \"" + _string + "\"");
                        }
                    }
                    else if (!is_struct(_material_struct))
                    {
                        if (DOTOBJ_OUTPUT_WARNINGS)
                        {
                            show_debug_message("dotobj_material_load(): Warning! No material has been created (ln=" + string(_meta_line) + ")");
                        }
                    }
                    else switch(_line_data_list[| 0]) //Use the first piece of data we read to determine what kind of line this is
                    {
                        #region Colour and illumination
                    
                        case "Ka": //Ambient reflectivity
                            switch(_line_data_list[| 1])
                            {
                                case "spectral": //Spectral curve file (.rfl)
                                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): Spectral curves are not supported");
                                break;
                                case "xyz": //Using CIE-XYZ
                                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): CIE-XYZ colourspace is not currently supported");
                                break;
                                default: //Using RGB
                                    _material_struct.ambient = make_colour_rgb(255*real(_line_data_list[| 1]), 255*real(_line_data_list[| 2]), 255*real(_line_data_list[| 3]));
                                break;
                            }
                        break;
                    
                        case "Kd": //Diffuse reflectivity
                            switch(_line_data_list[| 1])
                            {
                                case "spectral": //Spectral curve file (.rfl)
                                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): Spectral curves are not supported");
                                break;
                                case "xyz": //Using CIE-XYZ
                                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): CIE-XYZ colourspace is not currently supported");
                                break;
                                default: //Using RGB
                                    _material_struct.diffuse = make_colour_rgb(255*real(_line_data_list[| 1]), 255*real(_line_data_list[| 2]), 255*real(_line_data_list[| 3]));
                                break;
                            }
                        break;
                    
                        case "Ks": //Specular reflectivity
                            switch(_line_data_list[| 1])
                            {
                                case "spectral": //Spectral curve file (.rfl)
                                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): Spectral curves are not supported");
                                break;
                                case "xyz": //Using CIE-XYZ
                                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): CIE-XYZ colourspace is not currently supported");
                                break;
                                default: //Using RGB
                                    _material_struct.specular = make_colour_rgb(255*real(_line_data_list[| 1]), 255*real(_line_data_list[| 2]), 255*real(_line_data_list[| 3]));
                                break;
                            }
                        break;
                    
                        case "Ke": //Emissive
                            switch(_line_data_list[| 1])
                            {
                                case "spectral": //Spectral curve file (.rfl)
                                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): Spectral curves are not supported");
                                break;
                                case "xyz": //Using CIE-XYZ
                                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): CIE-XYZ colourspace is not currently supported");
                                break;
                                default: //Using RGB
                                    _material_struct.emissive = make_colour_rgb(255*real(_line_data_list[| 1]), 255*real(_line_data_list[| 2]), 255*real(_line_data_list[| 3]));
                                break;
                            }
                        break;
                    
                        case "Ns": //Specular exponent
                            _material_struct.specular_exp = real(_line_data_list[| 1]);
                        break;
                    
                        case "Tr": //Transparency
                            _material_struct.transparency = real(_line_data_list[| 1]);
                        break;
                    
                        case "Tf": //Transmission filter
                            switch(_line_data_list[| 1])
                            {
                                case "spectral": break; //Spectral curve file (.rfl)
                                case "xyz":      break; //Using CIE-XYZ
                                default:
                                    _material_struct.transmission = make_colour_rgb(255*real(_line_data_list[| 1]), 255*real(_line_data_list[| 2]), 255*real(_line_data_list[| 3]));
                                break; //Using RGB
                            }
                        break;
                    
                        case "illum": //Illumination model
                            switch(_line_data_list[| 1])
                            {
                                case "0": //Colour on, ambient off
                                case "1": //Colour on, ambient on
                                case "2": //Highlight on
                                case "8": //Reflection on, raytrace off
                                case "9": //Glass on, raytrace off
                                case "10": //Cast shadows onto invisible surfaces
                                    _material_struct.illumination_model = real(_line_data_list[| 1]);
                                break;
                            
                                case "3": //Reflection on and Ray trace on
                                case "4": //Transparency: Glass on, Reflection: Ray trace on
                                case "5": //Reflection: Fresnel on and Ray trace on
                                case "6": //Transparency: Refraction on,  Reflection: Fresnel off and Ray trace on
                                case "7": //Transparency: Refraction on,  Reflection: Fresnel on and Ray trace on
                                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): Illumination model \"" + string(_line_data_list[| 1]) + "\" is not supported as it requires raytracing");
                                break;
                            
                                default:
                                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): Illumination model \"" + string(_line_data_list[| 1]) + "\" not recognised");
                                break;
                            }
                        break;
                    
                        case "d": //Dissolve
                            if (_line_data_list[| 1] == "-halo") //Dissolve is dependent on the surface orientation relative to the viewer
                            {
                                _material_struct.dissolve = -real(_line_data_list[| 1]);
                            }
                            else
                            {
                                _material_struct.dissolve = real(_line_data_list[| 1]);
                            }
                        break;
                    
                        case "sharpness": //Reflection sharpness
                            _material_struct.sharpness = real(_line_data_list[| 1]);
                        break;
                    
                        case "Ni": //Optical density
                            _material_struct.optical_density = real(_line_data_list[| 1]);
                        break;
                    
                        #endregion
                    
                        #region Texture maps
                    
                        case "map_Ka": //Ambient reflectivity map
                        case "map_Kd": //Diffuse reflectivity map
                        case "map_Ks": //Specular reflectivity map
                        case "map_Ke": //Emissive map
                        case "map_Ns": //Specular exponent map
                        case "map_d": //Dissolve map
                        case "map_decal":
                        case "decal": //Decal map (selectively replace the material color with the texture colour)
                        case "map_disp":
                        case "disp": //Displacement map
                        case "map_bump":
                        case "bump": //"Bump" map (normal map)
                            var _sprite = dotobj_add_external_sprite(_line_data_list[| 1]);
                            _texture_struct = (_sprite >= 0)? new dotobj_class_texture(_sprite, 0, _line_data_list[| 1]) : undefined;
                        
                            switch(_line_data_list[| 0])
                            {
                                case "map_Ka":    _material_struct.ambient_map      = _texture_struct; break;
                                case "map_Kd":    _material_struct.diffuse_map      = _texture_struct; break;
                                case "map_Ks":    _material_struct.specular_map     = _texture_struct; break;
                                case "map_Ke":    _material_struct.emissive_map     = _texture_struct; break;
                                case "map_Ns":    _material_struct.specular_exp_map = _texture_struct; break;
                                case "map_d":     _material_struct.dissolve_map     = _texture_struct; break;
                                case "map_decal":
                                case "decal":     _material_struct.decal_map        = _texture_struct; break;
                                case "map_disp":                                
                                case "disp":      _material_struct.ambient_map      = _texture_struct; break;
                                case "map_bump":                                
                                case "bump":      _material_struct.normal_map       = _texture_struct; break;
                            }
                        break;
                    
                        #endregion
                    
                        #region Texture map options
                    
                        case "-blenu":   //Horizontal texture blending
                        case "-blenv":   //Vertical texture blending
                            if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): Warning! Horizontal/vertical texture blending is not supported. (ln=" + string(_meta_line) + ")");
                        break;
                    
                        case "-bm":      //Bump multiplier
                        case "-boost":   //Boosts mipmapped image file sharpness (.mpc / .mps / .mpb)
                        case "-cc":      //Colour correction
                        case "-clamp":   //Clamp UVs to (0,0) -> (1,1)
                        case "-imfchan": //Channel used to create a scalar or bump texture
                        case "-mm":      //Modifies range for scalar textures
                        case "-o":       //Texture coordinate offset
                        case "-s":       //Texture coordinate scaling
                        case "-t":       //Turbulence
                        case "-texres":  //Texture resolution
                            if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): Warning! \"" + string(_line_data_list[| 0]) + "\" is not currently supported. (ln=" + string(_meta_line) + ")");
                        break;
                    
                        #endregion
                    
                        #region Reflection map
                    
                        case "refl": //Reflection map
                            if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): Warning! Reflection maps are not supported. (ln=" + string(_meta_line) + ")");
                        break;
                    
                        #endregion
                    
                        default: //Something else that we don't recognise!
                            if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_material_load(): Warning! \"" + string(_line_data_list[| 0]) + "\" is not recognised. (ln=" + string(_meta_line) + ")");
                        break;
                    }
                
                    //Once we're done with the line, clear the data out and start again
                    ds_list_clear(_line_data_list);
                    _line_started = false;
                }
            }
        }
    
        //If we've hit a \n or \r character then increment our line counter
        if ((_value == 10) || (_value == 13)) _meta_line++;
    }

    //Clean up our data structures
    ds_list_destroy(_line_data_list);

    //Return to the old tell position for the buffer
    buffer_seek(_buffer, buffer_seek_start, _old_tell);

    //If we want to report the load time, do it!
    if (DOTOBJ_OUTPUT_LOAD_TIME) show_debug_message("dotobj_material_load(): Time to load was " + string((get_timer() - _timer)/1000) + "ms");

    //Return our data
    return true;
}

/// @function dotobj_material_load_file(filename)
function dotobj_material_load_file(_filename) {
	/// Adds materials from an ASCII .mtl file to the global material library.
    if (ds_map_exists(global.__dotobj_mtl_file_loaded, _filename))
    {
        show_debug_message("dotobj_material_load_file(): \"" + _filename + "\" already loaded");
        return global.__dotobj_mtl_file_loaded[? _filename];
    }
    else
    {
        show_debug_message("dotobj_material_load_file(): Loading \"" + _filename + "\"");
        
        if (!file_exists(_filename))
        {
            show_debug_message("dotobj_material_load_file(): \"" + _filename + "\" could not be found");
        }
        else
        {
            var _buffer = buffer_load(_filename);
            var _result = dotobj_material_load(_filename, _buffer);
            buffer_delete(_buffer);
            
            global.__dotobj_mtl_file_loaded[? _filename] = _result;
            
            return _result;
        }
    }
}

/// @function dotobj_model_load(buffer, flip_texcoords, reverse_triangles)
function dotobj_model_load(_buffer, _flip_texcoords, _reverse_triangles) {
	/// Turns an ASCII .obj file, stored in a buffer, into a series of vertex buffers stored in a tree-like heirachy.
	/// @jujuadams    contact@jujuadams.com
	/// 
	/// @param buffer        Buffer to read from
	/// @param flipUVs       Whether to flip the y-axis (V-component) of the texture coordinates. This is useful to correct for DirectX / OpenGL idiosyncrasies
	/// @param reverseTris   Whether to reverse the triangle definition order to be compatible with the culling mode of your choice (clockwise/counter-clockwise)
	/// 
	/// Returns: A dotobj model (a struct)
	///          This model can be drawn using the submit() method e.g. sponza_model.submit();
	/// 
	/// 
	/// 
	/// This script uses a vertex format laid out as follows:
	/// - 3D Position
	/// - Normal
	/// - Colour
	/// - Texture Coordinate
	/// If a model has missing data, then a suitable default value will be used instead
	/// 
	/// .obj format documentation can be found here:
	/// http://paulbourke.net/dataformats/obj/
	/// 
	/// The .obj format does not natively support vertex colours; vertex colours will
	/// default to white and 100% alpha. If you use a custom exporter that supports
	/// vertex colours (such as MeshLab or MeshMixer) then vertex colours will be
	/// respected in the final vertex buffer.
	/// 
	/// Texture coordinates for .obj models will typically be normalised and in the
	/// range (0,0) -> (1,1). Please use another script to remap texture coordinates
	/// to GameMaker's atlased UV space.
	/// 
	/// This .obj load does *not* support the following features:
	/// - Smoothing groups
	/// - Map libraries
	/// - Freeform curve/surface geometry (NURBs/Bezier curves etc.)
	/// - Line primitives
	/// - Separate in-file LOD
	
    if (DOTOBJ_OUTPUT_LOAD_TIME) var _timer = get_timer();

    //Create some variables to track errors
    var _vec4_error            = false;
    var _texture_depth_error   = false;
    var _smoothing_group_error = false;
    var _map_error             = false;
    var _missing_positions     = 0;
    var _missing_normals       = 0;
    var _missing_uvs           = 0;
    var _negative_references   = 0;


    //Create some lists to store the .obj file's data
    //We fill in the 0th element because .obj vertices are 1-indexed (!)
    var _position_list = ds_list_create(); ds_list_add(_position_list, 0,0,0  );
    var _colour_list   = ds_list_create(); ds_list_add(_colour_list,   1,1,1,1);
    var _normal_list   = ds_list_create(); ds_list_add(_normal_list,   0,0,0  );
    var _texture_list  = ds_list_create(); ds_list_add(_texture_list,  0,0    );

    //Create a model for us to fill
    //We add a default group and default mesh to the model for use later during parsing
    var _model_struct     = new dotobj_class_model();
    var _group_struct     = dotobj_ensure_group(_model_struct, __DOTOBJ_DEFAULT_GROUP, 0);
    var _mesh_struct      = new dotobj_class_mesh(_group_struct, __DOTOBJ_DEFAULT_MATERIAL_NAME);
    var _mesh_vertex_list = _mesh_struct.vertex_list;

    //Handle materials
    var _material_library  = __DOTOBJ_DEFAULT_MATERIAL_LIBRARY;
    var _material_specific = __DOTOBJ_DEFAULT_MATERIAL_SPECIFIC;

    //We keep a list of data per line
    var _line_data_list = ds_list_create();

    //Metadata
    var _meta_line           = 1;
    var _meta_vertex_buffers = 0;
    var _meta_triangles      = 0;

    //Start at the start of the buffer...
    var _buffer_size = buffer_get_size(_buffer);
    var _old_tell = buffer_tell(_buffer);
    buffer_seek(_buffer, buffer_seek_start, 0);

    //And let's iterate over the entire buffer, byte-by-byte
    var _line_started = false;
    var _value_read_start   = 0;
    var _i = 0;
    repeat(_buffer_size)
    {
        //Grab a value
        var _value = buffer_read(_buffer, buffer_u8);
        ++_i;
    
        if (!_line_started)
        {
            //If we haven't found a valid starting character yet (i.e. a character that has ASCII code > 32)...
        
            if (_value > 32)
            {
                //If we find a valid starting character, update the line-start position and start reading the line!
                _value_read_start = buffer_tell(_buffer)-1;
                _line_started = true;
            }
        }
        else
        {
            if ((_value == 10) || (_value == 13) || (_value == 32) || (_i >= _buffer_size))
            {
                //Put in a null character at the breaking character so we can easily read the value
                if (_i < _buffer_size) buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, 0);
            
                //Jump back to the where the value started, then read it in as a string
                buffer_seek(_buffer, buffer_seek_start, _value_read_start);
                var _string = buffer_read(_buffer, buffer_string);
                if (_string != "") ds_list_add(_line_data_list, _string);
            
                //And reset our value read position for the next value
                _value_read_start = buffer_tell(_buffer);
            
                if (_value != 32)
                {
                    //If we've reached the end of a line or the end of the buffer, process the line
                
                    switch(_line_data_list[| 0]) //Use the first piece of data we read to determine what kind of line this is
                    {
                        case "v": //Position
                            if (ds_list_size(_line_data_list) == 1+4)
                            {
                                if (DOTOBJ_OUTPUT_WARNINGS && !_vec4_error)
                                {
                                    show_debug_message("dotobj_model_load(): Warning! 4-element vertex position data is for mathematical curves/surfaces. This is not supported. (ln=" + string(_meta_line) + ")");
                                    _vec4_error = true;
                                }
                                break;
                            }
                        
                            //Add the position to our global list of positions
                            ds_list_add(_position_list, real(_line_data_list[| 1]), real(_line_data_list[| 2]), real(_line_data_list[| 3]));
                        
                            if (ds_list_size(_line_data_list) == 1+3+3)
                            {
                                //Three extra pieces of data: this is an RGB value
                                ds_list_add(_colour_list, real(_line_data_list[| 4]), real(_line_data_list[| 5]), real(_line_data_list[| 6]), 1);
                            }
                            else if (ds_list_size(_line_data_list) == 1+3+4)
                            {
                                //Four extra pieces of data: this is an RGBA value
                                ds_list_add(_colour_list, real(_line_data_list[| 4]), real(_line_data_list[| 5]), real(_line_data_list[| 6]), real(_line_data_list[| 7]));
                            }
                            else
                            {
                                //If we have insufficient data for this line, presume this vertex is white with 100%
                                ds_list_add(_colour_list, 1, 1, 1, 1);
                            }
                        break;
                    
                        case "vt": //Texture coordinate
                            if (ds_list_size(_line_data_list) == 1+3)
                            {
                                if (DOTOBJ_OUTPUT_WARNINGS && !_texture_depth_error)
                                {
                                    switch(_line_data_list[| 3])
                                    {
                                        case "0":
                                        case "0.0":
                                        case "0.00":
                                        case "0.000":
                                        case "0.0000":
                                        case "0.00000":
                                            //Ignore texture depths of exactly 0
                                        break;
                                    
                                        default:
                                            show_debug_message("dotobj_model_load(): Warning! Texture depth is not supported; W-component of the texture coordinate will be ignored. (ln=" + string(_meta_line) + ")");
                                            _texture_depth_error = true;
                                        break;
                                    }
                                }
                            }
                        
                            //Add our UVs to the global list of UVs
                            ds_list_add(_texture_list, real(_line_data_list[| 1]), real(_line_data_list[| 2]));
                        break;
                    
                        case "vn": //Normal
                            //Add our normal to the global list of normals
                            ds_list_add(_normal_list, real(_line_data_list[| 1]), real(_line_data_list[| 2]), real(_line_data_list[| 3]));
                        break;
                    
                        case "f": //Face definition
                            var _line_data_size = ds_list_size(_line_data_list);
                        
                            //Add all triangles, vertex-by-vertex, defined by this face to the mesh's vertex list
                            _meta_triangles += _line_data_size-3;
                            var _f = 0;
                            repeat(_line_data_size-3)
                            {
                                if (!_reverse_triangles)
                                {
                                    ds_list_add(_mesh_vertex_list, _line_data_list[| 1], _line_data_list[| 2+_f], _line_data_list[| 3+_f]);
                                }
                                else
                                {
                                    ds_list_add(_mesh_vertex_list, _line_data_list[| 1], _line_data_list[| 3+_f], _line_data_list[| 2+_f]);
                                }
                            
                                ++_f;
                            }
                        break;
                    
                        case "l": //Line definition
                            if (DOTOBJ_OUTPUT_WARNINGS && !DOTOBJ_IGNORE_LINES) show_debug_message("dotobj_model_load(): Warning! Line primitives are not currently supported. (ln=" + string(_meta_line) + ")");
                        break;
                    
                        case "g": //Group definition
                            //Build the group name from all the line data
                            var _group_name = "";
                            var _i = 1;
                            var _size = ds_list_size(_line_data_list);
                            repeat(_size-1)
                            {
                                _group_name += _line_data_list[| _i] + ((_i < _size-1)? " " : "");
                                ++_i;
                            }
                        
                            //Create a new group and give it a blank mesh
                            var _group_struct     = dotobj_ensure_group(_model_struct, _group_name, _meta_line);
                            var _mesh_struct      = new dotobj_class_mesh(_group_struct, __DOTOBJ_DEFAULT_MATERIAL_NAME);
                            var _mesh_vertex_list = _mesh_struct.vertex_list;
                        break;
                    
                        case "o": //Object definition
                            //Build the object name from all the line data
                            var _group_name = "";
                            var _i = 1;
                            var _size = ds_list_size(_line_data_list);
                            repeat(_size-1)
                            {
                                _group_name += _line_data_list[| _i] + ((_i < _size-1)? " " : "");
                                ++_i;
                            }
                        
                            if (DOTOBJ_OBJECTS_ARE_GROUPS)
                            {
                                //If we want to parse objects as groups, create a new group and give it a blank mesh
                                var _group_struct     = dotobj_ensure_group(_model_struct, _group_name, _meta_line);
                                var _mesh_struct      = new dotobj_class_mesh(_group_struct, __DOTOBJ_DEFAULT_MATERIAL_NAME);
                                var _mesh_vertex_list = _mesh_struct.vertex_list;
                            }
                            else if (DOTOBJ_OUTPUT_WARNINGS)
                            {
                                show_debug_message("dotobj_model_load(): Warning! Object \"" + string(_string) + "\" found. Objects are not supported; use groups instead, or set DOTOBJ_OBJECTS_ARE_GROUPS to <true>. (ln=" + string(_meta_line) + ")");
                            }
                        break;
                    
                        case "s": //Section definition
                            if (DOTOBJ_OUTPUT_WARNINGS && !_smoothing_group_error)
                            {
                                show_debug_message("dotobj_model_load(): Warning! Smoothing groups are not currently supported. (ln=" + string(_meta_line) + ")");
                                _smoothing_group_error = true;
                            }
                        break;
                    
                        case "#": //Comments
                            if (DOTOBJ_OUTPUT_COMMENTS)
                            {
                                var _string = "";
                                var _i = 1;
                                var _size = ds_list_size(_line_data_list);
                                repeat(_size-1)
                                {
                                    _string += _line_data_list[| _i] + ((_i < _size-1)? " " : "");
                                    ++_i;
                                }
                            
                                show_debug_message("dotobj_model_load(): \"" + _string + "\"");
                            }
                        break;
                    
                        case "mtllib":
                            //Build the library name from all the line data
                            var _material_library = "";
                            var _i = 1;
                            var _size = ds_list_size(_line_data_list);
                            repeat(_size-1)
                            {
                                _material_library += _line_data_list[| _i] + ((_i < _size-1)? " " : "");
                                ++_i;
                            }
                            
                            if (DOTOBJ_OUTPUT_DEBUG) show_debug_message("dotobj_model_load(): Requires \"" + _material_library + "\"");
                            dotobj_material_load_file(_material_library);
                            if (DOTOBJ_OUTPUT_DEBUG) show_debug_message("dotobj_model_load(): Set material library to \"" + _material_library + "\"");
                        break;
                    
                        case "usemtl":
                            //Build the material name from all the line data
                            var _material_specific = "";
                            var _i = 1;
                            var _size = ds_list_size(_line_data_list);
                            repeat(_size-1)
                            {
                                _material_specific += _line_data_list[| _i] + ((_i < _size-1)? " " : "");
                                ++_i;
                            }
                        
                            //Then build a full material name from that
                            var _material_name = _material_library + "." + _material_specific;
                        
                            if ((_mesh_struct.material == __DOTOBJ_DEFAULT_MATERIAL_NAME) && ds_list_empty(_mesh_vertex_list))
                            {
                                //If our mesh's material hasn't been set and the vertex list is empty, set this mesh to use this material
                                _mesh_struct.material = _material_name;
                            }
                            else
                            {
                                //If our mesh's material has been set or we've added some vertices, create a new mesh to add triangles to
                                var _mesh_struct = new dotobj_class_mesh(_group_struct, _material_name);
                                var _mesh_vertex_list = _mesh_struct.vertex_list;
                            }
                        break;
                    
                        case "maplib":
                        case "usemap":
                            if (DOTOBJ_OUTPUT_WARNINGS && !_map_error)
                            {
                                show_debug_message("dotobj_model_load(): Warning! External texture map files are not currently supported. (ln=" + string(_meta_line) + ")");
                                _map_error = true;
                            }
                        break;
                    
                        case "shadow_obj":
                        case "trace_obj":
                            if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_model_load(): Warning! \"" + string(_line_data_list[| 0]) + "\" is an external .obj reference. This is not supported. (ln=" + string(_meta_line) + ")");
                        break;
                    
                        case "vp":
                        case "cstype":
                        case "deg":
                        case "bmat":
                        case "step":
                        case "curv":
                        case "curv2":
                        case "surf":
                        case "end":
                        case "parm":
                        case "trim":
                        case "hole":
                        case "scrv":
                        case "sp":
                        case "con":
                        case "mg":
                        case "ctech":
                        case "stech":
                        case "bsp":   //Depreciated
                        case "bzp":   //Depreciated
                        case "cdc":   //Depreciated
                        case "cdp":   //Depreciated
                        case "res":   //Depreciated
                            if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_model_load(): Warning! \"" + string(_line_data_list[| 0]) + "\" is for mathematical curves/surfaces. This is not supported. (ln=" + string(_meta_line) + ")");
                        break;
                    
                        case "lod":
                            if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_model_load(): Warning! In-file LODs are not currently supported. (ln=" + string(_meta_line) + ")");
                        break;
                    
                        case "bevel":
                        case "c_interp":
                        case "d_interp":
                            if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_model_load(): Warning! \"" + string(_line_data_list[| 0]) + "\" is a rendering attribute. This is not supported. (ln=" + string(_meta_line) + ")");
                        break;
                    
                        default: //Something else that we don't recognise!
                            if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_model_load(): Warning! \"" + string(_line_data_list[| 0]) + "\" is not recognised. (ln=" + string(_meta_line) + ")");
                        break;
                    }
                
                    //Once we're done with the line, clear the data out and start again
                    ds_list_clear(_line_data_list);
                    _line_started = false;
                }
            }
        }
    
        //If we've hit a \n or \r character then increment our line counter
        if ((_value == 10) || (_value == 13)) _meta_line++;
    }

    //Iterate over all the groups we've found
    //If we're not returning arrays, the group map should only contain one group
    var _group_map  = _model_struct.group_map;
    var _group_list = _model_struct.group_list;

    var _g = 0;
    repeat(ds_list_size(_group_list))
    {
        var _group_name = _group_list[| _g];
    
        //Find our list of faces for this group
        var _group_struct    = _group_map[? _group_name];
        var _group_line      = _group_struct.line;
        var _group_name      = _group_struct.name;
        var _group_mesh_list = _group_struct.mesh_list;
    
        var _mesh = 0;
        repeat(ds_list_size(_group_mesh_list))
        {
            var _mesh_struct      = _group_mesh_list[| _mesh];
            var _mesh_vertex_list = _mesh_struct.vertex_list;
            var _mesh_material    = _mesh_struct.material;
        
            if (DOTOBJ_OUTPUT_DEBUG) show_debug_message("dotobj_model_load(): Group \"" + _group_name + "\" (ln=" + string(_group_line) + ") mesh " + string(_mesh) + " uses material \"" + _mesh_material + "\" and has " + string(ds_list_size(_mesh_vertex_list)/3) + " triangles");
        
            //Check if this mesh is empty
            if (ds_list_size(_mesh_vertex_list) <= 0)
            {
                if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_model_load(): Warning! Group \"" + string(_group_name) + "\" mesh " + string(_mesh) + " has no triangles");
                ++_mesh;
                continue;
            }
        
            //Check if this mesh's material exists
            var _material_struct = global.__dotobj_material_library[? _mesh_material];
            if (_material_struct == undefined)
            {
                if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_model_load(): Warning! Material \"" + _mesh_material + "\" doesn't exist for group \"" + _group_name + "\" (ln=" + string(_group_line) + ") mesh " + string(_mesh) + ", using default material instead");
                _material_struct = global.__dotobj_material_library[? __DOTOBJ_DEFAULT_MATERIAL_NAME];
            }
        
            //Create a vertex buffer for this mesh
            ++_meta_vertex_buffers;
            var _vbuff = vertex_create_buffer();
            _mesh_struct.vertex_buffer = _vbuff;
            vertex_begin(_vbuff, global.__dotobj_pnct_vertex_format);
        
            //Iterate over all the vertices
            var _i = 0;
            repeat(ds_list_size(_mesh_vertex_list))
            {
                //N.B. This whole vertex decoding thing that uses strings can probably be done earlier by parsing data as it comes out of the buffer
                //     This can definitely be improved in terms of speed!
            
                //Get the vertex string, and count how many slashes it contains
                var _vertex_string = _mesh_vertex_list[| _i++];
                var _slash_count = string_count("/", _vertex_string);
            
                //Reset our lookup indexes
                var _v_index = -1;
                var _t_index = -1;
                var _n_index = -1;
            
                //Reset our vertex data
                var _vx = undefined; //X
                var _vy = undefined; //Y
                var _vz = undefined; //Z
                var _cr = 1;         //Red
                var _cg = 1;         //Green
                var _cb = 1;         //Blue
                var _ca = 1;         //Alpha
                var _tx = 0;         //U
                var _ty = 0;         //V
                var _nx = 0;         //Normal X
                var _ny = 0;         //Normal Y
                var _nz = 0;         //Normal Z
            
                if (_slash_count == 0)
                {
                    //If there are no slashes in the string, then it's a simple vertex position definition
                    _v_index = _vertex_string;
                    _t_index = -1;
                    _n_index = -1;
                }
                else if (_slash_count == 1)
                {
                    //If there's one slash in the string, then it's a position + texture coordinate definition
                    _v_index = string_copy(  _vertex_string, 1, string_pos("/", _vertex_string)-1);
                    _t_index = string_delete(_vertex_string, 1, string_pos("/", _vertex_string)  );
                    _n_index = -1;
                }
                else if (_slash_count == 2)
                {
                    //If there're two slashes in the string, then it could be one of two things...
                
                    var _double_slash_count = string_count("//", _vertex_string);
                    if (_double_slash_count == 0)
                    {
                        //If we find no double slashes then this is a position + UV + normal defintion
                        _v_index       = string_copy(  _vertex_string, 1, string_pos( "/", _vertex_string)-1);
                        _vertex_string = string_delete(_vertex_string, 1, string_pos( "/", _vertex_string)  );
                        _t_index       = string_copy(  _vertex_string, 1, string_pos( "/", _vertex_string)-1);
                        _n_index       = string_delete(_vertex_string, 1, string_pos( "/", _vertex_string)  );
                    }
                    else if (_double_slash_count == 1)
                    {
                        //If we find a single double slashes then this is a position + normal defintion
                        _vertex_string = string_replace(_vertex_string, "//", "/" );
                        _v_index       = string_copy(   _vertex_string, 1, string_pos("/", _vertex_string)-1);
                        _t_index       = -1;
                        _n_index       = string_delete( _vertex_string, 1, string_pos("/", _vertex_string)  );
                    }
                    else
                    {
                        if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_model_load(): Warning! Triangle " + string(_i) + " for group \"" + string(_group_name) + "\" has an unsupported number of slashes (" + string(_slash_count) + ")");
                        continue;
                    }
                }
                else
                {
                    if (DOTOBJ_OUTPUT_WARNINGS) show_debug_message("dotobj_model_load(): Warning! Triangle " + string(_i) + " for group \"" + string(_group_name) + "\" has an unsupported number of slashes (" + string(_slash_count) + ")");
                    continue;
                }
            
                //If we've got any blank strings set the indices to 0
                if (_v_index == "") _v_index = 0;
                if (_n_index == "") _n_index = 0;
                if (_t_index == "") _t_index = 0;
            
                _v_index = 3*floor(real(_v_index));
                _n_index = 3*floor(real(_n_index));
                _t_index = 2*floor(real(_t_index));
            
                //Some .obj file use negative references to look at data recently defined. This isn't supported!
                if ((_v_index < 0) || (_n_index < 0) || (_t_index < 0))
                {
                    ++_negative_references;
                    continue;
                }
            
                //Write the position
                _vx = _position_list[| _v_index  ]; //X
                _vy = _position_list[| _v_index+1]; //Y
                _vz = _position_list[| _v_index+2]; //Z
            
                //If we have some invalid data, log the warning, and move on to the next vertex
                //(Incidentally, if the position data is broken then the colour data will be broken too)
                if ((_vx == undefined) || (_vy == undefined) || (_vz == undefined))
                {
                    ++_missing_positions;
                    continue;
                }
            
                vertex_position_3d(_vbuff, _vx, _vy, _vz);
            
                //Write the normal
                if (_n_index >= 0)
                {
                    _nx = _normal_list[| _n_index  ]; //Normal X
                    _ny = _normal_list[| _n_index+1]; //Normal Y
                    _nz = _normal_list[| _n_index+2]; //Normal Z
                    
                    //If we have some invalid data, log the warning, then default to (0,0,0)
                    if ((_nx == undefined) || (_ny == undefined) || (_nz == undefined))
                    {
                        ++_missing_normals;
                        _nx = 0;
                        _ny = 0;
                        _nz = 0;
                    }
                }
                
                vertex_normal(_vbuff, _nx, _ny, _nz);
            
                //Write the colour
                _cr = _colour_list[| _v_index  ]*255; //Red
                _cg = _colour_list[| _v_index+1]*255; //Green
                _cb = _colour_list[| _v_index+2]*255; //Blue
                _ca = _colour_list[| _v_index+3];     //Alpha
                vertex_colour(_vbuff, make_colour_rgb(_cr, _cg, _cb), _ca);
            
                //Write the UVs
                if (_t_index >= 0) 
                {
                    _tx = _texture_list[| _t_index  ]; //U
                    _ty = _texture_list[| _t_index+1]; //V
                    
                    //If we have some invalid data, log the warning, then default to (0,0)
                    if ((_tx == undefined) || (_ty == undefined))
                    {
                        ++_missing_uvs;
                        _tx = 0;
                        _ty = 0;
                    }
                    else
                    {
                        if (_flip_texcoords) _ty = 1 - _ty;
                    }
                }
                
                vertex_texcoord(_vbuff, _tx, _ty);
            }
        
            //Once we've finished iterating over the triangles, finish our vertex buffer
            vertex_end(_vbuff);
        
            //Clean up memory for meshes
            ds_list_destroy(_mesh_vertex_list);
            _mesh_struct.vertex_list = undefined;
        
            //Move to the next mesh
            ++_mesh;
        }
    
        //Move to the next group
        ++_g;
    }

    //Clean up our data structures
    ds_list_destroy(_position_list );
    ds_list_destroy(_colour_list   );
    ds_list_destroy(_normal_list   );
    ds_list_destroy(_texture_list  );
    ds_list_destroy(_line_data_list);

    //Return to the old tell position for the buffer
    buffer_seek(_buffer, buffer_seek_start, _old_tell);

    //Report errors if we found any
    if (DOTOBJ_OUTPUT_WARNINGS)
    {
        if (_negative_references > 0) show_debug_message("dotobj_model_load(): Warning! .obj had negative position references (x" + string(_negative_references) + ")");
        if (_missing_positions   > 0) show_debug_message("dotobj_model_load(): Warning! .obj referenced missing positions (x"     + string(_missing_positions  ) + ")");
        if (_missing_normals     > 0) show_debug_message("dotobj_model_load(): Warning! .obj referenced missing normals (x"       + string(_missing_normals    ) + ")");
        if (_missing_uvs         > 0) show_debug_message("dotobj_model_load(): Warning! .obj referenced missing UVs (x"           + string(_missing_uvs        ) + ")");
    }

    //If we want to report the load time, do it!
    if (DOTOBJ_OUTPUT_LOAD_TIME) show_debug_message("dotobj_model_load(): lines=" + string(_meta_line) + ", vertex buffers=" + string(_meta_vertex_buffers) + ", triangles=" + string(_meta_triangles) + ". Time to load was " + string((get_timer() - _timer)/1000) + "ms");

    //Return our data
    return _model_struct;
}

/// @function dotobj_model_load_file(filename, flip_texcoord, reverse_triangles)
function dotobj_model_load_file(_filename, _flip_texcoords, _reverse_triangles) {
	/// Loads an ASCII .obj file from disk and turns it into a vertex buffer
	/// @jujuadams
	/// 
	/// .obj format documentation can be found here:
	/// http://paulbourke.net/dataformats/obj/
	/// 
	/// This script expects the vertex format to be setup as follows:
	/// - 3D Position
	/// - Normal
	/// - Colour
	/// - Texture Coordinate
	/// If a model has missing data, then a suitable default value will be used instead
	/// 
	/// The .obj format does not natively support vertex colours; vertex colours will
	/// default to white and 100% alpha. If you use a custom exporter that supports
	/// vertex colours (such as MeshLab or MeshMixer) then vertex colours will be
	/// respected in the final vertex buffer.
	/// 
	/// Texture coordinates for a .obj model will typically be normalised and in the
	/// range (0,0) -> (1,1). Please use another script to remap texture coordinates
	/// to GameMaker's atlased UV space.
	/// 
	/// @param filename      File to read from
	/// @param flipUVs       Whether to flip the y-axis (V-component) of the texture coordinates. This is useful to correct for DirectX / OpenGL idiosyncrasies
	/// @param reverseTris   Whether to reverse the triangle definition order to be compatible with the culling mode of your choice (clockwise/counter-clockwise)
	/// 
	/// Returns: A dotobj model (a struct)
	///          This model can be drawn using the submit() method e.g. sponza_model.submit();
	
    var _buffer = buffer_load(_filename);
    var _result = dotobj_model_load(_buffer, _flip_texcoords, _reverse_triangles);
    buffer_delete(_buffer);

    return _result;
}