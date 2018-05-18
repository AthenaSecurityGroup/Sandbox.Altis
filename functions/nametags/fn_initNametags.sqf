/*
	ASG_fnc_initNametags
	by:	Diffusion9
	
	Runs an event handler that adds names above the heads of players in the indicated font type and size.
	Needs to be removed when in certain non-player-controlled views.
	
	EXEC TYPE:	Call
	INPUT:		Nothing
	OUTPUT:		Nothing
*/

nametags_handler = addMissionEventHandler ["Draw3D", {{
		_dist = (player distance _x) / 20;
		_color = getArray (configFile/'CfgInGameUI'/'SideColors'/'colorFriendly');
		_color set [3, 1 - _dist];
		drawIcon3D [
			'',
			_color,
			[
				visiblePosition _x select 0,
				visiblePosition _x select 1,
				(visiblePosition _x select 2) +
				((_x modelToWorld (
					_x selectionPosition 'head'
				)) select 2) + 0.4 + _dist / 1.5
			],
			0,
			0,
			0,
			name _x,
			2,
			0.03,
			'PuristaMedium'
		];
	} count allPlayers - [player];
}];
nametags_handler
