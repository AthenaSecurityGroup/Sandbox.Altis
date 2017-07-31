/*
	ASG_fnc_initAASWlpServer
	by:	Diffusion9
	"location ping server"
*/

//	SETTINGS
#define AASW_TRACKER_SLEEP 5
#define AASW_TRACKER_RADIUS 2500
#define AASW_VISITED_RADIUS 250
#define AASW_BUFFER_SIZE 3
#define AASW_VISITED_CD 3
#define AASW_LOCATION_TYPES ["NameCity","NameCityCapital","NameVillage"]
#define AASW_BUILDING_TYPES ["HOUSE","BUILDING","CHURCH","CHAPEL","FUELSTATION","HOSPITAL"]
#define AASW_CIV_RESP_LOW ["I don't want to talk to you.","Leave me alone, please.","I don't have anything to say.","Please leave me alone.","Like I told the last guy: I don't have anything to say.","I've got nothing to say.","I don't have any information for you.","I've not heard anything about anything.","I'm not interested in talking to you.","You don't have any right to interrogate me.","You're not the police; I don't have to talk to you.","I don't respect your authority.","Leave me alone.","I just want to be left alone.","I don't want to be hassled.","Even if there were militia nearby, I wouldn't tell you.","If you could just leave me alone, that would be great.","I'm gonna' need you to go ahead and leave me alone now.","You're a nuisance, go away.","Go away.","Get lost.","No thanks.","Get out of here, stalker.","Not without my lawyer."]
#define AASW_RADIUS 400
#define AASW_CENSUS_DIVISOR 5
#define AASW_DEFAULT_REP 0
#define AASW_PATROL_RADIUS 100

//	INITIALIZE ARRAYS
AASW_locDB = [];

//	HEADLESS CLIENT STATUS CHECK
activeHC = if (isNil "HC1") then {false} else {true};

//	ADD THE PVEH
"AASW_locPing" addPublicVariableEventHandler {
	params ["_var", "_data"];
	//	CHECK EACH LOCATION AGAINST THE DATABASE.
	{
		//	GATHER LOCATION
		_loc = nearestLocation [_x, ""];
		_inDB = [AASW_locDB, (text _loc)] call KK_fnc_findAll;
		//	CHECK IF IN DATABASE
		if (_inDB isEqualTo []) then {
			//	NOT IN DATABASE - FORMAT THE DATABASE ENTRY
			_locData = [
					text _loc,			//	Location Name.
					[],					//	Last Visited Time.
					AASW_DEFAULT_REP	//	Current Rep.
				];
			//	ADD TO THE DATABASE
			AASW_locDB pushBack _locData;

			if (activeHC && isMultiplayer) then {
				//	SPAWN ON HEADLESS
				//	CIVILIANS & MILITIA
				[_loc] remoteExec ["ASG_fnc_procAASWcivSpawn", HC1];
				[_loc] remoteExec ["ASG_fnc_procAASWmilSpawn", HC1];
			} else {
				//	SPAWN ON SERVER
				//	CIVILIANS & MILITIA
				AASW_scriptCivSpawn = [_loc] spawn ASG_fnc_procAASWcivSpawn;
				AASW_scriptMilSpawn = [_loc] spawn ASG_fnc_procAASWmilSpawn;
			};
		} else {
			//	DATABASE INDEX
			_locIndex = [AASW_locDB, text _loc] call KK_fnc_findAll select 0 select 0;
			diag_log format ["Location:			%1", text _loc];
			
			//	COMPARE LVT, UPDATE REPUTATION
			_currDateData = [(date select 0), dateToNumber date];
			_currDateData params ["_curYear", "_curDTN"];
			_histDateData = [_locIndex, 1] call ASG_fnc_getAASWdata;
			private ["_histDateData"];
			if (_histDateData isEqualTo []) then {_histDateData = [(date select 0), dateToNumber date]};
			_histDateData params ["_hisYear", "_hisDTN"];
			_histRepLevel = [_locIndex, 2] call ASG_fnc_getAASWdata;
			diag_log format ["_histRepLevel:	%1", _histRepLevel];
			diag_log format ["DtN _currDate:	%1", _curDTN];
			diag_log format ["DtN _histDate:	%1", _hisDTN];
			_dateDiff = (_curDTN - _hisDTN);
			diag_log format ["_dateDiff:		%1", _dateDiff];
			diag_log format ["Less than a day?:	%1", (_dateDiff <= (1 / 365))];
			private ["_newRepLevel"];
			if (_dateDiff <= (1 / 365)) then {
				_newRepLevel = _histRepLevel;
			} else {
				_repIncrease = parseNumber ((linearConversion [0,0.0821918,_dateDiff,5,0,true]) toFixed 2);
				diag_log format ["_repIncrease:		%1", _repIncrease];
				diag_log format ["_histRepLevel:	%1", _histRepLevel];
				_newRepLevel = _histRepLevel + _repIncrease;	
				diag_log format ["_newRepLevel:		%1", _newRepLevel];
			};

			//	UPDATE THE LVT
			[text _loc, 1, [(date select 0), dateToNumber date]] call ASG_fnc_setAASWdata;
			[text _loc, 2, _newRepLevel] call ASG_fnc_setAASWdata;
		};
	} forEach _data;
	AASW_locPing = [];
};
