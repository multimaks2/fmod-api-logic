render_engine = function(dt)
    local myVehicle = getPedOccupiedVehicle(localPlayer)
    if myVehicle and getVehicleController(myVehicle) ~= localPlayer then
        myVehicle = false
    end
    local cx, cy, cz = getCameraFmod()[1]
    local now = getTickCount()
    local startY = 1080/3  -- Начальная координата Y для текста

    for vehicle, data in pairs(streamedVehicles) do
        if not getVehicleEngineState(vehicle)  then
            
            -- return
            -- если двигатель выключен, то глушим двигатель через FMOD

        else
            local model = getElementModel(vehicle)
            local x, y, z = getElementPosition(vehicle)
            local rx, ry, rz = getElementRotation (vehicle)
            local handling = getVehicleHandling(vehicle)
            local velocityVec = Vector3(getElementVelocity(vehicle))
            local velocity = velocityVec.length * 180
            local controller = getVehicleController(vehicle)
            local vehicleType,vehicleEngine = getVehicleTypeById(model), getEngineNameByVehicleId(model)
            
            data.engine.RPM = data.engine.RPM or 0
            data.engine.GEAR = data.engine.GEAR or 1
            -- data.engine.turbo = data.fmod.TURBO 
            -- data.engine.turbo = data.fmod.TURBO 
            -- data.engine.turbo_shifts = data.fmod.TURBO_PSI 
            data.engine.SHIFT_UP_RPM = data.fmod.SHIFT_UP_RPM or data.fmod.MAX_RPM*0.91
            data.engine.SHIFT_DOWN_RPM = data.fmod.SHIFT_DOWN_RPM or (data.fmod.IDLE_RPM+data.fmod.MAX_RPM)/2.5

                    data.engine.prevThrottle = data.engine.throttle
                    data.engine.throttle = controller and (getPedControlState(controller, "accelerate"))
                    
                    if not data.engine.reverse and velocity < 10 then
                        data.reverse = controller and (getPedAnalogControlState(controller, "brake_reverse") > 0.5)or false
                    elseif data.engine.throttle and velocity < 50 then 
                        data.engine.reverse = false
                    end
                    
                    local isSkidding = controller and ( ( getPedControlState(controller, "accelerate") and getPedControlState(controller, "brake_reverse") or getPedControlState(controller, "handbrake") ) and velocity < 40 ) or false
                    data.engine.forceNeutral = isSkidding -- w / s or handbrake without moving: neutral gear
                                or (isLineOfSightClear(x, y, z, x, y, z-(getElementDistanceFromCentreOfMassToBaseOfModel(vehicle)*1.25), true, false, false, true, true, false, false, vehicle) and data.throttle) -- vehicle in air: neutral gear
                                or isElementFrozen(vehicle) or isElementInWater(vehicle) -- frozen / in water: neutral gear
                                or (( rx > 110 ) and ( rx < 250 )) -- on roof: neutral gear

            data.engine.throttlingRPM = data.engine.throttlingRPM or 0
            data.engine.changingRPM = data.engine.changingRPM or 0
            data.engine.changingGear = type(data.engine.changingGear) == "number" and data.engine.changingGear or false
            data.engine.changingTargetRPM = data.engine.changingTargetRPM or 0 
          
            data.engine.previousGear = data.engine.previousGear or data.engine.GEAR
            data.engine.currentGear = data.engine.currentGear or 1


            local wheel_rpm = velocity*100
            local rpm = wheel_rpm -- engine rpm

            if getVehicleController(vehicle) then
                rpm = rpm*data.gearRatios[data.engine.GEAR]
            else 
                rpm = data.fmod.IDLE_RPM
            end 
            -- data.engine.RPM = rpm
            

            if not data.engine.forceNeutral then
                data.engine.throttlingRPM = math.max(0, data.engine.throttlingRPM - (data.fmod.MAX_RPM*data.fmod.Revolutions_Coefficient)*dt)
            else 
                if data.engine.throttle then 
                    data.engine.throttlingRPM = data.engine.throttlingRPM + (data.fmod.MAX_RPM*data.fmod.Revolutions_Coefficient)*dt
                else 
                    data.engine.throttlingRPM = math.max(0, data.engine.throttlingRPM - (data.fmod.MAX_RPM*data.fmod.Revolutions_Coefficient)*dt)
                end 
                data.engine.throttlingRPM = math.min(data.engine.throttlingRPM, data.fmod.MAX_RPM)
            end             
            rpm = rpm+data.engine.throttlingRPM


            rpm = rpm+data.engine.changingRPM
            if data.engine.changingGear then
                local progress = (now-data.engine.changingTargetRPM.time) / 300 -- how long
                data.engine.changingRPM = interpolateBetween(data.engine.changingTargetRPM.target, 0, 0, 0, 0, 0, progress, "InQuad")
                
                if progress >= 1 then
                    data.engine.changingGear = false
                    data.engine.changingGearDirection = false
                    data.engine.changingRPM = 0
                    data.engine.changingTargetRPM = false
                end
            end 

            if data.engine.previousGear ~= data.engine.currentGear then 
                changedGear = (data.engine.currentGear < data.engine.previousGear) and "down" or "up"
                                        
                data.engine.changingGear = data.engine.currentGear
                data.engine.changingGearDirection = changedGear 
                
                local nextrpm = data.engine.MAX_RPM
                if data.gearRatios[data.engine.changingGear] then
                    nextrpm = wheel_rpm*data.gearRatios[data.engine.changingGear]
                end
                data.engine.changingRPM = rpm-nextrpm
                data.engine.changingTargetRPM = {target=data.engine.changingRPM, time=now}
                
                data.engine.GEAR = data.engine.currentGear
                -- data.turboValue = 0
            end 
            data.engine.previousGear = data.engine.currentGear


            -- change gears
            if not data.engine.changingGear and data.engine.throttlingRPM == 0 and wheel_rpm > 200 then
                if rpm > data.engine.SHIFT_UP_RPM and data.engine.throttle then 
                    data.engine.currentGear = math.min(data.engine.currentGear+1, math.max(4, data.fmod.MAX_GEAR or getVehicleHandling(vehicle).numberOfGears ) )
                elseif rpm < data.engine.SHIFT_DOWN_RPM then
                    data.engine.currentGear = math.max(1, data.engine.currentGear-1)
                end 
            end 

            -- rev limiter
            if rpm < data.fmod.IDLE_RPM then 
                rpm = data.fmod.IDLE_RPM+math.random(0,100)
            elseif rpm > data.fmod.MAX_RPM then 
                rpm = data.fmod.MAX_RPM-math.random(0,100)
                data.engine.wasRevLimited = true
            end

            -- dxDrawText(rpm, 1920/2, startY, 0, 0, tocolor(255, 255, 255, 225), debugfontsize, debugfontname, "left", "top", false, false, false, true)
            -- local strState = rgbToHex(255, 255, 0) .. getVehicleName(vehicle) .. rgbToHex(255, 255, 255) .. " type->" ..
            -- rgbToHex(255, 0, 0) .. vehicleType .. rgbToHex(255, 255, 255) .. " model->" ..
            -- rgbToHex(0, 255, 0) .. model .. rgbToHex(255, 255, 255) .. " engine->" ..
            -- rgbToHex(0, 255, 255) .. vehicleEngine..
            -- rgbToHex(255,255,255).." data->"..inspect(data.engine)
            -- assert(strState, "ошибка при формировании общей информации авто")
            data.engine.actualrpm = rpm

            -- dxDrawImage ( 225,1080/2.2+255, 20,-150, img.main, 0, 0, -120 , tocolor(255,255, 255,200))   -- обороты
            -- local rpmProgress = data.engine.actualrpm/data.fmod.MAX_RPM*150 --  акселерация оборотов
            -- dxDrawImage ( 225,1080/2.2+255, 20,-rpmProgress, img.car, 0, 0, 0 , tocolor(255,255, 255,200))   -- обороты

            -- local gearProgress = data.engine.GEAR/#data.gearRatios*150 --  акселерация оборотов
            -- dxDrawImage ( 250,1920/2.2+255, 20,-150, img.main, 0, 0, -120 , tocolor(255,255, 255,200))   -- передачи
            -- dxDrawImage ( 250,1920/2.2+255, 20,-gearProgress, img.main, 0, 0, 0 , tocolor(255,255, 255,200))   -- передачи

            dxDrawText(inspect(data.engine):gsub("[{}]", ""), 1920/2, startY, 0, 0, tocolor(255, 255, 255, 225), debugfontsize, debugfontname, "left", "top", false, false, false, true)


            local screenWidth, screenHeight = guiGetScreenSize()
            local startX = screenWidth - 208  -- Располагаем элементы 8 пикселей от правого края экрана
            local startY = screenHeight / 2   -- Вы можете установить другое начальное значение для Y

            if myVehicle then
                local lineHeight = 20  -- Высота одной строки текста
                local numLines = #data.gearRatios  -- Получаем количество строк

                -- Вычисляем высоту изображения на основе количества строк и высоты строки
                local imageHeight =  (numLines * lineHeight)

                dxDrawImage(startX, startY, 200, imageHeight+14, img.fone, 0, 0, 0)

                for k, v in ipairs(data.gearRatios) do
                    t = "Коэфф [" .. tostring(k) .. "]: " .. rgbToHex(355*(v*3), 250*(v*3),65*(v*3)) .. " " .. string.format("%.3f", v) .. "" .. rgbToHex(255, 255, 255) .. "\n"
                    dxDrawText(t, startX + 7, startY+7  + (k - 1) * lineHeight, 0, 0, tocolor(255, 255, 255, 225), 1.2, "arial", "left", "top", false, false, false, true)
                end
            end


            -- startY = startY + 15
        end
    end

