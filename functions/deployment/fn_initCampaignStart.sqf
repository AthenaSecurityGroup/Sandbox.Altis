/*
	ASG_fnc_initCampaignStart
	by:	Diffusion9

	Initiates the Athena Campaign Deployment system under correct conditions.
*/

//	RUN ON SERVER: CHECK FOR EXISTING STATE

_existingData = (profileNamespace getVariable "baseData");

if (!isNil {_existingData}) then {
	//	LOAD EXISTING DATA
	missionNamespace setVariable ["baseData", _existingData];
	//	SET CAMPAIGN STATE TO ACTIVE
	missionNamespace setVariable ["ASG_newCampaign", false, true];
} else {
	//	NO SAVE STATE AVAILABLE, OPEN CAMPAIGN START GUI
	missionNamespace setVariable ["ASG_newCampaign", true, true];
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
