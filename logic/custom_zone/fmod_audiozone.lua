local screen_x, screen_y = guiGetScreenSize()

    local allAudioZones = findAllAudioZones(getElementPosition(localPlayer))
    local shapeNames = getAllShapeNames()
    local size = 4 -- толщина линии
DxDrawRenderAllShape = function()
    local playerX, playerY, playerZ = getElementPosition(localPlayer)
    --------------------------Секция-рендера-текста-------------------------------
    ------------------------------------------------------------------------------

    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------



    -------------------Секция-рендера-окружности-и-радиуса------------------------
    ------------------------------------------------------------------------------
    -- for i, name in ipairs(shapeNames) do
    --     local centerX, centerY, centerZ, maxRadius  = getShapeCenterAndRadius(name)
    --     local ShapeAxisZ = getShapeAxisZ(name)
    --     local segments = 128
    --     drawCircle3D(centerX, centerY, centerZ+ShapeAxisZ, maxRadius, tocolor(255, 0, 0, 200) , segments)
    --     drawCircle3D(centerX, centerY, centerZ+ShapeAxisZ,  .125, tocolor(255, 255, 0, 200) , segments)
    -- end
    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------

    -----------------------Секция-рендера-тела-фигуры-----------------------------
    ------------------------------------------------------------------------------
    for i, name in ipairs(shapeNames) do
        local centerX, centerY, centerZ, maxRadius = getShapeCenterAndRadius(name)
        local currentShape = getShapeInfo(name)
        if currentShape then
            for j = 1, #currentShape do
                local currentPoint = currentShape[j]
                local nextPointIndex = (j % #currentShape) + 1
                local nextPoint = currentShape[nextPointIndex]

                local x1, y1, z1 = currentPoint.x, currentPoint.y, currentPoint.z
                local x2, y2, z2 = nextPoint.x, nextPoint.y, nextPoint.z

                if 300 > getDistanceBetweenPoints3D(playerX, playerY, playerZ, x1,y1,z2) then
        
                    local ShapeAxisZ = getShapeAxisZ(name)
                    dxDrawLine3D(x1, y1, z1 , x1, y1 , z2 + ShapeAxisZ, tocolor(150, 255, 0, 230), size)
                    dxDrawLine3D(x1, y1, (z1+ShapeAxisZ) , x2 , y2 , (z2+ShapeAxisZ) , tocolor(10, 75, 0, 230), size)
                    dxDrawLine3D(x1, y1, z1, x2, y2, z2, tocolor(10, 75, 0, 230), size)
                end
            end
        end
    end
    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------

    --------------Секция-рендера-линии-к-ближайшей-точки-фигуры-------------------
    ------------------------------------------------------------------------------

        -- local toX,toY,toZ = getNearestCoordinateToShape(name,localPlayer)
        -- drawCircle3D(toX,toY,toZ+1,  .125, tocolor(255, 255, 0, 200) , segments)
        -- dxDrawLine3D(playerX, playerY, playerZ,toX,toY,toZ+1,tocolor(150, 75, 0, 230), size)

    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------
end




-- Создаем пользовательское событие для входа в аудиозону
addEvent("onPlayerEnterAudioZone", true)

-- Создаем пользовательское событие для выхода из аудиозоны
addEvent("onPlayerExitAudioZone", true)

-- Обработчик для события входа в аудиозону
addEventHandler("onPlayerEnterAudioZone", root, function(zoneName, playerElement)
    if zoneName then
        outputChatBox(""..getPlayerName(playerElement).." вошел в зону: " .. zoneName.."")

    end
end)

-- Обработчик для события выхода из аудиозоны
addEventHandler("onPlayerExitAudioZone", root, function(zoneName, playerElement)
    if zoneName then
        outputChatBox(""..getPlayerName(playerElement).." вышел из зоны: " .. zoneName.."")
    end
end)

-- Функция для проверки, входит ли игрок в аудиозону
function checkPlayerZone()
    local playerX, playerY, playerZ = getElementPosition(localPlayer)
    local insideShape = checkPointInsideShape(playerX, playerY, playerZ)
    if insideShape and not playerInZone then
        local nearestAudioZone = findNearestAudioZone(playerX, playerY, playerZ)
        local zoneName = nearestAudioZone.name
        currentZoneName = zoneName
        playerInZone = true
        triggerEvent("onPlayerEnterAudioZone", localPlayer, zoneName, localPlayer) -- Здесь передаем localPlayer вместо getLocalPlayer()
    elseif not insideShape and playerInZone then
        local zoneName = currentZoneName
        currentZoneName = nil
        playerInZone = false
        triggerEvent("onPlayerExitAudioZone", localPlayer, zoneName, localPlayer) -- Здесь передаем localPlayer вместо getLocalPlayer()
    end
end
