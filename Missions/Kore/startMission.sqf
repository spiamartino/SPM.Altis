/*
	Kore mission run.
*/
if(!isDedicated) exitWith {};

//Waiting for squads
while{koreSquadCount < 2} do {
	if(isNull koreNorth && isNull koreSouth) exitWith {
		koreMissionFilling = false;
		koreSquadCount = 0;
		publicVariable "koreMissionFilling";
		publicVariable "koreSquadCount";
	};
	if(!isNull koreNorth) then {
		["Waiting for a second squad to start the match","hint",koreNorth,false] call BIS_fnc_MP;
	};
	if(!isNull koreSouth) then {
		["Waiting for a second squad to start the match","hint",koreSouth,false] call BIS_fnc_MP;
	};
	sleep 2;
};
["Second squad found. You may now deploy to the battlefield.","hint", koreNorth] call BIS_fnc_MP;
["Second squad found. You may now deploy to the battlefield.","hint", koreSouth] call BIS_fnc_MP;
[["deploy"],"fnc_queryClient",koreNorth,false] call BIS_fnc_MP;
[["deploy"],"fnc_queryClient",koreSouth,false] call BIS_fnc_MP;
koreMissionFilling = false;
publicVariable "koreMissionFilling";
//max squads, start the mission

koreMissionInProgress = true;
publicVariable "koreMissionInProgress";

//waiting for squads to be ready

_squad1Ready = false;
_squad2Ready = false;
while{!_squad1Ready || !_squad2Ready} do {
	if(isNull koreNorth && isNull koreSouth) exitWith {
		opforMission = "";
		blueforMission = "";
		koreNorth = grpNull;
		koreSouth = grpNull;
		koreSquadCount = 0;
		publicVariable "opforMission";
		publicVariable "blueforMission";
	}; 
	if(isNull koreNorth) exitWith {
		[[grpNull, koreSouth],"fnc_returnToBase"] call BIS_fnc_MP;
		opforMission = "";
		blueforMission = "";
		koreNorth = grpNull;
		koreSouth = grpNull;
		koreSquadCount = 0;
		publicVariable "opforMission";
		publicVariable "blueforMission";
		
	};
	if(isNull koreSouth) exitWith {
		[[grpNull, koreNorth],"fnc_returnToBase"] call BIS_fnc_MP;
		opforMission = "";
		blueforMission = "";
		koreNorth = grpNull;
		koreSouth = grpNull;
		koreSquadCount = 0;
		publicVariable "opforMission";
		publicVariable "blueforMission";
		
	};
	[["ready"],"fnc_queryClient",koreNorth, false] call bis_fnc_MP;
	[["ready"],"fnc_queryClient",koreSouth, false] call bis_fnc_MP;	
	_count = 0;
	_squad = units koreNorth;
	while{_count < count _squad} do {
		_player = _squad select _count;
		_squad1Ready = true;
		if(!(_player in playersReady)) then {
			_squad1Ready = false;
		};
		_count = _count + 1;
	};
	_count = 0;
	_squad = units koreSouth;
	while{_count < count _squad} do{
		_player = _squad select _count;
		_squad2Ready = true;
		if(!(_player in playersReady)) then {
			_squad2Ready = false;
		};
		_count = _count + 1;
	};
	if(koreNorth in playersReady) then {
		_squad1Ready = true;
		["Your team is ready","hint",koreNorth, false] call BIS_fnc_MP;
	};
	if(koreSouth in playersReady) then {
		_squad2Ready = true;
		["Your team is ready","hint",koreSouth, false] call BIS_fnc_MP;
	};
	sleep 2;
};
playersReady = [];
[["reset"],"fnc_queryClient",koreNorth,false] call bis_fnc_MP;
[["reset"],"fnc_queryClient",koreSouth,false] call bis_fnc_MP;

[[false], "fnc_freezePlayer", koreSouth, false] call BIS_fnc_MP;
[[false], "fnc_freezePlayer", koreNorth, false] call BIS_fnc_MP;

[["Standard",["Mission Started!","All players ready. GO! GO! GO!"]],"BIS_fnc_showNotification",koreNorth,false] call BIS_fnc_MP;
[["Standard",["Mission Started!","All players ready. GO! GO! GO!"]],"BIS_fnc_showNotification",koreSouth,false] call BIS_fnc_MP;

[[],"fnc_koreFlag",koreNorth, false] call bis_fnc_MP;
[[],"fnc_koreFlag",koreSouth, false] call bis_fnc_MP;
//mission run
while{koreMissionInProgress} do {
	sleep 2;
	if(isNull koreNorth || isNull koreSouth) then {
		koreMissionInProgress = false;
	};
};

[[],"fnc_missionCompleted",koreNorth,false] call BIS_fnc_MP;
[[],"fnc_missionCompleted",koreSouth,false] call BIS_fnc_MP;

koreNorth = grpNull;
koreSouth = grpNull;
koreSquadCount = 0;


