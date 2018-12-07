DeriveGamemode("base")

GM.Name 		= "Suicide Survival"
GM.Author 	= "Neon (special thanks to MadDog)"
GM.Email 		= ""
GM.Website 	= "netzona.org"

TEAM_SUICIDERS = 1
TEAM_SURVIVORS = 2

function GM:CreateTeams()
	team.SetUp(TEAM_SUICIDERS, "Suiciders", Color( 0, 180, 0, 255 ))
	team.SetUp(TEAM_SURVIVORS, "Survivors", Color( 0, 0, 180, 255 ))
end

game.AddAmmoType( {
	name = "books",
	dmgtype = DMG_CRUSH,
	tracer = TRACER_LINE,
	plydmg = 1000,
	npcdmg = 1000,
	force = 2000,
	minsplash = 10,
	maxsplash = 5
} )