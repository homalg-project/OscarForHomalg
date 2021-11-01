#
# OscarForHomalg: Use Singular via its interpreter
#
# Implementations
#

####################################
#
# global variables:
#
####################################

InstallValue( JSingularInterpreterForHomalg,
        rec(
            
            )
);

####################################
#
# initialization
#
####################################

JuliaEvalString( "using HomalgProject" );

####################################
#
# methods for operations:
#
####################################

##
InstallGlobalFunction( LaunchCAS_JSingularInterpreterForHomalg,
  function( arg )
    local s;
    
    s := rec(
             lines := "",
             errors := "",
             ## name := "JSingularInterpreter", ## using anything other than JSingular a name will screw up UpdateMacrosOfLaunchedCASs
             SendBlockingToCAS := SendBlockingToCASJSingularInterpreterForHomalg,
             SendBlockingToCAS_original := SendBlockingToCASJSingularInterpreterForHomalg,
             TerminateCAS := function( arg ) end,
             InitializeMacros := InitializeMacros,
             InitializeCASMacros := InitializeSingularMacros,
             setinvol := _Singular_SetInvolution,
             init_string := Concatenation( HOMALG_IO_Singular.init_string, ";option(notWarnSB)" ),
             pid := "of GAP",
             remove_enter := true,
             trim_display := ""
             );
    
    return s;
    
end );

HOMALG_IO_Singular.LaunchCAS := LaunchCAS_JSingularInterpreterForHomalg;

##
InstallGlobalFunction( SendBlockingToCASJSingularInterpreterForHomalg,
  function( stream, input_string )
    local result;
    
    result := Julia.HomalgProject.call_interpreter( GAPToJulia( input_string ) );
    
    stream.lines := Chomp( JuliaToGAP( IsString, result[2] ) );
    
    if result[1] then
        stream.errors := Concatenation( "error: ", JuliaToGAP( IsString, result[3] ) );
    else
        stream.errors := "";
    fi;
    
    stream.warning := JuliaToGAP( IsString, result[4] );
    
end );
