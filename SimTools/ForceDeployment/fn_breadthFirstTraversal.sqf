params [
	["_tree", []],
	["_nodeCode", {}]
];

// interal queue is in scope of _nodeCode
private __queue = [_tree];

while {count __queue > 0} do {
	private _current = __queue deleteAt 0;

	{
		private _enqueue = _x call _nodeCode;

		if (count _enqueue > 0) then {
			__queue pushBack _enqueue;
		};
	} forEach _current;
};
