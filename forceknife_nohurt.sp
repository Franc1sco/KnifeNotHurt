#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>

public Plugin:myinfo =
{
	name = "SM Force knife and not hurt",
	author = "Franc1sco Steam: franug",
	description = "",
	version = "1.0",
	url = "http://steamcommunity.com/id/franug"
};

public OnPluginStart()
{
	CreateTimer(5.0, Checker, _, TIMER_REPEAT);
	
	HookEvent("player_spawn", Event_PlayerSpawn);
	
	for(new i = 1; i <= MaxClients; i++)
		if(IsClientInGame(i))
		{
			OnClientPutInServer(i);
		}
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{	
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if(GetClientTeam(client) < 2) return;
	
	new knife;
	knife = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
	if(knife == -1) GivePlayerItem(client, "weapon_knife");
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{	
	if (attacker < 0 || attacker > MaxClients || !IsClientInGame(attacker)) 
		return Plugin_Continue; 
		
		
	decl String:sWeapon[32]; 
	GetClientWeapon(attacker, sWeapon, sizeof(sWeapon)); 
	
	if (StrContains(sWeapon, "knife", false) != -1 || StrContains(sWeapon, "bayonet", false) != -1) 
	{ 
		return Plugin_Handled;
	} 
	return Plugin_Continue; 
}

public Action:Checker(Handle:timer)
{
	new knife;
	
	for(new i = 1; i <= MaxClients; i++)
		if(IsClientInGame(i) && IsPlayerAlive(i))
		{
			knife = GetPlayerWeaponSlot(i, CS_SLOT_KNIFE);
			if(knife == -1) GivePlayerItem(i, "weapon_knife");
		}
}