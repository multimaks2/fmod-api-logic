linesearchdist = 100

-- local playerInZone = false -- Переменная для отслеживания нахождения игрока в аудиозоне
-- local currentZoneName = nil -- Переменная для хранения имени текущей аудиозоны
-- local zoneChangeTimer = nil -- Таймер для задержки проверки входа и выхода из аудиозоны

pointShapeCache = {}

-- Определение таблицы с точками
pointShape = {

        [1] = {
            [0] = "Озеро", ["ShapeAxisZ"] = 2, ["eventGUID"] = "{d44da786-160e-4e23-8ea8-167f95f0155a}",
{ x = 2271.428, y = 1757.825, z = 8.535},
{ x = 2291.536, y = 1852.171, z = 8.634},
{ x = 2292.102, y = 1898.981, z = 8.236},
{ x = 2298.484, y = 1948.528, z = 8.328},
{ x = 2295.638, y = 1995.410, z = 8.643},
{ x = 2268.560, y = 1995.615, z = 8.408},
{ x = 2257.966, y = 1976.058, z = 8.325},
{ x = 2247.027, y = 1934.968, z = 8.309},
{ x = 2235.009, y = 1920.819, z = 8.420},
{ x = 2225.544, y = 1888.205, z = 8.099},
{ x = 2214.492, y = 1862.237, z = 7.727},
{ x = 2201.047, y = 1838.195, z = 7.812},
{ x = 2170.138, y = 1798.114, z = 7.810},
{ x = 2118.456, y = 1756.286, z = 8.107},
{ x = 2089.808, y = 1740.861, z = 8.182},
{ x = 2058.698, y = 1729.540, z = 8.169},
{ x = 2040.285, y = 1724.508, z = 7.758},
{ x = 2009.246, y = 1719.212, z = 8.087},
{ x = 1983.869, y = 1717.877, z = 7.959},
{ x = 1924.735, y = 1717.477, z = 8.195},
{ x = 1884.588, y = 1718.722, z = 7.790},
{ x = 1828.427, y = 1732.745, z = 8.280},
{ x = 1799.851, y = 1748.355, z = 8.119},
{ x = 1777.358, y = 1766.657, z = 7.876},
{ x = 1762.547, y = 1782.972, z = 7.880},
{ x = 1743.499, y = 1810.886, z = 8.023},
{ x = 1731.581, y = 1838.585, z = 8.023},
{ x = 1725.123, y = 1862.483, z = 8.166},
{ x = 1722.097, y = 1885.826, z = 8.225},
{ x = 1723.072, y = 1914.296, z = 7.695},
{ x = 1728.765, y = 1942.812, z = 7.771},
{ x = 1738.540, y = 1969.611, z = 7.920},
{ x = 1748.786, y = 1988.568, z = 7.727},
{ x = 1757.363, y = 2008.915, z = 7.707},
{ x = 1764.703, y = 2041.208, z = 8.122},
{ x = 1646.972, y = 2041.540, z = 8.193},
{ x = 1645.366, y = 2046.262, z = 8.100},
{ x = 1129.264, y = 2045.972, z = 7.906},
{ x = 1129.161, y = 1857.088, z = 7.807},
{ x = 621.328, y = 1854.460, z = 7.615},
{ x = 620.226, y = 2002.136, z = 8.576},
{ x = 593.247, y = 1982.092, z = 8.740},
{ x = 580.711, y = 1962.899, z = 8.843},
{ x = 579.940, y = 1942.790, z = 8.889},
{ x = 596.574, y = 1905.169, z = 8.893},
{ x = 600.697, y = 1888.764, z = 8.901},
{ x = 600.686, y = 1864.956, z = 8.950},
{ x = 599.357, y = 1854.126, z = 8.893},
{ x = 594.154, y = 1841.230, z = 8.818},
{ x = 575.667, y = 1818.266, z = 8.823},
{ x = 532.427, y = 1763.162, z = 8.602},
{ x = 545.243, y = 1710.262, z = 8.328},
{ x = 559.975, y = 1676.323, z = 8.299},
{ x = 582.887, y = 1652.668, z = 8.124},
{ x = 599.476, y = 1634.743, z = 8.299},
{ x = 620.341, y = 1597.149, z = 8.315},
{ x = 633.539, y = 1575.481, z = 7.989},
{ x = 651.225, y = 1526.393, z = 8.470},
{ x = 658.248, y = 1501.666, z = 7.892},
{ x = 660.786, y = 1491.217, z = 8.085},
{ x = 664.566, y = 1462.872, z = 7.961},
{ x = 664.960, y = 1437.306, z = 7.906},
{ x = 663.069, y = 1416.614, z = 7.658},
{ x = 635.697, y = 1333.683, z = 8.109},
{ x = 668.948, y = 1307.968, z = 7.856},
{ x = 710.861, y = 1287.711, z = 7.490},
{ x = 748.251, y = 1261.333, z = 7.490},
{ x = 886.452, y = 1239.007, z = 8.103},
{ x = 919.536, y = 1241.812, z = 7.490},
{ x = 972.307, y = 1247.221, z = 7.490},
{ x = 1003.796, y = 1262.519, z = 8.159},
{ x = 1053.751, y = 1280.671, z = 8.298},
{ x = 1082.428, y = 1286.198, z = 7.960},
{ x = 1223.419, y = 1291.929, z = 7.759},
{ x = 1420.724, y = 1293.753, z = 8.478},
{ x = 1476.161, y = 1290.680, z = 8.411},
{ x = 1503.423, y = 1275.635, z = 8.755},
{ x = 1503.621, y = 1254.489, z = 8.661},
{ x = 1505.773, y = 558.724, z = 7.490},
{ x = 1488.279, y = 516.341, z = 7.490},
{ x = 1470.778, y = 503.667, z = 7.490},
{ x = 1407.915, y = 492.929, z = 7.640},
{ x = 1313.476, y = 502.715, z = 7.490},
{ x = 1288.425, y = 508.893, z = 7.793},
{ x = 1259.673, y = 522.963, z = 7.490},
{ x = 1222.702, y = 551.514, z = 7.490},
{ x = 1189.798, y = 565.192, z = 7.639},
{ x = 1132.086, y = 583.178, z = 7.490},
{ x = 1091.778, y = 614.349, z = 7.703},
{ x = 1081.890, y = 645.092, z = 7.640},
{ x = 1081.226, y = 698.010, z = 7.490},
{ x = 1082.495, y = 725.546, z = 7.490},
{ x = 1047.616, y = 800.680, z = 7.490},
{ x = 1033.284, y = 811.552, z = 7.550},
{ x = 991.183, y = 832.146, z = 7.490},
{ x = 926.900, y = 866.050, z = 7.490},
{ x = 848.834, y = 959.804, z = 7.519},
{ x = 825.129, y = 1031.863, z = 7.490},
{ x = 780.596, y = 1076.850, z = 7.462},
{ x = 721.834, y = 1091.488, z = 7.898},
{ x = 680.035, y = 1103.900, z = 7.490},
{ x = 662.345, y = 1128.758, z = 7.490},
{ x = 632.211, y = 1136.207, z = 7.490},
{ x = 608.971, y = 1123.228, z = 8.249},
{ x = 601.532, y = 1121.823, z = 8.243},
{ x = 583.851, y = 1105.609, z = 7.595},
{ x = 547.654, y = 1094.099, z = 8.231},
{ x = 571.338, y = 998.628, z = 8.003},
{ x = 595.601, y = 941.604, z = 8.416},
{ x = 600.926, y = 941.559, z = 7.490},
{ x = 603.493, y = 931.140, z = 7.964},
{ x = 816.750, y = 572.124, z = 8.042},
{ x = 838.366, y = 526.317, z = 7.913},
{ x = 849.747, y = 513.660, z = 8.159},
{ x = 866.616, y = 486.804, z = 8.618},
{ x = 875.716, y = 463.177, z = 8.421},
{ x = 999.732, y = 409.308, z = 7.490},
{ x = 1286.812, y = 351.726, z = 8.819},
{ x = 1380.755, y = 321.853, z = 8.862},
{ x = 1466.170, y = 271.416, z = 8.786},
{ x = 1524.916, y = 213.081, z = 8.930},
{ x = 1567.914, y = 151.917, z = 8.826},
{ x = 1596.384, y = 92.385, z = 8.845},
{ x = 1620.769, y = 11.681, z = 8.731},
{ x = 1634.991, y = -72.643, z = 8.686},
{ x = 1627.341, y = -82.855, z = 8.789},
{ x = 1692.759, y = -313.963, z = 8.881},
{ x = 1759.303, y = -606.463, z = 8.807},
{ x = 1783.662, y = -621.486, z = 8.073},
{ x = 1772.202, y = -659.821, z = 8.198},
{ x = 1771.341, y = -678.678, z = 7.640},
{ x = 1761.150, y = -727.418, z = 7.640},
{ x = 1725.253, y = -758.045, z = 8.558},
{ x = 1694.918, y = -776.959, z = 8.125},
{ x = 1532.371, y = -948.010, z = 8.268},
{ x = 1512.327, y = -965.545, z = 8.049},
{ x = 1339.137, y = -1202.538, z = 8.520},
{ x = 1315.654, y = -1230.614, z = 8.629},
{ x = 1303.817, y = -1244.998, z = 8.661},
{ x = 1266.018, y = -1330.654, z = 8.129},
{ x = 1186.213, y = -1512.322, z = 8.641},
{ x = 1160.174, y = -1567.556, z = 8.220},
{ x = 1185.823, y = -1584.212, z = 7.490},
{ x = 1196.428, y = -1571.599, z = 7.490},
{ x = 1209.267, y = -1563.434, z = 7.640},
{ x = 1231.290, y = -1558.021, z = 7.274},
{ x = 1253.073, y = -1564.293, z = 7.260},
{ x = 1270.416, y = -1576.954, z = 7.580},
{ x = 1282.964, y = -1599.621, z = 7.610},
{ x = 1282.936, y = -1623.950, z = 7.490},
{ x = 1275.669, y = -1639.927, z = 7.590},
{ x = 1301.146, y = -1654.781, z = 7.490},
{ x = 1300.774, y = -1658.033, z = 7.840},
{ x = 1299.193, y = -1681.989, z = 7.630},
{ x = 1329.334, y = -1716.863, z = 7.490},
{ x = 1311.369, y = -1740.789, z = 7.640},
{ x = 1294.670, y = -1732.889, z = 7.490},
{ x = 1274.419, y = -1714.547, z = 7.640},
{ x = 1266.937, y = -1708.489, z = 7.767},
{ x = 1201.383, y = -1809.713, z = 7.525},
{ x = 1657.636, y = -2074.689, z = 7.637},
{ x = 1681.107, y = -2045.152, z = 7.732},
{ x = 1710.062, y = -1990.082, z = 7.978},
{ x = 1727.212, y = -1962.547, z = 8.011},
{ x = 1736.868, y = -1965.732, z = 8.230},
{ x = 1758.276, y = -1934.948, z = 8.195},
{ x = 1828.025, y = -1852.647, z = 8.089},
{ x = 1910.315, y = -1758.359, z = 8.126},
{ x = 1957.348, y = -1706.470, z = 8.106},
{ x = 2011.562, y = -1651.665, z = 8.102},
{ x = 2050.371, y = -1609.753, z = 8.051},
{ x = 2073.556, y = -1583.012, z = 7.584},
{ x = 2091.766, y = -1561.768, z = 8.183},
{ x = 2116.615, y = -1523.545, z = 8.506},
{ x = 2145.671, y = -1480.857, z = 8.113},
{ x = 2141.868, y = -1473.773, z = 7.835},
{ x = 2137.555, y = -1465.739, z = 8.442},
{ x = 2162.900, y = -1429.430, z = 8.567},
{ x = 2169.713, y = -1427.614, z = 8.111},
{ x = 2178.090, y = -1430.592, z = 7.985},
{ x = 2258.945, y = -1296.943, z = 7.908},
{ x = 2284.491, y = -1251.440, z = 7.830},
{ x = 2324.192, y = -1180.639, z = 7.972},
{ x = 2353.499, y = -1125.828, z = 7.729},
{ x = 2369.687, y = -1094.822, z = 8.101},
{ x = 2358.908, y = -1088.594, z = 7.796},
{ x = 2358.664, y = -1085.244, z = 7.668},
{ x = 2378.950, y = -1043.909, z = 7.687},
{ x = 2395.128, y = -1041.282, z = 8.125},
{ x = 2431.756, y = -953.045, z = 8.693},
{ x = 2458.568, y = -879.624, z = 8.288},
{ x = 2456.866, y = -871.271, z = 7.918},
{ x = 2469.993, y = -827.773, z = 7.691},
{ x = 2474.444, y = -827.581, z = 7.653},
{ x = 2481.920, y = -803.906, z = 7.821},
{ x = 2468.028, y = -793.972, z = 7.656},
{ x = 2463.811, y = -781.836, z = 7.893},
{ x = 2462.967, y = -771.863, z = 7.789},
{ x = 2465.898, y = -763.671, z = 8.135},
{ x = 2469.881, y = -753.962, z = 7.936},
{ x = 2472.963, y = -692.594, z = 7.609},
{ x = 2486.271, y = -624.106, z = 7.346},
{ x = 2495.647, y = -575.588, z = 7.663},
{ x = 2503.240, y = -535.719, z = 7.849},
{ x = 2508.958, y = -505.602, z = 7.899},
{ x = 2513.332, y = -477.782, z = 7.867},
{ x = 2518.333, y = -453.429, z = 7.667},
{ x = 2525.192, y = -426.475, z = 7.457},
{ x = 2534.973, y = -404.667, z = 7.530},
{ x = 2548.234, y = -387.440, z = 7.588},
{ x = 2554.941, y = -372.326, z = 8.467},
{ x = 2557.890, y = -347.755, z = 8.885},
{ x = 2558.208, y = -323.766, z = 7.589},
{ x = 2557.942, y = -301.389, z = 7.808},
{ x = 2557.920, y = -280.660, z = 8.002},
{ x = 2557.153, y = -257.464, z = 8.086},
{ x = 2555.359, y = -231.857, z = 7.863},
{ x = 2553.526, y = -208.117, z = 7.477},
{ x = 2551.384, y = -182.530, z = 7.686},
{ x = 2547.747, y = -147.700, z = 7.663},
{ x = 2546.640, y = -137.671, z = 7.545},
{ x = 2519.952, y = -136.097, z = 7.899},
{ x = 2509.158, y = -124.121, z = 8.052},
{ x = 2498.957, y = -94.968, z = 7.745},
{ x = 2494.498, y = -72.570, z = 7.991},
{ x = 2485.912, y = -48.078, z = 8.013},
{ x = 2429.318, y = 180.412, z = 7.666},
{ x = 2412.892, y = 242.909, z = 7.656},
{ x = 2396.395, y = 298.296, z = 7.835},
{ x = 2373.488, y = 365.748, z = 7.688},
{ x = 2359.365, y = 409.928, z = 7.786},
{ x = 2347.984, y = 465.703, z = 7.809},
{ x = 2340.731, y = 516.109, z = 7.373},
{ x = 2334.067, y = 560.003, z = 7.898},
{ x = 2328.410, y = 626.436, z = 7.645},
{ x = 2319.319, y = 699.583, z = 8.328},
{ x = 2313.149, y = 759.740, z = 7.720},
{ x = 2308.119, y = 807.524, z = 7.586},
{ x = 2303.714, y = 859.538, z = 8.111},
{ x = 2298.623, y = 908.974, z = 8.100},
{ x = 2293.162, y = 970.017, z = 7.681},
{ x = 2290.253, y = 1021.303, z = 7.814},
{ x = 2286.114, y = 1080.791, z = 8.198},
{ x = 2283.563, y = 1132.916, z = 8.042},
{ x = 2280.586, y = 1181.805, z = 7.770},
{ x = 2278.570, y = 1226.516, z = 8.022},
{ x = 2274.691, y = 1284.360, z = 8.202},
{ x = 2271.835, y = 1332.317, z = 7.880},
{ x = 2269.908, y = 1386.167, z = 7.763},
{ x = 2269.445, y = 1437.544, z = 7.929},
{ x = 2269.545, y = 1483.106, z = 7.907},
{ x = 2268.933, y = 1528.667, z = 8.054},
{ x = 2268.907, y = 1580.854, z = 7.965},
{ x = 2270.577, y = 1622.059, z = 7.704},
{ x = 2273.395, y = 1712.043, z = 8.085},

        },
--         [2] = {
--             [0] = "", ["ShapeAxisZ"] = 1, ["eventGUID"] = "",
--         },
--         [3] = {
--             [0] = "", ["ShapeAxisZ"] = 16, ["eventGUID"] = "",
--         },
--         [4] = {
--             [0] = "", ["ShapeAxisZ"] = 1,["eventGUID"] = "",
--         },
}

