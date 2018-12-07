include("shared.lua")

hook.Add("HUDPaint", "HUDPaint_DrawABox", function()
	surface.SetFont("CloseCaption_Bold")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(32, ScrH()-128)
	if LocalPlayer():Team() == TEAM_SURVIVORS then
		surface.DrawText( "Team Survivor" )
	else
		surface.DrawText( "Team Suicide" )
	end
end)

function GM:Initialize()
end

function GM:HUDShouldDraw(name)
	local res = not (name == "CHudWeaponSelection" 
		        or name == "CHudBattery" 
		        or name == "CHudDamageIndicator" 
		        or name == "CHudPoisonDamageIndicator" 
		        or name == "CHudZoom")
	return res
	--return true
end

function GM:HUDPaint()
	hook.Run("HUDDrawTargetID")
	hook.Run("DrawDeathNotice", 0.85, 0.04)
end

function GM:HUDDrawTargetID()
	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end
	
	local text = "ERROR"
	local font = "TargetID"
	
	if (trace.Entity:IsPlayer()) and not (LocalPlayer():Team() == TEAM_SURVIVORS and trace.Entity:Team() ~= TEAM_SURVIVORS) then
		text = trace.Entity:Nick()
	else
		return
	end
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	
	local MouseX, MouseY = gui.MousePos()
	
	if ( MouseX == 0 && MouseY == 0 ) then
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	end
	
	local x = MouseX
	local y = MouseY
	
	x = x - w / 2
	y = y + 30
	
	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )
	
	y = y + h + 5
	
	local text = team.GetName(trace.Entity:Team())
	local font = "TargetIDSmall"
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x =  MouseX  - w / 2
	
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )
end

hook.Add("ShouldDrawLocalPlayer", "SimpleTP.ShouldDraw", function(ply)
	if ply:Team() == TEAM_SUICIDERS then
		return true
	end
end)

	hook.Add("CalcView","SimpleTP.CameraView",function(ply, pos, angles, fov)
	
		if IsValid(ply) and ply:Team() == TEAM_SUICIDERS then
		
			local Editor = {}
		
			if Editor.DelayPos == nil then
				Editor.DelayPos = ply:EyePos()
			end
			
			if Editor.ViewPos == nil then
				Editor.ViewPos = ply:EyePos()
			end
			
			Editor.DelayFov = fov
			
			local view = {}
		
			local Forward = 100
			
			local Up = 0
			local Right = 0
			
			local Pitch = 360
			local Yaw = 360
			
			Editor.DelayPos = pos
			fov = Editor.DelayFov
			
			local traceData = {}
			traceData.start = Editor.DelayPos
			traceData.endpos = traceData.start + angles:Forward() * -Forward
			traceData.endpos = traceData.endpos + angles:Right() * Right
			traceData.endpos = traceData.endpos + angles:Up() * Up
			traceData.filter = ply
			
			local trace = util.TraceLine(traceData)
			
			pos = trace.HitPos
			
			if trace.Fraction < 1.0 then
				pos = pos + trace.HitNormal * 5
			end
			
			view.origin = pos

			view.angles = angles
			view.fov = fov
		 
			return view

		end
	end)