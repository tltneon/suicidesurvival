AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
resource.AddWorkshop("1584405300")

for k, v in pairs(file.Find("sound/footsteps_human/*", "GAME")) do
	resource.AddFile(Sound("sound/footsteps_human/"..v))
	util.PrecacheSound("footsteps_human/"..v)
end

for k, v in pairs(file.Find("sound/footsteps_shrub/*", "GAME")) do
	resource.AddFile(Sound("sound/footsteps_shrub/"..v))
	util.PrecacheSound("footsteps_shrub/"..v)
end

-- resource.AddFile("sound/taunts_suicider/yalala.wav")
util.PrecacheSound( "taunts_suicider/yalala.wav" )

resource.AddFile("sound/boing.wav")
util.PrecacheSound( "boing.wav" )

resource.AddFile("sound/surprised.wav")
util.PrecacheSound( "surprised.wav" )

resource.AddFile("sound/violin_down.wav")
util.PrecacheSound( "violin_down.wav" )

resource.AddFile("sound/violin_up.wav")
util.PrecacheSound( "violin_up.wav" )

sound.Add( {
	name = "yalala",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 95, 110 },
	sound = "taunts_suicider/yalala.wav"
} )

ammoPos = ammoPos or {}
function GM:Initialize()
	timer.Simple(1, function()
		local ent = ents.FindByClass("item_ammo_crossbow")
		for _, _ent in pairs( ent ) do
			local entity = ents.Create("ss_entity_books")
			entity:SetPos(_ent:GetPos())
			ammoPos[#ammoPos+1] = _ent:GetPos()
			entity:Spawn()
			_ent:Remove()
		end
	end)
	
	timer.Create("MainTimer", 90, 0, function()
		local ent = ents.FindByClass("prop_physics_multiplayer")
		for _, _ent in pairs( ent ) do
			if math.abs(_ent:GetAngles().z) > 40 then
				_ent:SetAngles(Angle(0,0,0))
				_ent:DropToFloor()
			end
		end
		
		ent = ents.FindByClass("ss_entity_books")
		if #ent < 5 then
			for i = 1, #ammoPos do
				local entity = ents.Create("ss_entity_books")
				entity:SetPos(ammoPos[i])
				entity:Spawn()
			end
		end
	end)
end

function GM:PlayerConnect(name, ip)
	-- PrintMessage( HUD_PRINTTALK, name .. " has joined the game." )
end

function GM:PlayerInitialSpawn(ply)
	if team.NumPlayers(TEAM_SURVIVORS) > team.NumPlayers(TEAM_SUICIDERS) then
		ply:SetTeam(TEAM_SURVIVORS)
	else
		ply:SetTeam(TEAM_SUICIDERS)
	end
end

function GM:PlayerSpawn(ply)
	ply:StripWeapons()
	ply:StripAmmo()
	ply:SetHealth(100)
	ply:SetJumpPower(120)
	if ply:Team() == TEAM_SUICIDERS then
		ply:EmitSound("violin_up.wav", 70, 100)
		ply:SetModel("models/a_shrubbery.mdl")
		ply:Give("ss_weapon_suicider", true)
		ply:SetCrouchedWalkSpeed(50)
		ply:SetWalkSpeed(150)
		ply:SetRunSpeed(220)
	else
		ply:SetModel("models/francois/francois.mdl")
		ply:Give("ss_weapon_survivor")
		-- ply:GiveAmmo(10, "books", true)
		ply:SetWalkSpeed(140)
		ply:SetRunSpeed(205)
	end
end

-- function GM:CalcMainActivity( ply, velocity )

	-- ply.CalcIdeal = ACT_MP_STAND_IDLE
	-- ply.CalcSeqOverride = -1

	-- self:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround )

	-- if ( self:HandlePlayerNoClipping( ply, velocity ) ||
		-- self:HandlePlayerDriving( ply ) ||
		-- self:HandlePlayerVaulting( ply, velocity ) ||
		-- self:HandlePlayerJumping( ply, velocity ) ||
		-- self:HandlePlayerSwimming( ply, velocity ) ||
		-- self:HandlePlayerDucking( ply, velocity ) ) then

	-- else

		-- local len2d = velocity:Length2DSqr()
		-- if ( len2d > 22500 ) then ply.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.25 ) then ply.CalcIdeal = ACT_MP_WALK end
		-- local weapon = ply:GetActiveWeapon()
		-- ply.CalcIdeal = ply:LookupSequence("cwalk_" .. weapon:GetHoldType())
		-- ply.CalcSeqOverride = ply:LookupSequence("cwalk_" .. weapon:GetHoldType())

	-- end

	-- ply.m_bWasOnGround = ply:IsOnGround()
	-- ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )

	-- return ply.CalcIdeal, ply.CalcSeqOverride

-- end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf )
	if (ply:KeyDown(IN_JUMP) and !ply:KeyDownLast(IN_JUMP)) then
		ply:EmitSound( "boing.wav", 40, 100 )
		return true
	end

	if ply:Team() == TEAM_SUICIDERS then
		ply.lastYalala = ply.lastYalala or 0
		if (ply:KeyDown(IN_SPEED) and ply.lastYalala < CurTime()) then
			ply:EmitSound( "yalala" )
			ply.lastYalala = CurTime() + 2.5
		end
		if (ply:KeyDown(IN_WALK)) then
			ply:EmitSound("footsteps_shrub/near"..math.random(1, 2)..".wav", 40, 95)
		else
			ply:EmitSound("footsteps_shrub/near"..math.random(1, 2)..".wav")
		end
	else
		ply:EmitSound("footsteps_human/footstep"..math.random(1, 4)..".wav")
	end
	return true
end

function GM:EntityTakeDamage(ent, inflictor, attacker, amount, dmginfo)
	if (ent:IsPlayer() && ent:Team() == TEAM_SURVIVORS) then ent:EmitSound("surprised.wav") end
end

function GM:PlayerDeathSound()
	return true
end
hook.Add("OnDamagedByExplosion", "DisableSound", function()
	return true
end)

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	if (ply:Team() == TEAM_SURVIVORS) then
		ply:AddDeaths(1)
		ply:CreateRagdoll()
		return
	else
		ply:StopSound( "yalala" )
	end

	if ( attacker:IsValid() && attacker:IsPlayer() ) then
		if ( attacker != ply and attacker:Team() != ply:Team() ) then
			attacker:AddFrags(1)
		else
			attacker:AddFrags(-1)
		end
	end
end

function GM:ShowSpare1(ply)
	if ply:Team() == TEAM_SUICIDERS then
		ply:SetTeam(TEAM_SURVIVORS)
		ply:Spawn()
	end
end
	
function GM:ShowSpare2(ply)
	if ply:Team() == TEAM_SURVIVORS then
		ply:SetTeam(TEAM_SUICIDERS)
		ply:Spawn()
	end
end
	
function ChangeMyTeam( ply, cmd, args )
	if ply:Team() == TEAM_SURVIVORS then
		ply:SetTeam(TEAM_SUICIDERS)
	else 
		ply:SetTeam(TEAM_SURVIVORS)
	end
	ply:Spawn()
end
concommand.Add( "switch_team", ChangeMyTeam )