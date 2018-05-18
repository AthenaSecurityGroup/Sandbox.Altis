/*
	ASG_fnc_initCampaignStart
	by:	Diffusion9

	Initiates the Athena Campaign Deployment system under correct conditions.

	EXEC TYPE:	Call
	INPUT:		Nothing
	OUTPUT:		Nothing
*/

//	SERVER: CHECK FOR EXISTING ACDEP STATE
private ["_ACDEPadmin"];
if (isServer) then {
	if (profileNamespace getVariable ["ACDEP_DB", []] isEqualTo []) then {
		//	NO SAVE STATE AVAILABLE, ENABLE ACDEP
		missionNamespace setVariable ["ACDEP_State", true, true];

		waitUntil {
			//	LOCATE A RANKED PLAYER FROM THE PLAYER LIST, SET AS ACDEP ADMIN
			{
				if (name _x in ["Diffusion9", "DEL-J"]) exitWith {
					_ACDEPadmin = _x
				}
			} forEach allPlayers;
			!isNil "_ACDEPadmin"
		};

		//	INITIATE ON-SCREEN GUIDANCE TEXT FOR ADMIN
		[_ACDEPadmin] remoteExec ["ASG_fnc_openCampaignUI", _ACDEPadmin];
	} else {
		//	LOADING AN EXISTING STATE
		missionNamespace setVariable ["ACDEP_State", false, true];
	};
};
