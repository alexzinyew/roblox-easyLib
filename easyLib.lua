local library = {}
local uis = game:GetService("UserInputService")
local windows = 0
local ui
local ts = game:GetService("TweenService")

local function draggable(obj)
	local globals = {}
	globals.dragging=nil
	globals.uiorigin=nil
	globals.morigin=nil
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			globals.dragging = true
			globals.uiorigin = obj.Position
			globals.morigin = input.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					globals.dragging = false
				end
			end)
		end
	end)
	uis.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and globals.dragging then
			local change = input.Position - globals.morigin
			wait(.05) -- smooth effect you can remove 
			obj.Position = UDim2.new(globals.uiorigin.X.Scale,globals.uiorigin.X.Offset+change.X,globals.uiorigin.Y.Scale,globals.uiorigin.Y.Offset+change.Y)
		end
	end)
end

local function GetColorDelta(Color,Delta)
	local H,S,V = Color:ToHSV()
	return Color3.fromHSV(H,S,V+(Delta/255))
end

function library:init()
	ui = Instance.new("ScreenGui")
	ui.Name = tostring(string.char(math.ceil(math.random() * 254)))
	ui.Parent = game.Players:GetChildren()[1].PlayerGui
end

function library:newItem(item,data)
	item = Instance.new(item)
	for i,v in pairs(data) do
		if i ~= "Parent" then
			item[i] = v
		end
	end
	item.Parent = data.Parent
	return item
end

function library:createWindow(name,data)
	local drag = data[1]
	local bgrColor = data[2]
	local open = true
	windows = windows + 1 
	
	local topFrame = self:newItem("Frame",{
		Parent = ui;
		Name = tostring(windows);
		Position = UDim2.new(0.048+(.159*(windows-1)), 0,0.078, 0);
		Size = UDim2.new(0.129, 0,0.066, 0);
		Active = true;
		BackgroundColor3 = bgrColor;
		BorderSizePixel = 0;
	})
	local topLabel = self:newItem("TextLabel",{
		Parent = topFrame;
		Size = UDim2.new(0.722, 0,1, 0);
		BackgroundTransparency = 1;
		TextColor3 = Color3.fromRGB(255,255,255);
		Text = tostring(name);
		Font = Enum.Font.Ubuntu;
		TextScaled = true;
		BorderSizePixel = 0
	})
	local topButton = self:newItem("TextButton",{
		Parent = topFrame;
		Size = UDim2.new(0.278, 0,1, 0);
		Position = UDim2.new(0.722, 0,0, 0);
		BackgroundTransparency = 1;
		TextColor3 = Color3.fromRGB(255,255,255);
		Text = "^";
		Font = Enum.Font.Ubuntu;
		TextScaled = true;
		Rotation = 180;
		BorderSizePixel = 0
	})
	
	local container = self:newItem("Frame",{
		Parent = topFrame;
		Name = "Container";
		Position = UDim2.new(0, 0,1,0);
		Size = UDim2.new(1, 0,8.605, 0);
		Active = true;
		BackgroundColor3 = GetColorDelta(bgrColor,10);
		BorderSizePixel = 0
})

	topButton.MouseButton1Click:Connect(function()
		local ti = TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
		local openbutton = ts:Create(topButton,ti,{Rotation = 180})
		local ti = TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
		local closebutton = ts:Create(topButton,ti,{Rotation = 0})
		local ti = TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
		local opencontainer = ts:Create(container,ti,{Size = UDim2.new(1, 0,8.605, 0)})
		local ti = TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
		local closecontainer = ts:Create(container,ti,{Size = UDim2.new(1,0,0,0)})
		
		open=not open
		if open then
			openbutton:Play()
			opencontainer:Play()
		else
			closebutton:Play()
			closecontainer:Play()
		end
	end)

	local listlayout = self:newItem("UIListLayout",{
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		Parent = container;
		Padding = UDim.new(0.02, 0)
	})
	
	local functions = {}
	function functions:makeButton(text,callback)
		local button = library:newItem("TextButton",{ --err
			Size = UDim2.new(0.96, 0,0.093, 0);
			BorderSizePixel = 0;
			BackgroundColor3 = GetColorDelta(bgrColor,5);
			Font = Enum.Font.Ubuntu;
			TextColor3 = Color3.fromRGB(255,255,255);
			TextScaled = true;
			Text = tostring(text);
			Parent = container;
		})
		button.MouseButton1Click:Connect(function()
			callback()
		end)
	end
	
	function functions:makeLabel(text,color)
		local label = library:newItem("TextLabel",{
			Size = UDim2.new(0.96, 0,0.093, 0);
			BorderSizePixel = 0;
			BackgroundColor3 = GetColorDelta(bgrColor,5);
			Font = Enum.Font.Ubuntu;
			TextColor3 = Color3.fromRGB(255,255,255);
			TextScaled = true;
			Text = tostring(text);
			Parent = container;
		})
	end
	
	
	
	if drag then
		draggable(topFrame)
	else
		topFrame.Draggable = true
		topFrame.Active = true
	end
	return functions
end

return library