end
addEventHandler("onClientPreRender", root, render_engine)












attachEngineToVehicle = function(vehicle)
    if getElementType(vehicle) == "vehicle" then
        local model = getElementModel(vehicle)
        -- streamedVehicles[vehicle] = {["fmod"] = getEngineParametrFromID(model),["data"] = getOriginalHandling(model),["gearRatios"] = calculateGearRatios(vehicle, getEngineParametrFromID(model).MAX_RPM, 0)}
        streamedVehicles[vehicle] = {["engine"] = {}, ["fmod"] = getEngineParametrFromID(model),["gearRatios"] = calculateGearRatios(vehicle, getEngineParametrFromID(model).MAX_RPM, 0)}
    end
end
addEventHandler("onClientElementStreamIn",  root, function()
    attachEngineToVehicle(source)
end)

detachEngineFromVehicle = function(vehicle)
    if getElementType(vehicle) == "vehicle" then
        streamedVehicles[vehicle] = nil
        -- iprint("detachEngineFromVehicle")
    end
end
addEventHandler("onClientElementStreamOut", root, function()
    detachEngineFromVehicle(source)
end)

initVehicleArray = function()
    for i, vehicle in ipairs(getElementsByType("vehicle", root, true)) do
        attachEngineToVehicle(vehicle)
    end
end

deleteVehicleArray = function()
    streamedVehicles = nil
end
