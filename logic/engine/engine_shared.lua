-- Получение типа топлива у двигателя по названию мотора
function getFuelTypeByEngine(engineName)
    for fuelType, engines in pairs(engine_parametr) do
        if engines[engineName] then
            return fuelType
        end
    end
    return nil
end

-- Получение типа автомобиля по айди машины
function getVehicleTypeById(vehicleId)
    for vehicleType, models in pairs(vehicle_types) do
        for _, ids in pairs(models) do
            for _, id in ipairs(ids) do
                if id == vehicleId then
                    return vehicleType
                end
            end
        end
    end
    return nil
end

-- Получение названия двигателя по айди машины
function getEngineNameByVehicleId(vehicleId)
    for vehicleType, models in pairs(vehicle_types) do
        for engineName, ids in pairs(models) do
            for _, id in ipairs(ids) do
                if id == vehicleId then
                    return engineName
                end
            end
        end
    end
    return nil
end

function getEngineParametersByVehicleId(vehicleId)
    local vehicleType, vehicleEngine = getVehicleTypeById(vehicleId)
    if vehicleType and vehicleEngine then
        local engineParams = engine_parametr[vehicleType][vehicleEngine]
        if engineParams then
            return engineParams
        end
    end
    return nil
end

function getCalculateGear(vehicle)
    if vehicle then
        local model = getElementModel(vehicle)
        local data = getEngineParametrFromID(model)
        if data.MAX_GEAR == nil then
             return getOriginalHandling(model).numberOfGears
        else
             return data.MAX_GEAR
        end

    end
end


function getEngineParametrFromID(model)
    local vehicleEngine = getEngineNameByVehicleId(model)
    local typeFule = getFuelTypeByEngine(vehicleEngine)

    assert(vehicleEngine, "Название двигателя не определено для модели: " .. tostring(model))
    assert(typeFule, "Тип топлива не определен для модели: " .. tostring(model))

    return engine_parametr[typeFule][vehicleEngine]
end

function calculateGearRatios(vehicle, maxRPM, startRatio)
    local ratios = {}
    local handling = getVehicleHandling(vehicle)
    local gears = getCalculateGear(vehicle)

    -- local gears = math.max(4, handling.numberOfGears)
    local maxVelocity = handling.maxVelocity
    local acc = handling.engineAcceleration
    local drag = handling.dragCoeff
    local c = ((acc*maxVelocity) / maxRPM)*(maxRPM*0.00175)
    local c = startRatio or ((acc / drag / maxVelocity) * pi) * 20

    local curGear, curRatio = 1, 0
    local mRPM = maxVelocity * 100
    mRPM = ((maxRPM*gears)/mRPM)*maxRPM

    repeat
        if mRPM/curGear > maxRPM*curRatio then
            curRatio = curRatio+0.1/curGear
        else
            ratios[curGear] = curRatio*0.95
            curGear = curGear+1
            curRatio = 0
        end
    until #ratios == gears

    ratios[0] = 0
    ratios[-1] = ratios[1]
    return ratios
end