generateHashPoints = function()
    local shapeNames = getAllShapeNames()
    for index, name in ipairs(shapeNames) do
        local centerX, centerY, centerZ, maxRadius = getShapeCenterAndRadius(name)
        local AverageZ = getAverageZForShape(name)
        table.insert(pointShapeCache, {pos = Vector3(centerX, centerY, centerZ),name = name, radius = maxRadius,streamIn = false,AverageZ = AverageZ,eventGUID = shapeNames["eventGUID"]})
    end
    -- iprint(pointShapeCache)
end


function setShapeStreamingState(shapeName, shouldStreamIn)
    local currentState = getShapeStreamingState(shapeName) -- Получаем текущее состояние стриминга

    if currentState ~= nil and currentState ~= shouldStreamIn then
        for i = 1, #pointShapeCache do
            if pointShapeCache[i].name == shapeName then
                pointShapeCache[i].streamIn = shouldStreamIn
                return true
            end
        end
    end

    return false -- Если запись не найдена или состояние не изменилось, возвращаем false
end

function getShapeStreamingState(shapeName)
    for i = 1, #pointShapeCache do
        if pointShapeCache[i].name == shapeName then
            return pointShapeCache[i].streamIn
        end
    end
    return nil -- Если запись не найдена, возвращаем nil
