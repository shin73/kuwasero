--背景画像
local background = display.newImage("images/Background.png")
display.setStatusBar(display.HiddenStatusBar)

--フィジクスエンジンを生成
local physics = require("physics") 

--1.フィジクスのdrawモードを設定
physics.setDrawMode("normal")

--2.マルチタッチ対応にする
system.activate("multitouch")

--3.デバイスの高さと幅を取得する
_H = display.contentHeight
_W = display.contentWidth

--動物登場
local animal1 = display.newImageRect("images/Duck.png", 100, 100)
animal1.x = 160 
animal1.y = 110

-- 矩形衝突判定
local function hitTestObjects(obj1, obj2)
	local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
	local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
	local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
	local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
	return (left or right) and (up or down)
end

local function nextFood(object)
	if hitTestObjects(object, animal1) then
		print("hit!")
	else
		print("not hit!")
	end
end 
--ゲーム開始
local function startGame()
	local food = display.newImageRect("images/Apple_00.png", 75, 75)
	food:setReferencePoint(display.CenterReferencePoint)

	food.x = 160
	food.y = 440


	function food:touch(event)
		currentScreen = 1
	    if event.phase == "ended" then
	    	print(event.x)
	    	print(event.xStart)

	    	--縦方向へのスワイプ
	    	if(event.y - event.yStart) > -10 then
	    		currentScreen = 4
	    	elseif (event.x - event.xStart) > 10 then
		        currentScreen = currentScreen - 1
		        if currentScreen < 1 then
		                currentScreen = 1
		        end
	        elseif (event.x - event.xStart) < -10 then
		        currentScreen = currentScreen + 1
		        if currentScreen > 3 then
		                currentScreen = 3
		        end
		    else
		    	currentScreen = 0
	        end

			if currentScreen == 1 then
	            transition.to( self, { time = 150, x = 80 } )
			elseif currentScreen == 2 then
	            transition.to( self, { time = 100, x = 160 } )
		    elseif currentScreen == 3 then
	            transition.to( self, { time = 100, x = 240 } )
	        elseif currentScreen == 4 then
	        	transition.to( self, { time = 350, y = 110 , onComplete = nextFood} )
	        end
	    end
	end

	food:addEventListener("touch", food)

end

gameTimer = timer.performWithDelay(20, startGame, 1)
