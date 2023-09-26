        local vehicle = getPedOccupiedVehicle(localPlayer)
        local size = {x= 300,y= 300}
        local sizeP = {x= 15/1.5,y= 20/1.5}
        dxDrawImage (x-size.x*1.1,y-size.y*1.1, size.x,size.y, img.none, 0, 0, -120 )
        for i, vehicle in ipairs(getElementsByType("vehicle")) do
            local camX,camY,camZ,camToX,camToY,camToZ = getCameraMatrix()
            local camRotZ = 360 - getPedCameraRotation(localPlayer)
            local rx,ry,rz = getElementRotation ( vehicle )
            global = {
                player_or_camera = {x = camX, y = camY, z = camZ, rotZ = camRotZ},
                vehicle = {x = vehicle.matrix:getPosition().x, y = vehicle.matrix:getPosition().y, z = vehicle.matrix:getPosition().z, rotZ = vehicle.matrix:getRotation().z},
                distance = getDistanceBetweenPoints2D (camX, camY, vehicle.matrix:getPosition().x, vehicle.matrix:getPosition().y ),
            }
            angle = math.atan2(global.player_or_camera.y - global.vehicle.y, global.player_or_camera.x - global.vehicle.x) + math.rad(-camRotZ)
            listenerRelativeX = math.cos(angle) *  global.distance
            listenerRelativeY = math.sin(angle) *  global.distance
            listenerRelativePos = {x = istenerRelativeX, y = listenerRelativeY}
            dxDrawImage (x-size.x*1.1+size.x/2-sizeP.x/2,y-size.y*1.1+size.x/2-sizeP.y/2, sizeP.x,sizeP.y, img.main, 0, 0, 0 )
            if global.distance <= 30 then
                dxDrawLine( x-size.x*1.1+size.x/2,y-size.y*1.1+size.x/2,x-size.x*1.1+size.x/2+(-listenerRelativeX)*5,y-size.y*1.1+size.x/2+(listenerRelativeY)*5, tocolor(255, 0, 0) )
                dxDrawImage (x-size.x*1.1+size.x/2-sizeP.x/2+(-listenerRelativeX)*5,y-size.y*1.1+size.x/2-sizeP.y/2+(listenerRelativeY)*5, sizeP.x,sizeP.y, img.visible, -rz+camRotZ, 0, 0 )
            end
        end




        
        if fmodArray then
            local text
            dxDrawImage (8, y/5-5, maxWidth, 26*#fmodArray, img.fone, 0, 0, 0 )
            for key, value in pairs(fmodArray) do
                if type(value[1][2]) == "table" then
                    text = "[" .. key .. "]: " .. value[1][1].." "..rgbToHex(100,220,110)..""..inspect(value[1][2])
                else
                    text = "[" .. key .. "]: " .. value[1][1].." -"..rgbToHex(100,220,110).." "..tostring(value[1][2])
                end
                local textWidth = dxGetTextWidth(text, 1.2, "arial", false)
                if textWidth > maxWidth then
                    maxWidth = textWidth+40
                end
                dxDrawText(text, 15, y/5+key*20, x-50, y, tocolor(255, 255, 255, 225), 1.2, "arial", "left", "top", false, false, false, true)
            end
        end