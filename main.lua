io.stdout:setvbuf("no")
local sti = require "sti"
local map
local world
local tx, ty
local xx, yy
local points

-- push = require 'push'

-- WINDOW_WIDTH = 1280
-- WINDOW_HEIGHT = 720
-- VIRTUAL_WIDTH = 432
-- VIRTUAL_HEIGHT = 243

function love.load()
 love.window.setMode(800, 600, {resizable=false, vsync=false, minwidth=400, minheight=300})
  x, y, w, h = 400, 300, 160, 120
  love.graphics.setDefaultFilter('nearest','nearest')
 map = sti("/assets/demo3.lua",   { "box2d" })
 van = love.graphics.newImage("van.png")

	-- Print versions
	print("STI: " .. sti._VERSION)
	print("Map: " .. map.tiledversion)
	print("ESCAPE TO QUIT")
	print("SPACE TO RESET TRANSLATION")
  	-- Prepare translations
	tx, ty = 0, 0

	-- Prepare physics world
	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0)
	map:box2d_init(world)

	-- Drop points on clicked areas
	points = {
		mouse = {},
		pixel = {}
	}
	love.graphics.setPointSize(15)
        
--         push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
--         fullscreen = false,
--         resizable = false,
--         vsync = true
--     })

end

function love.keypressed(key)
	-- Exit test
	if key == "escape" then
		love.event.quit()
	end

	-- Reset translation
	if key == "space" then
		tx, ty = 0, 0
	end
end

function love.update(dt)
  
	world:update(dt)
	map:update(dt)
  smallFont = love.graphics.newFont('nes.ttf',32)
  love.graphics.setFont(smallFont)
	-- Move map
	local kd = love.keyboard.isDown
	local l  = kd("left")  or kd("a")
	local r  = kd("right") or kd("d")
	local u  = kd("up")    or kd("w")
	local d  = kd("down")  or kd("s")

	tx = l and tx - 128 * dt or tx
	tx = r and tx + 128 * dt or tx
	ty = u and ty - 128 * dt or ty
	ty = d and ty + 128 * dt or ty

xx = 0
yy = 0
end

function love.draw()
--  push:apply('start')
--  love.graphics.scale( 5, 2 )  -- perhaps you are missing this?

	-- Draw map
	love.graphics.setColor(255, 255, 255)
	map:draw(-tx, -ty)

	-- Draw physics objects
	love.graphics.setColor(255, 0, 255)
	map:box2d_draw(-tx, -ty)

	-- Draw points
	love.graphics.translate(-tx, -ty)

	love.graphics.setColor(255, 0, 255)
	for _, point in ipairs(points.mouse) do
		love.graphics.points(point.x, point.y)
	end

	love.graphics.setColor(255, 255, 0)
	for _, point in ipairs(points.pixel) do
		love.graphics.points(point.x, point.y)
	end
  love.graphics.setColor(1, 1, 0)
  love.graphics.printf( 'Bela tarde para lanches', tx, ty + 200,600, 'center')
   love.graphics.draw(van, tx + 30, ty + 350,0,0.5,0.5)


-- push:apply('end')
end

function love.mousepressed(x, y, button)
	if button == 1 then
		x = x + tx
		y = y + ty

		local tilex, tiley   = map:convertPixelToTile(x, y)
		local pixelx, pixely = map:convertTileToPixel(tilex, tiley)

		table.insert(points.pixel, { x=pixelx, y=pixely })
		table.insert(points.mouse, { x=x, y=y })

		print(x, tilex, pixelx)
		print(y, tiley, pixely)
	end
end

function love.resize(w, h)
	map:resize(w, h)
end
