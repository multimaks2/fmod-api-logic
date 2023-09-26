components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted" }
streamedVehicles = {}
pi = math.pi

DEBUGER = {
    Info2D = true,
    Info3D = false,
    InfoCPU = false,
    InfoRadar = false,
}



function rgbToHex ( nR, nG, nB )
    nR = math.min(nR, 255)
    nG = math.min(nG, 255)
    nB = math.min(nB, 255)
    local sColor = "#"
    nR = string.format ( "%X", nR )
    sColor = sColor .. ( ( string.len ( nR ) == 1 ) and ( "0" .. nR ) or nR )
    nG = string.format ( "%X", nG )
    sColor = sColor .. ( ( string.len ( nG ) == 1 ) and ( "0" .. nG ) or nG )
    nB = string.format ( "%X", nB )
    sColor = sColor .. ( ( string.len ( nB ) == 1 ) and ( "0" .. nB ) or nB )
    return sColor
end

function getCameraFmod()
    local headPedPos = Vector3(getPedBonePosition(localPlayer, 6)) -- узнаем позицию головы
    local _, cameraMode = getCameraViewMode(localPlayer)
    local pCamera = getCamera()
    local cameraMatrix = pCamera.matrix
    local position = cameraMatrix.position
    local up = cameraMatrix.up
    local forward = cameraMatrix.forward
    return {Vector3(position.x,position.y,position.z), Vector3(forward.x,forward.y,forward.z), Vector3(up),Vector3(getElementVelocity(getPedOccupiedVehicle(localPlayer) or localPlayer)) }
end


banki =
    {
    "resources\\bank\\Master.bank",
    "resources\\bank\\Master.strings.bank",
    "resources\\bank\\All-Transport.bank",
    "resources\\bank\\Ambient.bank",

}

maxWidth1 = 0
maxWidth2 = 0
debugfontsize = 0.7
resourceLoad = 0

