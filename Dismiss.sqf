Logi animatedoor ["door_rear_source", 0, false];
Helicrew addwaypoint [(getmarkerpos "Origin"), 0];
Sleep 45;
{Logi deletevehiclecrew _x} foreach crew Logi;
Deletevehicle Logi;