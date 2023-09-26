local x, y = guiGetScreenSize ()
local posDebug = y / 2.75
local isCameraMoving = false
debugfontname = dxCreateFont("resources/fonts/arnamu.ttf",  15, false, "antialiased") or "default"

addEventHandler("onClientPreRender", root,
    function ()
        if IsFmodCoreCreated() and IsFmodStudioCreated() then
            local r1, r2 = set3DListenerPosition(getCameraFmod()[1], getCameraFmod()[2], getCameraFmod()[3], getCameraFmod()[4])

            -- render_engine()

            if DEBUGER.Info2D == true then
                local text = "Camera - [" .. rgbToHex(100, 220, 110) .. "" .. r1 .. "#ffffff]\n" .. r2 .. "\n\n"
                maxWidth1 = 0
                local lines = {}
                for line in text:gmatch("[^\n]+") do
                    local lineWidth = dxGetTextWidth(line, debugfontsize, debugfontname, false)
                    if lineWidth > maxWidth1 then
                        maxWidth1 = lineWidth
                    end
                    table.insert(lines, line)
                end
                local lineHeight = dxGetFontHeight(debugfontsize, debugfontname)
                local textHeight1 = #lines * lineHeight
                local y2 = posDebug / 2 + textHeight1
                local totalHeight = y2 - (posDebug / 2 - 4)
                dxDrawImage(8, posDebug / 2 - 4, maxWidth1 + 10, totalHeight + 5, img.fone, 0, 0, 0)
                dxDrawText(text, 15, posDebug / 2, 0, 0, tocolor(255, 255, 255, 225), debugfontsize, debugfontname, "left", "top", false, false, false, true)


                if fmodArray then
                    local text
                    local nextblok = 10
                    dxDrawImage(8, y2 + nextblok, maxWidth2, 26 * #fmodArray, img.fone, 0, 0, 0)
                    for key, value in pairs(fmodArray) do
                        if type(value[1][2]) == "table" then
                            text = "[" .. key .. "]: " .. value[1][1] .. " " .. rgbToHex(100, 220, 110) .. "" .. inspect(value[1][2])
                        else
                            text = "[" .. key .. "]: " .. value[1][1] .. " -" .. rgbToHex(100, 220, 110) .. " " .. tostring(value[1][2])
                        end
                        local textWithoutColor = text:gsub("#%x%x%x%x%x%x", "")
                        local textWidth = dxGetTextWidth(textWithoutColor, debugfontsize, debugfontname, false)
                        if textWidth > maxWidth2 then
                            maxWidth2 = textWidth + 15
                        end
                        dxDrawText(text, 15, y2 + nextblok + 5 + key * 20, x - 50, y, tocolor(255, 255, 255, 225), debugfontsize, debugfontname, "left", "top", false, false, false, true)
                    end
                end

                local x, y = 8, y2 + 15 + (26 * #fmodArray) -- Начальная позиция для отрисовки строк
                local lineHeight = 25 -- Высота строки
                local paddingY = 5 -- Отступ по вертикали

                -- local allAudioZones = findAllAudioZones(getElementPosition(localPlayer))
                -- local streamingShape = pointShapeCache
                for i, data in ipairs(pointShapeCache) do
                    if getShapeStreamingState(data.name) == true then
                        local text = string.format("Streaming фигуры  %s",data.name )
                        local textWidth = dxGetTextWidth(text, debugfontsize, debugfontname)
                        local imageWidth = textWidth + 30 -- 30 for the text padding, 10 for the img.padding
                        dxDrawImage(x, y, imageWidth, lineHeight, img.none, 0, 0, 0)
                        dxDrawText(text, x + 15, y + 2, x + imageWidth, y + lineHeight, tocolor(255, 255, 255, 225), debugfontsize, debugfontname, "left", "top", false, false, false, true)
                        y = y + lineHeight + paddingY
                    end
                end
            end


            if DEBUGER.Info3D == true then
                DxDrawRenderAllShape()
            end
            if DEBUGER.InfoRadar == true then
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
                        dxDrawImage (x-size.x*1.1+size.x/2-sizeP.x/2+(-listenerRelativeX)*5,y-size.y*1.1+size.x/2-sizeP.y/2+(listenerRelativeY)*5, sizeP.x,sizeP.y, img.car, -rz+camRotZ, 0, 0 )
                    end
                end
            end


            if DEBUGER.InfoCPU == true then
                local textCPU = "Среднее время % CPU за 5sec.\n" .. fmodArray[0][1][2] .. " -> " .. resourceLoad
                local maxWidth3 = 0
                local lines3 = {}
                for line in textCPU:gmatch("[^\n]+") do
                    local lineWidth = dxGetTextWidth(line, debugfontsize, debugfontname, false)
                    if lineWidth > maxWidth3 then
                        maxWidth3 = lineWidth
                    end
                    table.insert(lines3, line)
                end
                local totalHeight3 = (#lines3 * dxGetFontHeight(debugfontsize, debugfontname)) + 5
                dxDrawImage(maxWidth1 + 25, posDebug / 2 - 4, maxWidth3 + 10, totalHeight3, img.visible, 0, 0, 0)
                dxDrawImage(maxWidth1 + 25, maxWidth3+30,  40, 40, img.fone, 0, 0, 0)
                if isCameraMoving then
                    dxDrawImage(maxWidth1+25, maxWidth3+30,40,40, img.enter, 0, 0, 0)
                end
                dxDrawText(textCPU, maxWidth1 + 30, posDebug / 2, 0, 0, tocolor(255, 255, 255, 225), debugfontsize, debugfontname, "left", "top", false, false, false, true)
            end
            FMOD_Update()
        end
    end)



addEventHandler( "onClientResourceStart", getRootElement( ),
    function ( startedRes )
        -- iprint(CCLientReturnCore())
        if getResourceName( startedRes ) == "fmod" then
            setTimer ( function(d)
                if not isInitMapFMOD() then
                    initVehicleArray()
                    initMapFMOD()
                    initArrayF(d)
                    bankList()
                    generateHashPoints()
                    setTimer(updateResourceLoad, 5000, 0,fmodArray[0][1][2]) -- CPU CHECK
                    addEventHandler("onClientPreRender", root, post_render) -- Рендер при обновлении позиции камеры
                    allShape = getAllShapeNames()
                    -- initAllEvent(allShape)
                    setTimer(updateStreamingShape, 250, 0,pointShapeCache)
                    for _, component in ipairs( components ) do
                        setPlayerHudComponentVisible( component, false )
                    end
                end
            end, 250,1,getResourceName( startedRes ))
        end
    end
)

initArrayF = function(resname)
    fmodArray = {
        [0] = {[1] = {"Название ресурса",resname}},
        [1] = {[1] = {"Создание ядра",{createFmodCore()} }},
        [2] = {[1] = {"Инициализация ядра",{initFmodCore(512,"FMOD_INIT_3D_RIGHTHANDED")} }},
        [3] = {[1] = {"Создание ядра студии",{createFmodStudioCore()} }},
        [4] = {[1] = {"Инициализация ядра студии",{initFmodStudio(512,"FMOD_STUDIO_INIT_LIVEUPDATE","FMOD_INIT_3D_RIGHTHANDED")} }},
        [5] = {[1] = {"Состояние ядра",IsFmodCoreCreated()}},
        [6] = {[1] = {"Состояние ядра студии",IsFmodStudioCreated()}},
    }
end

bankList = function()
    clearChatBox()
    for i,v in ipairs(banki) do
        local strState = ""..rgbToHex(155, 155, 222)..""..string.gsub(v, "resources\\bank\\", "").." "..rgbToHex(255, 200, 0)..""..tostring(loadFmodBankFile(getFmodDirectory("fmod",v)))..""..rgbToHex(0,225, 0).."  "..getFmodBankLoadingState(tostring(getFmodDirectory("fmod",v)))..""
        triggerEvent('addNotification', root, strState:gsub("true", "") , "accept", 10000, "right-top")
    end
end

function onQuitGame( stoppedRes )
    if (getResourceName( stoppedRes ) == "fmod") then
        if isTimer ( ggTimer ) then killTimer ( ggTimer ) end
        if isInitMapFMOD() then
            for i,v in ipairs(banki) do
                local strState = ""..rgbToHex(155, 155, 222)..""..string.gsub(v, "resources\\bank\\", "").." "..rgbToHex(255, 200, 0)..""..tostring(unloadFmodBankFile(getFmodDirectory("fmod",v)))..""..rgbToHex(255,0, 0).." "..getFmodBankLoadingState(tostring(getFmodDirectory("fmod",v)))..""
                triggerEvent('addNotification', root, strState:gsub("true", "") , "warning", 7000, "right-top")
            end
            globalCloseFmod()
            deleteMapFMOD()
            removeEventHandler("onClientPreRender", root, post_render)
            deleteVehicleArray()
        end
    end
end
addEventHandler( "onClientPlayerQuit",   getRootElement(), onQuitGame )
addEventHandler( "onClientResourceStop", getRootElement( ), onQuitGame )


function updateResourceLoad(resname)
    local c, r = getPerformanceStats("Lua timing", resname)
    local overall = 0
    for i, v in pairs(r) do
        if not v[2] or v[2] == "-" then
            r[i] = nil
        else
            overall = overall + tonumber(tostring(v[2]):sub(0, -2))
        end
    end
    resourceLoad = overall .. "%"
end



function checkCameraMovement()
    local camX, camY, camZ, camToX, camToY, camToZ = getCameraMatrix()
    if camX ~= lastCamX or camY ~= lastCamY or camZ ~= lastCamZ or camToX ~= lastCamToX or camToY ~= lastCamToY or camToZ ~= lastCamToZ then
        isCameraMoving = true
    else
        isCameraMoving = false
    end
    lastCamX, lastCamY, lastCamZ, lastCamToX, lastCamToY, lastCamToZ = camX, camY, camZ, camToX, camToY, camToZ
end



post_render = function()
    checkCameraMovement()
    if isCameraMoving then
        checkPlayerZone()
        setAudioSeaZone(pointShapeCache)
    end
end







function onClientKeys(key, press)
    if key == "g" and press then

        for i, name in ipairs(listEvent1) do

        -- iprint(pointShapeCache)
        end
    end
end
-- addEventHandler("onClientKey", root, onClientKeys)


initAllEvent = function(localShape)
    for i,v in ipairs(localShape) do
        iprint(loadFmodEventForElement(v,getEventShapeGuid(v)))
        -- iprint(playFmodEventForElement(v,getEventShapeGuid(v)))
    end
end

-- Инициализируем переменную для отслеживания предыдущего состояния стриминга
local prevStreamingStates = {}

function updateStreamingShape(localShapes)
    local playerX, playerY, playerZ = getElementPosition(localPlayer) -- Получаем позицию игрока один раз

    for _, data in ipairs(localShapes) do
        local currentDistance = getDistanceBetweenPoints2D(data.pos.x, data.pos.y, playerX, playerY)
        local currentState = currentDistance / 1.7 <= data.radius

        -- Проверяем, изменилось ли состояние стриминга
        if prevStreamingStates[data.name] ~= currentState then
            prevStreamingStates[data.name] = currentState -- Обновляем предыдущее состояние

            -- Выполняем действие при изменении состояния стриминга
            if currentState then
                outputChatBox("Объект вошел в радиус стриминга: " .. data.name)
                loadFmodEventForElement(data.name,getEventShapeGuid(data.name))
                playFmodEventForElement(data.name,getEventShapeGuid(data.name))
            else
                outputChatBox("Объект вышел из радиуса стриминга: " .. data.name)
                releaseEventInstanceForElement(data.name,getEventShapeGuid(data.name))
            end

            -- Устанавливаем состояние стриминга
            setShapeStreamingState(data.name, currentState)
        end
    end
end


setAudioSeaZone = function(localShapes)
    local playerX, playerY, playerZ = getCameraFmod()[1].x,getCameraFmod()[1].y,getCameraFmod()[1].z
    local insideShape, shapeName = checkPointInsideShapeNoAxisZ(playerX, playerY, playerZ)

    for _, data in ipairs(localShapes) do
        if getShapeStreamingState(data.name) then
            local x, y, z
            if insideShape and shapeName == data.name then
                x, y, z = playerX, playerY,math.min(playerZ, getShapeAxisZ(data.name))
            else
                x, y, z = getNearestCoordinateOnShape(data.name, playerX, playerY, playerZ)
                z = math.min(playerZ, getShapeAxisZ(data.name))
            end

            -- drawCircle3D(x, y, z , 0.2, tocolor(255, 255, 0, 200), segments)
            -- dxDrawLine3D(playerX, playerY, playerZ, x, y, z, tocolor(150, 75, 0, 230), size)

            setFmodEvent3DPositionForElement(data.name,getEventShapeGuid(data.name),Vector3(x,y,z))

        end
    end
end

            -- dxDrawText(data.name.." dist.."..currentDistance, x/2, y/2+15*i, 0, 0, tocolor(255, 255, 255, 225), debugfontsize, debugfontname, "left", "top", false, false, false, true)



        -- local x,y,z = getElementPosition(localPlayer)
        -- if checkPointInsideShape(x,y,z) then
        --     local zone = getCurrentShapeName(localPlayer)
        --     if zone then
        --         local _,_,centerZ,_ = getShapeCenterAndRadius(name)
        --     end
        -- else
        --     setFmodEvent3DPositionForElement(name,getEventShapeGuid(name),Vector3(getNearestCoordinateToShape(name,localPlayer)))
        -- end

                    -- iprint(createFmodStreamSound("http://pub0201.101.ru:8000/stream/pull/aac/64/301","FMOD_CREATESTREAM"))
                    -- iprint(playFmodSound("http://pub0201.101.ru:8000/stream/pull/aac/64/301"))
