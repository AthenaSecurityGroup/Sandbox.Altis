if (isServer) then {
    IndiCasualties = [];
    private _orbat = [getMissionConfig "CfgOrbat" >> "GreekBrigade"] call SimTools_ForceDeployment_fnc_parseCfgOrbat;
    output = [_orbat] call SimTools_ForceDeployment_fnc_deployForce;
//    ExecVM "HeadlessBalance.sqf";
};
