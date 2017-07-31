//Entry function - calls function to spawn composition and handles composition references

private[ "_objects", "_index", "_compReference" ];
params[ "_compName" ];

if ( isNil "LAR_spawnedCompositions" ) then {
	LAR_spawnedCompositions = [];
};

_objects = _this call LAR_fnc_createComp;

{
	if !( isNil "_x" ) then {
		_objects set [ _forEachIndex, [ _forEachIndex, _x ] ];
	}else{
		_objects set [ _forEachIndex, objNull ];
	};
}forEach _objects;

_objects = _objects - [ objNull ];

_index = {
	if ( isNil "_x" ) exitWith { _forEachIndex };
}forEach LAR_spawnedCompositions;

if ( isNil "_index" ) then {
	_compReference = format[ "%1_%2", _compName, count LAR_spawnedCompositions ];
	_nul = LAR_spawnedCompositions pushBack [ _compReference, _objects ];
}else{
	_compReference = format[ "%1_%2", _compName, _index ];
	LAR_spawnedCompositions set [ _index, [ _compReference, _objects ] ];
};

_compReference