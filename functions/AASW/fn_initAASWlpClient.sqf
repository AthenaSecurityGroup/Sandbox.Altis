/*
	ASG_fnc_initAASWlpClient
	by:	Diffusion9

	Initializes the ping tracker which tracks the position of group leaders and updates the server.

	Call on the Client.
*/

//	SETTINGS
#define AASW_TRACKER_SLEEP 10
#define AASW_TRACKER_RADIUS 2500
#define AASW_VISITED_RADIUS 250
#define AASW_BUFFER_SIZE 3
#define AASW_VISITED_CD 3
#define AASW_LOCATION_TYPES ["NameCity","NameCityCapital","NameVillage"]
#define AASW_BUILDING_TYPES ["HOUSE","BUILDING","CHURCH","CHAPEL","FUELSTATION","HOSPITAL"]
#define AAW_CIV_RESP_LOW ["I don't want to talk to you.","Leave me alone, please.","I don't have anything to say.","Please leave me alone.","Like I told the last guy: I don't have anything to say.","I've got nothing to say.","I don't have any information for you.","I've not heard anything about anything.","I'm not interested in talking to you.","You don't have any right to interrogate me.","You're not the police; I don't have to talk to you.","I don't respect your authority.","Leave me alone.","I just want to be left alone.","I don't want to be hassled.","Even if there were militia nearby, I wouldn't tell you.","If you could just leave me alone, that would be great.","I'm gonna' need you to go ahead and leave me alone now.","You're a nuisance, go away.","Go away.","Get lost.","No thanks.","Get out of here, stalker.","Not without my lawyer."]
#define AASW_RADIUS 400
#define AASW_CENSUS_DIVISOR 5
#define AASW_DEFAULT_REP 0
#define AASW_PATROL_RADIUS 100

//	INITIALIZE ARRAYS
AASW_buffer = [];
AASW_locPing = [];

//	RUN THE TRACKER THREAD
AASW_locTracker = [] spawn {
	//	BEGIN TRACKER LOOP
	waitUntil {
		sleep AASW_TRACKER_SLEEP;
		//	RUN ONLY ON GROUP LEADERS
		if (player == leader group player) then {
			//	GET NEAREST LOCATIONS
			_nearest = nearestLocations [position player, AASW_LOCATION_TYPES, AASW_TRACKER_RADIUS, position player];
			_nearest deleteRange [AASW_BUFFER_SIZE, count _nearest];
					
			//	PROCESS EACH NEAREST LOCATION
			{
				//	CHECK BUFFER, ADD AS NECESSARY
				if (text _x in AASW_buffer) then {
					//	ALREADY IN BUFFER - WITHIN VISTING RANGE?
					if (player distance (locationPosition _x) < AASW_VISITED_RADIUS) then {
						//	CHECK IF CURRENT LOCATION
						if (_x == missionNamespace getVariable ["AASW_currentLocation", locationNull]) then {
							//	CURRENT LOCATION
							//	DO NOTHING.
						} else {
							//	NEW LOCATION, ADD TO BUFFER.
							AASW_buffer pushBackUnique text _x;
							//	SET AS THE CURRENTLOCATION.
							AASW_currentLocation = _x;
							//	ADD TO LOCATION PING
							AASW_locPing pushBackUnique (locationPosition _x);
						};
					};
				} else {
					//	NEW, NOT IN BUFFER - ADD TO BUFFER
					AASW_buffer pushBackUnique text _x;
					//	ADD TO LOCATION PING
					AASW_locPing pushBackUnique (locationPosition _x);
				};
			} forEach _nearest;
			
			//	CULL OLDER ENTRIES FROM BUFFER
			{
				if (count AASW_buffer > AASW_BUFFER_SIZE) then {AASW_buffer deleteAt 0};				
			} forEach AASW_buffer;
			
			//	SEND THE PING, IF ARRAY IS NOT EMPTY.
			if (count AASW_locPing > 0) then {
				//	SEND PING
				publicVariableServer "AASW_locPing";
				//	DESTROY VARIABLE
				AASW_locPing = [];
			};
		};
		false
	};
};
