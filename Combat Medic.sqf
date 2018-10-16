//AI Medic Script
/* To do; try to check for casualties still in queue before restarting loop.

Mission initialization:
if (isServer) then {
    IndiCasualties = [];
};

Every AI unit initialization:
_any/everyunit addeventhandler ["Handledamage",{
    if (_this select 2 > 0.8) then {
        _unit = _this select 0;
        _unit setunconscious true;
        IndiCasualties pushBackUnique _unit;
    };
}];*/
params [
    "_medic",
    "_casualties"
];

While {alive _medic} do {
    Waituntil {
        sleep 30;
        count _casualties > 0 && {
            _casualty = _casualties select 0;
            _medic distance _casualty <= 400;
        };
    };

    While {alive _medic && {count _casualties > 0}} do {

        _casualty = _casualties select 0;
        // Mutates reference to casualty "queue".
        _casualties deleterange [0, 1];

        _medic domove (position _casualty);
        Waituntil {_medic distance _casualty < 2};
        Dostop _medic;
        _medic dowatch _casualty;
        _medic action ["HealSoldier", _casualty];
        If (alive _casualty) then {
            sleep 5;
            _casualty setdamage 0;
            _casualty setunconscious false;
            Waituntil {damage _casualty < 0.2};
            _medic setunitpos "MIDDLE";
            sleep 8;
            _medic setunitpos "AUTO";
        };
    };
    _medic dofollow (leader _medic);
};