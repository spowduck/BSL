--[[
     _____________________________
    // Blacksteel initUtil Branch \\                  
    \\  PROJECT IS IN PRE-ALPHA!  //
     ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
     		 	 =--=     
     		 QUICK ACCESS
     		 	 =--=
--]]
local p = game.Players.LocalPlayer
repeat wait() until p and p:HasAppearanceLoaded();


getgenv()["BSinitUtil_Loaded"] = true;

local BSinitUtil = {
	["getChildren"] = function(...)
		local args = {...};
		local path = args[1];
		local callback = args[2];

		local returntab = {};
		if (not path) then return end;

		for i,v in pairs(path:GetChildren()) do
			returntab[i] = v;
			if callback then
				callback(v);
			end;
		end;

		return returntab;
	end;
	["getHeldTool"] = function(...)
		local chr = game.Players.LocalPlayer.Character;
		local heldTool = chr:FindFirstChildOfClass("Tool");

		if heldTool then
			return heldTool;
		else
			return nil;
		end
	end;
	["load_http"] = function(...)
		local args = {...};
		local url = args[1];

		return loadstring(game:HttpGet(tostring(url)))()
	end;
	["chat"] = function(...)
		local args = {...};
		local message = args[1] or "ez";

		game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All");

	end;
	["notify"] = function(...)
		local args = {...};
		local notificationTitle = args[1] or "Title";
		local notificationText = args[2] or "Text";
		local notificationIcon = args[3] or nil;
		local callback = args[4] or nil;

		local props = {
			['Title'] = notificationTitle;
			['Text'] = notificationText;
		}

		if notificationIcon then
			props['Icon'] = notificationIcon;
		end

		game:GetService("StarterGui"):SetCore("SendNotification", props)

		if callback then
			callback();
		end
	end;
	["notifyInChat"] = function(...)
		local args = {...};

		local text = args[1] or "Sample Text";
		local colo = args[2] or Color3.fromRGB(255, 255, 243);
		local font = args[3] or Enum.Font.SourceSansBold;
		local textSize = args[4] or 18;

		game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
			Text = text;
			Color = colo;
			Font = font;
			TextSize = textSize;
		})
	end;
	["consrun"] = function(...)
		local args = {...};

		local func = args[1];
		local amt = args[2] or 1;


		for i= 1, amt do
			if func then
				func();
			end
		end

	end;
	["playSound"] = function(...)
		local args = {...};
		
		local soundId = args[1] or nil;
		
		
		if soundId then
			local sound = Instance.new("Sound", workspace)
			sound.SoundId = soundId
			sound.Volume = 1.5;
			sound:Play()
		end
	end,
};

local shorts = {
	["plr"] = game:GetService("Players").LocalPlayer;
	["chr"] = game:GetService("Players").LocalPlayer.Character;
	["hum"] = game:GetService("Players").LocalPlayer.Character.Humanoid;
	["hrp"] = game:GetService("Players").LocalPlayer.Character.Humanoid.RootPart;
	["bp"] = game:GetService("Players").LocalPlayer.Backpack;
	["coregui"] = game:GetService("CoreGui");
	["rs"] = game:GetService("ReplicatedStorage");
	['lig'] = game:GetService('Lighting');
	['p'] = game:GetService('Players');
	['pg'] = game:GetService("Players").LocalPlayer.PlayerGui;
	["ws"] = game:GetService("Workspace");
	["cam"] = game:GetService("Workspace").CurrentCamera;
};

getgenv()["setAlias"] = function(...)
	local args = {...};

	local var = args[1];
	local alias = args[2];
	local save = args[3] or false;


	local function nv(ali, var)
		getgenv()[ali] = var;
	end


	if type(alias) == "table" then
		for _, ali in pairs(alias) do
			nv(ali, var)
		end;
	elseif type(alias) == "string" then
		nv(tostring(alias), var)
	end;
	
end;

for i,v in pairs(BSinitUtil) do
	getgenv()[i] = v; -- creating the moves
end

for al,va in pairs(shorts) do
	getgenv()[al] = va;
end

