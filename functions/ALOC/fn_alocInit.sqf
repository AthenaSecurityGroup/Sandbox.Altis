//	INITIALIZE THE REQUEST QUEUE
ALOC_reqQueue = [[],[],[]];

//	DEFINE \\ LOAD COMPANY BANK BALANCE
profileNamespace getVariable ["ALOC_bankBalance", 500000];

//	ADD THE REQUEST EVENT HANDLER
"ALOC_reqPVEH" addPublicVariableEventHandler {
	params ["_pvehVar","_pvehVal"];
	_pvehVal params ["_reqType", "_reqVal"];
	ALOC_reqQueue params ["_pdrQueue", "_fdrQueue", "_vdrQueue"];

	//	PROCESS THE REQUEST, ADD IT TO THE QUEUE
	switch (toUpper _reqType) do {
		//	PLAYER DELIVERY REQUEST
		case "PDR": {_pdrQueue pushbackUnique _reqVal};
		//	RESUPPLY DELIVERY REQUEST
		case "FDR": {_fdrQueue pushbackUnique _reqVal};
		//	VEHICLE DELIVERY REQUEST
		case "VDR": {_vdrQueue pushbackUnique _reqVal};
		//	DEFAULT, ERROR
		default {_debugMsg = format ["[ALOC]:	reqPVEH default."]; ASG_DEBUG_LOG};
	};
};

//	QUEUE MONITOR. CHECKS THE ALOC QUEUE EVERY FIVE MINUTES.
ALOC_qMonitor = [] spawn {
	ALOC_qMonitorLoop = false;
	waitUntil {
		waitUntil {isNil "ALOC_logHelo"};
		{
			if (count _x > 0) then {
				switch (_forEachIndex) do {
					//	PLAYER DELIVERY REQUEST
					case 0: {call ASG_fnc_ALOCPDR};
					//	RESUPPLY DELIVERY REQUEST
					case 1: {call ASG_fnc_ALOCFDR};
					//	VEHICLE DELIVERY REQUEST
					case 2: {call ASG_fnc_ALOCVDR};
					//	DEFAULT, ERROR
					default {_debugMsg = format ["[ALOC]:	qMonitor default."]; ASG_DEBUG_LOG};
				};
			};
		} forEach ALOC_reqQueue;
		uiSleep 10;
		ALOC_qMonitorLoop
	};
};
