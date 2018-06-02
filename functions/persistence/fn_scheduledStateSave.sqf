/*
	ASG_fnc_scheduledStateSave
	by:	Diffusion9

	Runs a thread on the server that saves the base, cargo, and vehicle, vehicle cargo state.
	Can be reloaded from profileNamespace if the server shuts down.

*/

//	SAVE EVERY FOUR HOURS
persistence_SaveStateThread = [] spawn {
	waitUntil {
		uiSleep 15;
		// call ASG_fnc_saveBaseData;
		uiSleep 60;	//	14440 FOUR HOURS
	};
};
