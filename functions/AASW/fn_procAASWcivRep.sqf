/*
	ASG_fnc_procAASWcivRep
	by:	Diffusion9
	
*/

//	SETTINGS
#define AASW_TRACKER_SLEEP 5
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
