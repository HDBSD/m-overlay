-- Super Smash Bros. Melee (NTSC v1.1) / Dairantou Smash Brothers DX (Japan v1.1)

local game = {
	memorymap = {}
}

local controllers = {
	[1] = 0x804C128C + 0x44 * 0,
	[2] = 0x804C128C + 0x44 * 1,
	[3] = 0x804C128C + 0x44 * 2,
	[4] = 0x804C128C + 0x44 * 3,
}

local controller_struct = {
	[0x00] = { type = "u32",	name = "controller.%d.buttons.pressed" },
	[0x04] = { type = "u32",	name = "controller.%d.buttons.pressed_previous" },
	[0x08] = { type = "u32",	name = "controller.%d.buttons.instant" },
	[0x10] = { type = "u32",	name = "controller.%d.buttons.released" },
	[0x1C] = { type = "u8",		name = "controller.%d.analog.byte.l" },
	[0x1D] = { type = "u8",		name = "controller.%d.analog.byte.r" },
	[0x20] = { type = "float",	name = "controller.%d.joystick.x" },
	[0x24] = { type = "float",	name = "controller.%d.joystick.y" },
	[0x28] = { type = "float",	name = "controller.%d.cstick.x" },
	[0x2C] = { type = "float",	name = "controller.%d.cstick.y" },
	[0x30] = { type = "float",	name = "controller.%d.analog.l" },
	[0x34] = { type = "float",	name = "controller.%d.analog.r" },
	[0x41] = { type = "u8",		name = "controller.%d.plugged" },
}

for port, address in ipairs(controllers) do
	for offset, info in pairs(controller_struct) do
		game.memorymap[address + offset] = {
			type = info.type,
			debug = info.debug,
			name = info.name:format(port),
		}
	end
end

function game.translateJoyStick(x, y)
	return x, y
end

function game.translateTriggers(l, r)
	return l, r
end

return game