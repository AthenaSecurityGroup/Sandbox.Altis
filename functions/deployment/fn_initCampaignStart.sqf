/*
	ASG_fnc_initCampaignStart
	by:	Diffusion9

	Initiates the Athena Campaign Deployment system under correct conditions.
*/

//	RUN ON SERVER: CHECK FOR EXISTING STATE
_existingData = (profileNamespace getVariable "baseData");
_existingPlayerData = (profileNamespace getVariable "ASG_playerDatabase");

//	SET ACTIVE PLAYER DATABASE FROM PROFILE SAVED DATA
if (!isNil{_existingPlayerData}) then {ASG_playerDatabase = _existingPlayerData};

//	LOAD BASE DATABASE
if (!isNil {_existingData}) then {
	//	SET ACTIVE BASEDATA TO SAVED BASEDATA
	baseData = _existingData;
	//	LOAD BASE DATA
	call ASG_fnc_loadBaseData;
} else {
	//	NO SAVE STATE AVAILABLE, OPEN CAMPAIGN START GUI
	//	RUN UNTIL A RANKED PLAYER CAN BE LOCATED:
	private ["_campaignAdmin"];
	waitUntil {
		allPlayers findIf {
			_playerObj = _x;
			_playerName = (name _x);
			_playerDBAdminIndex = (ASG_playerDatabase findIf {_x select 0 == _playerName && _x select 2 == 99});
			if (_playerDBAdminIndex != -1) then {
				_campaignAdmin = _playerObj;
			};
		};
		uiSleep 5;
		!isNil {_campaignAdmin}
	};
	//	INITIATE ON-SCREEN GUIDANCE TEXT FOR ADMIN
	[_campaignAdmin] remoteExec ["ASG_fnc_openCampaignUI", _campaignAdmin];	
};
