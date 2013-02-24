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
animal1.x = 55 
animal1.y = 110

local animal2 = display.newImageRect("images/Duck.png", 100, 100)
animal2.x = 160 
animal2.y = 110

local animal3 = display.newImageRect("images/Duck.png", 100, 100)
animal3.x = 265
animal3.y = 110

-- 矩形衝突判定
local function hitTestObjects(obj1, obj2)
	local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
	local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
	local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
	local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
	return (left or right) and (up or down)
end

--エサ生成
local function createFood()
	local food = display.newImageRect("images/Apple_00.png", 75, 75)
	food:setReferencePoint(display.CenterReferencePoint)

	food.x = 160
	food.y = 440

	return food
end


--ゲーム開始
local function startGame()

	--次のエサ
	function nextFood(object)
	end

	local food = createFood()

	function food:touch(event)
		currentScreen = 1
	    if event.phase == "ended" then

	    	--縦方向へのスワイプ
	    	yDist = event.y - event.yStart
	    	--横方向へのスワイプ
	    	xDist = event.x - event.xStart

	    	local xCount = xDist
	    	local yCount = yDist

	    	--総移動距離が一定数以上のとき
	    	if(xCount < 0) then
	    		xCount = xCount * -1
	    	end

	    	if(yCount < 0) then
	    		yCount = yCount * -1
	    	end
	    	print("xDist"..xDist)
	    	print("yDist"..yDist)
	    	print("xCount"..xCount)
	    	print("yCount"..yCount)
	    	print("移動距離"..(yCount + xCount))
	    	if((yCount + xCount) >= 5 )then
	    		--移動角度。0.5を堺にして方向が変わる
	    		angle = xCount / yCount
	    		print("移動角度"..(xCount / yCount ))

	    		if(angle < 0.5) then
	    			--中央に
	    			currentScreen = 2
	    		else
	    			if(xDist > 0) then
	    				--右に
		    			currentScreen = 3
	    			else
	    				--左に
		    			currentScreen = 1
	    			end
	    		end

		    	function checkRightAnimal(object)
		    		object:removeSelf()

		    		if hitTestObjects(object, animal2) then
		    			print("hit!")
		    		else
		    			print("not hit!")
		    		end
		    		startGame()
		    	end

				if currentScreen == 1 then
		            transition.to( self, { time = 350, x = 55, y = 110 
		            	, onComplete = checkRightAnimal} )
	            elseif currentScreen == 2 then
	            	transition.to( self, { time = 350, x = 160, y = 110 
	            		, onComplete = checkRightAnimal} )
			    elseif currentScreen == 3 then
		            transition.to( self, { time = 350, x = 265, y = 110 
	            		, onComplete = checkRightAnimal} )
		        end

	    	end
	    end
	end

	food:addEventListener("touch", food)

end

gameTimer = timer.performWithDelay(20, startGame, 1)
