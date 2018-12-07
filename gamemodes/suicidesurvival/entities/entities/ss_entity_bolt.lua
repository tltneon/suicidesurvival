AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Book"
ENT.Category = "Suicide Survival"
ENT.Spawnable = false

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/knowledgebolt.mdl")
		self:SetSolid(SOLID_NONE)
		SafeRemoveEntityDelayed(self, 15)
	end
end