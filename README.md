Usage
```csharp
createWindow(name : <string>,{
	Custom drag : <boolean>,
	Background Color : <Color3>
})
   makeButton(<string> text, <function> callback)
   makeLabel(<string> text)
```
  
Example
```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/alexzinyew/roblox/main/easyLib.lua", true))()
library.init()
local window = library:createWindow("Example UI",{
	true,
	Color3.fromRGB(45,45,45)
})

local functions = {
	button1 = function()
		print("Hello World!")
	end,
}

window:makeButton("Button",functions.button1) -- when pressed, it will "Hello World!"

window:makeLabel("Test") -- displays test below the button, it works in order.
```
