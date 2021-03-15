--[[
     _____________________________
    // Blacksteel initUtil Branch \\                  
    \\  PROJECT IS IN PRE-ALPHA!  //
     ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
     		 =--= .. =--=     
     		 QUICK ACCESS
     		 =--= .. =--=
--]]


if getgenv()["BSinitUtil_Loaded"] == true then return end
repeat wait() until game.Players.LocalPlayer;
repeat wait() until game.Players.LocalPlayer:HasAppearanceLoaded();

getgenv()["BSinitUtil_Loaded"] = true;
getgenv()["versionId"] = "v0.0.5b"

local mt = getrawmetatable(game);
setreadonly(mt, false);

getgenv()['old'] = {
	namecall = mt.__namecall;
	newindex = mt.__newindex;
};

setreadonly(mt, true);

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
	["namecall"] = function(callback)		

		if callback then
			setreadonly(mt, false);


			coroutine.wrap(function()
				mt.__namecall = newcclosure(function(self, ...)
					local args = {...};
					local method = getnamecallmethod()

					callback(self, method, ...);
				end)
			end)()


			setreadonly(mt, true);
		end;
	end;
	["newindex"] = function(callback)
		if callback then
			setreadonly(mt, false);


			coroutine.wrap(function()
				mt.__newindex = newcclosure(function(tab, index, val)
					callback(tab, index, val);
				end)
			end)()


			setreadonly(mt, true);
		end
	end;
	["setuvalue"] = function(...)
		local args = {...};

		local uvn = args[1]; -- find upvalue's name
		local uvv = args[2]; -- set upvalue's new value

		for _, lol in pairs(debug.getregistry()) do			
			if type(lol) == "function" then
				local up = debug.getupvalues(lol);				
				for _, lll in pairs(up) do
					if type(lll) == "table" then

						if lll[uvn] then
							lll[uvn] = uvv
						end

					end
				end					
			end
		end

	end;
	["getnearestplayer"] = function(...)
		local args = {...};

		local magnitude = args[1] or 30;
		local typeser = args[2] or "single";


		local function scannearestarea(mag)
			for i,v in pairs(game.Players:GetChildren()) do
				local c = v.Character
				local h = c.Humanoid

				local tab = {};

				if h and (h.RootPart.Position - game.Players.LocalPlayer.Character.Humanoid.RootPart.Position).Magnitude <= mag then
					table.insert(tab, v);
				end

				return tab;
			end
		end		

		local scan = scannearestarea(magnitude)

		if typeser == 'single' and #scan >= 1 then
			return scan[1];
		elseif typeser ~= "single" and #scan >= 1 then 
			return scan;
		end
	end;
	["runonspawn"] = function(...)
		local args = {...};
		local callback = args[1];
		
		local pp = game.Players.LocalPlayer
		
		pp.CharacterAdded:Connect(function(ad)
			callback()
		end)
	end,
};

local shorts = {
	["plr"] = game:GetService("Players").LocalPlayer;
	["chr"] = game:GetService("Players").LocalPlayer.Character;
	["hum"] = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid");
	["hrp"] = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").RootPart;
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

setreadonly(mt, true);