end

function getEventGUIDFromCacheForShape(shapeName)
    for i = 1, #pointShapeCache do
        if pointShapeCache[i].name == shapeName then
            return pointShapeCache[i].eventGUID
        end
    end
    return nil
end


-- Функция для определения, находится ли точка внутри многоугольника
function isPointInsidePolygon(x, y, z, polygon)
    local oddNodes = false
    local j = #polygon

    for i = 1, #polygon do
        local xi, yi, zi = polygon[i].x, polygon[i].y, polygon[i].z
        local xj, yj, zj = polygon[j].x, polygon[j].y, polygon[j].z

        if (yi < y and yj >= y or yj < y and yi >= y) and (xi <= x or xj <= x) then
            if xi + (y - yi) / (yj - yi) * (xj - xi) < x then
                oddNodes = not oddNodes
            end
        end

        j = i
    end

    return oddNodes
end

-- Проверяем, находится ли точка (x, y, z) внутри фигуры pointShape с учетом ShapeAxisZ
function checkPointInsideShape(x, y, z)
    for i = 1, #pointShape do
        local shape = pointShape[i]
        local shapeAxisZ = shape.ShapeAxisZ or 0 -- Если ShapeAxisZ не определена, то считаем ее равной 0
        if isPointInsidePolygon(x, y, z, shape) and z >= shape[1].z and z <= shape[1].z + shapeAxisZ then
            return true
        end
    end

    return false
