AddCSLuaFile()

SWEP.Instructions	= "Shoot a prop to attach a Manhack.\nRight click to attach a rollermine."

SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/v_weapon_knowledge.mdl"
SWEP.WorldModel			= "models/w_weapon_knowledge.mdl"

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "books"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "Books"
SWEP.Slot				= 0
SWEP.SlotPos			= 0

SWEP.HoldType			= "slam"

local ShootSound = Sound("weapons/throw.wav")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

--[[---------------------------------------------------------
	Reload does nothing
-----------------------------------------------------------]]

function SWEP:Reload()

PrintTable(self.Owner:GetSequenceList())
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
	self:SetNextPrimaryFire(CurTime() + 0.5)
	
	if self:Clip1() <= 0 and self:Ammo1() <= 0 then
		self:SetNextPrimaryFire(CurTime() + 2)
		return
	end

	self:EmitSound( ShootSound )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local tr = self.Owner:GetEyeTrace()

	if ( IsFirstTimePredicted() ) then
		local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetNormal( tr.HitNormal )
		effectdata:SetMagnitude( 2 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 0.16 )
		util.Effect( "Sparks", effectdata )
	end

	-- The rest is only done on the server
	if ( CLIENT ) then return end

	if ( tr.HitWorld ) then
		local ent = ents.Create( "ss_entity_bolt" )
		ent:SetPos( tr.HitPos + self.Owner:GetAimVector() * -4 )
		ent:SetAngles( tr.HitNormal:Angle() )
		ent:Spawn()
		ent:EmitSound("weapons/bolt_smack"..math.random(1, 2)..".wav", 100)
	elseif tr.Entity then
		tr.Entity:EmitSound("weapons/bolt_smack"..math.random(1, 2)..".wav", 100)
		if (tr.Entity:IsPlayer()) then
			if tr.Entity:Team() == TEAM_SUICIDERS then
				local bullet = {} 
					bullet.Num = 1
					bullet.Src = self.Owner:GetShootPos() //Gets where the bullet comes from
					bullet.Dir = self.Owner:GetAimVector() //Gets where you're aiming
					bullet.Spread = 1
					bullet.Tracer = 0 
					bullet.Force = 2000
					bullet.Damage = 1000
					bullet.AmmoType = "books"
			 
				self.Owner:FireBullets( bullet )
			end
		end
	end
	
	self:TakePrimaryAmmo(1)

end

--[[---------------------------------------------------------
	SecondaryAttack
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()
end


--[[---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
-----------------------------------------------------------]]
function SWEP:ShouldDropOnDie()
	return false
end

-- function SWEP:DrawHUD()
	-- surface.SetFont("CloseCaption_Bold")
	-- surface.SetTextColor(255, 255, 255, 255)
	-- surface.SetTextPos(ScrW()*.8, ScrH()-128)
	-- surface.DrawText( "Books: "..LocalPlayer():GetAmmoCount("books") )
-- end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}

	self.AmmoDisplay.Draw = true //draw the display?

	if self.Primary.ClipSize > 0 then
		self.AmmoDisplay.PrimaryClip = self:Clip1()+self:Ammo1() //amount in clip
		self.AmmoDisplay.PrimaryAmmo = 0 //amount in reserve
	end
	if self.Secondary.ClipSize > 0 then
		self.AmmoDisplay.SecondaryAmmo = self:Ammo2() // amount of secondary ammo
	end

	return self.AmmoDisplay //return the table
end