/*

	ASG_fnc_initADYN
	by:	Diffusion9
	
	This is the initialization function which calls the code to activate BIS Dynamic Groups on either the player,
	or the server, depending on which its run. Typically being called from init.sqf.
	
	EXEC TYPE:	call
	INPUTS: None
	OUTPUT: None

*/

//	SERVER EXEC
if (isServer) then {
	// Initializes the Dynamic Groups framework and groups led by a player at mission start will be registered
	["Initialize"] call BIS_fnc_dynamicGroups;
};

//	CLIENT EXEC
if (hasInterface) then {
	// Initializes the player/client side Dynamic Groups framework and registers the player group
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;
};