end


-- Проверяем, находится ли точка (x, y, z) внутри фигуры pointShape без учета ShapeAxisZ
function checkPointInsideShapeNoAxisZ(x, y, z)
    for i = 1, #pointShape do
        local shape = pointShape[i]
        if isPointInsidePolygon(x, y, z, shape) then
            return true, shape[0] -- Возвращаем истину и название фигуры
        end
    end

    return false, nil -- Если точка не находится внутри ни одной фигуры, возвращаем ложь и nil
end



-- Функция для поиска ближайшей вершины фигуры к заданной позиции
function findNearestVertex(x, y, z)
    local nearestVertex
    local nearestDistance = 10

    for i = 1, #pointShape do
        for j = 1, #pointShape[i] do
            local currentPoint = pointShape[i][j]
            local x1, y1, z1 = currentPoint.x, currentPoint.y, currentPoint.z

            -- Используем функцию getDistanceBetweenPoints3D для вычисления 3D расстояния
            local distance = getDistanceBetweenPoints3D(x, y, z, x1, y1, z1)

            if distance < nearestDistance then
                nearestDistance = distance
                nearestVertex = currentPoint
            end
        end
    end

    return nearestVertex, nearestDistance
end

function findAllAudioZones(x, y, z)
    local allZones = {}

    for i = 1, #pointShape do
        local zone = pointShape[i]
        local nearestDistance = 10^10 -- Исходно устанавливаем большое расстояние для каждой зоны
        local nearestPoint = nil

        for j = 1, #zone do
            local currentPoint = zone[j]
            local nextPointIndex = (j % #zone) + 1
            local nextPoint = zone[nextPointIndex]

            local x1, y1, z1 = currentPoint.x, currentPoint.y, currentPoint.z
            local x2, y2, z2 = nextPoint.x, nextPoint.y, nextPoint.z

            local nearestX, nearestY, nearestZ = findNearestPointOnLine(x, y, z, x1, y1, z1, x2, y2, z2)
            local distance = getDistanceBetweenPoints3D(x, y, z, nearestX, nearestY, nearestZ)

            if distance < nearestDistance then
                nearestDistance = distance
                nearestPoint = { x = nearestX, y = nearestY, z = nearestZ }
            end
        end

        table.insert(allZones, { name = zone[0], distance = nearestDistance, nearestPoint = nearestPoint })
    end

    return allZones
end


function findNearestAudioZone(x, y, z)
    local nearestZone = nil
    local nearestDistance = 10^10 -- Исходно устанавливаем большое расстояние

    for i = 1, #pointShape do
        local zone = pointShape[i]
        for j = 2, #pointShape[i] do -- Начинаем с 2, чтобы пропустить название зоны (находится в [1])
            local point = pointShape[i][j]
            local distance = getDistanceBetweenPoints3D(x, y, z, point.x, point.y, point.z)
            if distance < nearestDistance then
                nearestDistance = distance
                nearestZone = zone[0] -- Название зоны находится в [0]
            end
        end
    end

    return { name = nearestZone, distance = nearestDistance }
end


-- Функция для поиска ближайшей точки на пути между двумя точками
function findNearestPointOnLine(x, y, z, x1, y1, z1, x2, y2, z2)
    local dx, dy, dz = x2 - x1, y2 - y1, z2 - z1
    local t = ((x - x1) * dx + (y - y1) * dy + (z - z1) * dz) / (dx * dx + dy * dy + dz * dz)
    t = math.max(0, math.min(1, t))
    local nearestX, nearestY, nearestZ = x1 + t * dx, y1 + t * dy, z1 + t * dz
    return nearestX, nearestY, nearestZ
end

-- Функция для получения случайной точки внутри заданной фигуры
function getRandomPointInsideShape(shapeName)
    for i = 1, #pointShape do
        local currentShape = pointShape[i]
        if currentShape[0] == shapeName then
            local minX, minY, minZ, maxX, maxY, maxZ = 10^10, 10^10, 10^10, -10^10, -10^10, -10^10

            -- Находим границы фигуры
            for j = 1, #currentShape do
                local point = currentShape[j]
                local x, y, z = point.x, point.y, point.z
                minX = math.min(minX, x)
                minY = math.min(minY, y)
                minZ = math.min(minZ, z)
                maxX = math.max(maxX, x)
                maxY = math.max(maxY, y)
                maxZ = math.max(maxZ, z)
            end

            local maxAttempts = 100 -- Максимальное количество попыток для генерации случайных координат

            for attempt = 1, maxAttempts do
                local randomX = math.random(minX, maxX)
                local randomY = math.random(minY, maxY)
                local randomZ = math.random(minZ, maxZ)

                -- Проверяем, находится ли точка внутри фигуры
                if isPointInsidePolygon(randomX, randomY, randomZ, currentShape) then
                    return randomX, randomY, randomZ -- Возвращаем координаты точки
                end
            end
        end
    end

    return nil -- В случае ошибки возвращаем nil
end


-- Функция для получения названия текущей фигуры на основе позиции игрока
function getCurrentShapeName(playerElement)
    local playerX, playerY, playerZ = getElementPosition(playerElement)

    for i = 1, #pointShape do
        if isPointInsidePolygon(playerX, playerY, playerZ, pointShape[i]) then
            return pointShape[i][0]
        end
    end

    return nil
end

function getShapeInfo(shapeName) -- getShapeInfo(shapeName): Получить информацию о фигуре по её имени.
    for i = 1, #pointShape do
        if pointShape[i][0] == shapeName then
            return pointShape[i]
        end
end
return nil
end

function getShapeAxisZ(shapeName) -- getShapeAxisZ(shapeName): Получить высоту фигуры (ShapeAxisZ) по её имени.
    local shapeInfo = getShapeInfo(shapeName)
    if shapeInfo then
        return shapeInfo["ShapeAxisZ"]
    end
    return nil
end

function getEventShapeGuid(shapeName) -- getShapeAxisZ(shapeName): Получить высоту фигуры (ShapeAxisZ) по её имени.
    local shapeInfo = getShapeInfo(shapeName)
    if shapeInfo then
        return shapeInfo["eventGUID"]
    end
    return nil
end

function setShapeAxisZ(shapeName, axisZ) -- setShapeAxisZ(shapeName, axisZ): Установить высоту фигуры (ShapeAxisZ) по её имени.
    local shapeInfo = getShapeInfo(shapeName)
    if shapeInfo then
        shapeInfo["ShapeAxisZ"] = axisZ
        return true
    end
    return false
end

function getAllShapeNames() -- Функция для получения всех имен фигур
    local shapeNames = {}
    for i = 1, #pointShape do
        if pointShape[i][0] then
            table.insert(shapeNames, pointShape[i][0])
        end
    end
    return shapeNames
end



-- Функция для получения центра и максимального радиуса фигуры по её имени
function getShapeCenterAndRadius(shapeName)
    for i = 1, #pointShape do
        if pointShape[i][0] == shapeName then
            local shape = pointShape[i]
            local centerX, centerY, centerZ = 0, 0, 0
            local maxRadius = 0

            for j = 1, #shape do
                centerX = centerX + shape[j].x
                centerY = centerY + shape[j].y
                centerZ = centerZ + shape[j].z
            end

            centerX = centerX / #shape
            centerY = centerY / #shape
            centerZ = centerZ / #shape

            for j = 1, #shape do
                local distance = getDistanceBetweenPoints3D(centerX, centerY, centerZ, shape[j].x, shape[j].y, shape[j].z)
                if distance > maxRadius then
                    maxRadius = distance
                end
            end

            return centerX, centerY, centerZ, maxRadius
        end
    end

    return nil, nil, nil, nil -- Возвращаем nil, если фигура с указанным именем не найдена
end

function drawCircle3D(x, y, z, radius, color, segments)
    segments = segments or 36 -- Количество сегментов по умолчанию (можете изменить по вашему желанию)

    local step = 360 / segments
    local lastX, lastY

    for angle = 0, 360, step do
        local currentX = x + math.cos(math.rad(angle)) * radius
        local currentY = y + math.sin(math.rad(angle)) * radius

        if lastX and lastY then
            dxDrawLine3D(lastX, lastY, z, currentX, currentY, z, color)
        end

        lastX, lastY = currentX, currentY
    end
end


function getNearestCoordinateOnShape(shapeName, playerX, playerY, playerZ)
    local shapeInfo = getShapeInfo(shapeName) -- Предполагается, что у вас уже есть функция getShapeInfo
    if not shapeInfo then
        return nil, nil, nil -- Возвращаем nil, если информация о фигуре не найдена
    end

    local nearestPointX, nearestPointY, nearestPointZ
    local nearestDistance = math.huge -- Инициализируем максимальным значением

    for j = 1, #shapeInfo do
        local currentPoint = shapeInfo[j]
        local nextPointIndex = (j % #shapeInfo) + 1
        local nextPoint = shapeInfo[nextPointIndex]

        local x1, y1, z1 = currentPoint.x, currentPoint.y, currentPoint.z
        local x2, y2, z2 = nextPoint.x, nextPoint.y, nextPoint.z

        local nearestX, nearestY, nearestZ = findNearestPointOnLine(playerX, playerY, playerZ, x1, y1, z1, x2, y2, z2)
        local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, nearestX, nearestY, nearestZ)

        if distance < nearestDistance then
            nearestDistance = distance
            nearestPointX, nearestPointY, nearestPointZ = nearestX, nearestY, nearestZ
        end
    end

    return nearestPointX, nearestPointY, nearestPointZ
end



-- Функция для получения среднего значения по оси Z у точек фигуры
function getAverageZForShape(shapeName)
    local shapeInfo = getShapeInfo(shapeName) -- Предполагается, что у вас уже есть функция getShapeInfo
    if shapeInfo then
        local currentShape = shapeInfo

        if #currentShape > 0 then
            local totalZ = 0

            for j = 1, #currentShape do
                local currentPoint = currentShape[j]
                totalZ = totalZ + currentPoint.z
            end

            return totalZ / #currentShape -- Среднее значение по оси Z
        end
    end

    return nil -- В случае ошибки возвращаем nil
end

-- Функция для получения значения AverageZ из кеша таблицы pointShapeCache по индексу фигуры
function getAverageZByIndex(index)
    if pointShapeCache[index] then
        return pointShapeCache[index].AverageZ
    end
    return false -- Если запись не найдена, возвращаем nil
end

-- Функция для получения значения AverageZ из кеша таблицы pointShapeCache по имени фигуры
function getAverageZByName(shapeName)
    for i = 1, #pointShapeCache do
        if pointShapeCache[i].name == shapeName then
            return pointShapeCache[i].AverageZ
        end
    end
    return nil -- Если запись не найдена, возвращаем nil
end


function getShapeCoordinates(shapeName, playerX, playerY, playerZ)
    local insideShape, name = checkPointInsideShapeNoAxisZ(playerX, playerY, playerZ)
    if insideShape then
        local x, y, z = playerX, playerY, playerZ
        return x, y, z
    else 
        local x,y,z = getNearestCoordinateOnShape(shapeName, playerX, playerY, playerZ)
        return x,y,z
    end
end