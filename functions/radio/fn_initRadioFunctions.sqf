VoN_ChannelProc_fnc = {
	params ["_chID"];
	_present = (str player) in (VoN_channelData select (_chID - 1) select 3);
	if (_present) then {
		(radio_channelMenu select _chID) set [0, format ["Connect to Channel %1", _chID + 5]];
		(VoN_channelData select (_chID - 1) select 3) deleteAt ((VoN_channelData select (_chID - 1) select 3) find (str player));
		if (currentChannel isEqualTo (_chID + 5)) then {setCurrentChannel 5};
		_chID radioChannelRemove [player];
		publicVariable "VoN_channelData";
	} else {
		_chID radioChannelAdd [player];
		(VoN_channelData select (_chID - 1) select 3) pushBackUnique (str player);
		(radio_channelMenu select _chID) set [0, format ["Disconnect from Channel %1", _chID + 5]];
		setCurrentChannel (_chID + 5);
		publicVariable "VoN_channelData";
	};
};

VoN_ChannelId_fnc = {
	switch _this do {
		case localize "str_channel_global" : {["str_channel_global",0]};
		case localize "str_channel_side" : {["str_channel_side",1]};
		case localize "str_channel_command" : {["str_channel_command",2]};
		case localize "str_channel_group" : {["str_channel_group",3]};
		case localize "str_channel_vehicle" : {["str_channel_vehicle",4]};
		case localize "str_channel_direct" : {["str_channel_direct",5]};
		case "Channel 06" : {["Channel 06",6]};
		case "Channel 07" : {["Channel 07",7]};
		case "Channel 08" : {["Channel 08",8]};
		case "Channel 09" : {["Channel 09",9]};
		case "Channel 010" : {["Channel 010",10]};
		case "Channel 011" : {["Channel 011",11]};
		case "Channel 012" : {["Channel 012",12]};
		case "Channel 013" : {["Channel 013",13]};
		case "Channel 014" : {["Channel 014",14]};
		case "Channel 015" : {["Channel 015",15]};
		default {["",-1]};
	}
};

VoN_EventIn_fnc = {
	params ["_spkr"];
	playSound "in1";
	if (_spkr isEqualTo player) exitWith {true};
	_neckPos = player modelToWorld (player selectionPosition "neck");
	_VoN_srcObjStr = format ["%1_VoN", _spkrNetID];
	_VoN_srcObj = createVehicle ["Helper_Base_F", _neckpos, [], 0, "CAN_COLLIDE"];
	missionNamespace setVariable [_VoN_srcObjStr, _VoN_srcObj, false];
	_VoN_srcObj attachTo [player, [0,0,0],"Neck"];
	[_VoN_srcObj, _spkr] spawn {
		params ["_VoN_srcObj", "_spkr"];
		private ["_distance", "_staticLevel"];
		diag_log format ["radio_initFunctions:	_VoN_srcObj: 	%1", _VoN_srcObj];
		diag_log format ["radio_initFunctions:	_spkr: 			%1", _spkr];
		while {!isNull _VoN_srcObj} do {
			_distance = player distance _spkr;
			diag_log format ["radio_initFunctions:	_distance: 		%1", _distance];
			switch true do {
				case (_distance <= 200) : {_staticLevel = ["radionoise1_1", "radionoise1_2", "radionoise1_3"]};
				case (_distance >= 201 && _distance <= 400) : {_staticLevel = ["radionoise2_1", "radionoise2_2", "radionoise2_3"]};
				case (_distance >= 401 && _distance <= 800) : {_staticLevel = ["radionoise3_1", "radionoise3_2", "radionoise3_3"]};
				case (_distance >= 801) : {_staticLevel = ["radionoise4_1", "radionoise4_2", "radionoise4_3"]};
				default {_staticLevel = ["radionoise1_1", "radionoise1_2", "radionoise1_3"]};
			};
			[_VoN_srcObj, player] say3D [(selectRandom _staticLevel), 5, (random [0.80,0.90,1])];
			uiSleep 5;
		};
	};
};

VoN_EventOut_fnc = {
	params ["_spkrNetID"];
	playSound "out1";
	_VoN_srcObjStr = format ["%1_VoN", _spkrNetID];
	deleteVehicle (missionNamespace getVariable _VoN_srcObjStr);	
};

VoN_Event_fnc = {
	VoN_currentTxt = _this;
	VoN_channelId = VoN_currentTxt call VoN_ChannelId_fnc;
	VoN_data = [player call BIS_fnc_netId] + VoN_channelId;
	private _VoNreceivers = [];
	if (currentChannel isEqualTo 3) then {_VoNreceivers = units group player};
	if (currentChannel >= 6) then {_VoNreceivers = VoN_channelData select (currentChannel - 6) select 3};
	if (_VoNreceivers isEqualTo []) exitWith {true};
	[VoN_data, {
		_this params ["_spkr","_chTxt","_chID"];
		_spkrNetID = _spkr;
		_spkr = _spkr call BIS_fnc_objectFromNetId;
		if (_chID < 0) then {_spkrNetID call VoN_EventOut_fnc} else {_spkr call VoN_EventIn_fnc};
	}] remoteExec ["call", _VoNreceivers];
};

VoN_fncDown = {
	if VoN_Jammed exitWith {true};
	if ("ItemRadio" in assignedItems player && isAbleToBreathe player) then {
		if (VoN_isOn && {_this select 1 in actionKeys "NextChannel" || _this select 1 in actionKeys "PrevChannel"}) exitWith {
			playSound "clicksoft";
			true
		};
		if (!VoN_isOn) then {
			if (!isNull findDisplay 55 && !isNull findDisplay 63) then {
				VoN_isOn = true;
				ctrlText (findDisplay 63 displayCtrl 101)
				call VoN_Event_fnc;
				findDisplay 55 displayAddEventHandler ["Unload", {
					VoN_isOn = false;
					"" call VoN_Event_fnc;
				}]; 
			};
		};
		false				
	};
};

VoN_fncUp = {
	if (VoN_isOn) then {
		_ctrlText = ctrlText (findDisplay 63 displayCtrl 101);
		if (VoN_currentTxt != _ctrlText) then {
			_ctrlText call VoN_Event_fnc;
		};
	};
	false
};
