/*
	ASG_fnc_openCampaignUI
	by:	Diffusion9
	
	Activates the ACDEP GUI for the ranking ACDEP Admin. The admin will select the deployment location on the Map.

	EXEC TYPE:	Call
	INPUT:		0	OBJECT	ACDEP Admin
	OUTPUT:		Nothing
*/

params ["_ACDEPadmin"];
waitUntil {! (isNull _ACDEPadmin) && time > 1};

//	OPEN THE MAP AND ENABLE MAP CLICK HANDLER.
openMap true;
uiSleep 1;
[false, "", 2] call ASG_fnc_setPlayerState;
onMapSingleClick {
	onMapSingleClick "";
	openMap false;
	//	PROCESS THE SELECTED POSITION ON THE SERVER.
	[_pos] remoteExec ["ASG_fnc_getCampaignStartPos", 2];
	[true, "", 0.01] call ASG_fnc_setPlayerState;
};
