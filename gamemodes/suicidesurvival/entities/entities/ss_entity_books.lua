AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Books (ammo)"
ENT.Category = "Suicide Survival"
ENT.Spawnable = true

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/knowledge_ammo.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		else
			local min, max = Vector(-8, -8, -8), Vector(8, 8, 8)

			self:PhysicsInitBox(min, max)
			self:SetCollisionBounds(min, max)
		end
	end

	function ENT:Use(activator)
		if activator:Team() == TEAM_SURVIVORS then
			activator:GiveAmmo(3, "books")
			self:Remove()
		end
	end
end