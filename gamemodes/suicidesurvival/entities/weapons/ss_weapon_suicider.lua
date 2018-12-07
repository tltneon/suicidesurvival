
-- Variables that are used on both client and server

SWEP.Instructions	= "Shoot a prop to attach a Manhack.\nRight click to attach a rollermine."

SWEP.Spawnable			= false
SWEP.AdminOnly			= false
SWEP.UseHands			= false

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "Bomb"
SWEP.Slot				= 0
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false


--[[---------------------------------------------------------
	Reload does nothing
-----------------------------------------------------------]]
function SWEP:Reload()
end

--[[---------------------------------------------------------
   Think does nothing
-----------------------------------------------------------]]
function SWEP:Think()
end

--[[---------------------------------------------------------
	PrimaryAttack
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()
	if SERVER then
		local ent = ents.Create("env_explosion")
		ent.BarrelOwner = self:GetOwner()
		ent:SetPos( self:GetPos() )
		ent:SetParent( self:GetOwner() )
		ent:SetOwner( self:GetOwner() )
		ent:Spawn()
		ent:SetKeyValue( "iMagnitude", "150" )
		ent:Fire( "Explode", 0, 0 )
	end
	self:SetNextPrimaryFire(CurTime() + 0.5)
end

--[[---------------------------------------------------------
	SecondaryAttack
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1.5)
	if math.random(1, 2) == 2 then
		self:EmitSound( "taunts_suicider/behindyou0"..math.random(1,2)..".wav" )
	elseif math.random(1, 2) == 2 then
		self:EmitSound( "taunts_suicider/overthere0"..math.random(1,2)..".wav" )
	else
		self:EmitSound( "taunts_suicider/overhere01.wav" )
	end
end

--[[---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
-----------------------------------------------------------]]
function SWEP:ShouldDropOnDie()
	return false
end
