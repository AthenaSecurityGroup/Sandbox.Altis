call ASG_fnc_initRadioFunctions;
VoN_channelData = [
	[[1,0,0,1], "Channel 06", "%UNIT_NAME", [], false],
	[[1,0.50,0,1], "Channel 07", "%UNIT_NAME", [], false],
	[[1,0.92,0,1], "Channel 08", "%UNIT_NAME", [], false],
	[[0,1,0,1], "Channel 09", "%UNIT_NAME", [], false],
	[[0,1,0.84,1], "Channel 010", "%UNIT_NAME", [], false],
	[[0,0,1,1], "Channel 011", "%UNIT_NAME", [], false],
	[[0.49,0,0.49,1], "Channel 012", "%UNIT_NAME", [], false],
	[[0,0.37,0.37,1], "Channel 013", "%UNIT_NAME", [], false],
	[[1,0,0,0.39], "Channel 014", "%UNIT_NAME", [], false],
	[[1,1,1,1], "Channel 015", "%UNIT_NAME", [], false]
];

if isServer then {
	{radioChannelCreate _x} forEach VoN_channelData;
};

if hasInterface then {
	{
		_x params ["_chID", "_chSwitches"];
		_chID enableChannel _chSwitches;
	} forEach [
		[0,[false,false]],
		[1,[false,false]],
		[2,[false,false]],
		[3,[false,true]],
		[4,[false,false]],
		[5,[true,true]]
	];
	
	radio_channelMenu = [["Radio Control",false]];
	{
		_chID = _forEachIndex + 1;
		_menuTitle = format ["Connect to Channel %1", _chID + 5];
		_assignedKey = 0;
		_subMenuName = "";
		_CMD = -5;
		_expression = "expression";
		_scriptString = format ["[%1] call VoN_ChannelProc_fnc", _chID];
		_isVisible = "1";
		_isActive = "1";
		_iconPath = "";
		_menuEntry = [_menuTitle,[_assignedKey],_subMenuName,_CMD,[[_expression,_scriptString]],_isVisible,_isActive,_iconPath];
		radio_channelMenu pushBack _menuEntry;
	} forEach VoN_channelData;
	radio_commMenuItem = [player,"radio_control",nil,nil,""] call BIS_fnc_addCommMenuItem;

	0 = [] spawn {
		VoN_Jammed = false;
		VoN_isOn = false;
		VoN_currentTxt = "";
		VoN_channelId = -1;
		waitUntil {!isNull findDisplay 46};
		VoN_dEH_keyDown = findDisplay 46 displayAddEventHandler ["KeyDown", VoN_fncDown];
		VoN_dEH_keyUp = findDisplay 46 displayAddEventHandler ["KeyUp", VoN_fncUp];
		VoN_dEH_mbDown = findDisplay 46 displayAddEventHandler ["MouseButtonDown", VoN_fncDown];
		VoN_dEH_mbUp = findDisplay 46 displayAddEventHandler ["MouseButtonUp", VoN_fncUp];
		VoN_dEH_joyButton = findDisplay 46 displayAddEventHandler ["JoystickButton", VoN_fncDown];
	};
};