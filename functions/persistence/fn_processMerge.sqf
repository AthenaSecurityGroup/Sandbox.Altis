//	PROCESS MERGE INTO MASTER ARRAY
//	After mergeToMaster completes its initial processing, merges the items into the array.

params ["_arrIndex", "_itemAmount", "_arrTarget"];
if (_arrIndex isEqualTo []) then {
	//	IF EMPTY, PUSHBACK INTO ARRAY
	(_arrTarget select 0) pushBack _x;
	(_arrTarget select 1) pushBack _itemAmount;
} else {
	//	IF NOT EMPTY, INCREMENT
	_arrIndex = _arrIndex select 1;
	(_arrTarget select 1) set [_arrIndex, (_arrTarget select 1 select _arrIndex) + _itemAmount];
};
