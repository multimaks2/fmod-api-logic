function requestRoundRectangleShader(withoutFilled)
    local woF = not withoutFilled and ""
    return [[
	texture sourceTexture;
	float4 color = float4(1,1,1,1);
	bool textureLoad = false;
	bool textureRotated = false;
	float4 isRelative = 1;
	float4 radius = 0.2;
	float borderSoft = 0.01;
	bool colorOverwritten = true;
	]]..(woF or [[
	float2 borderThickness = float2(0.2,0.2);
	float radiusMultipler = 0.95;
	]])..[[

	SamplerState tSampler
	{
		Texture = sourceTexture;
		MinFilter = Linear;
		MagFilter = Linear;
		MipFilter = Linear;
	};

	float4 rndRect(float2 tex: TEXCOORD0, float4 _color : COLOR0):COLOR0{
		float4 result = textureLoad?tex2D(tSampler,textureRotated?tex.yx:tex)*color:color;
		float alp = 1;
		float2 tex_bk = tex;
		float2 dx = ddx(tex);
		float2 dy = ddy(tex);
		float2 dd = float2(length(float2(dx.x,dy.x)),length(float2(dx.y,dy.y)));
		float a = dd.x/dd.y;
		float2 center = 0.5*float2(1/(a<=1?a:1),a<=1?1:a);
		float4 nRadius;
		float aA = borderSoft*100;
		if(a<=1){
			tex.x /= a;
			aA *= dd.y;
			nRadius = float4(isRelative.x==1?radius.x/2:radius.x*dd.y,isRelative.y==1?radius.y/2:radius.y*dd.y,isRelative.z==1?radius.z/2:radius.z*dd.y,isRelative.w==1?radius.w/2:radius.w*dd.y);
		}
		else{
			tex.y *= a;
			aA *= dd.x;
			nRadius = float4(isRelative.x==1?radius.x/2:radius.x*dd.x,isRelative.y==1?radius.y/2:radius.y*dd.x,isRelative.z==1?radius.z/2:radius.z*dd.x,isRelative.w==1?radius.w/2:radius.w*dd.x);
		}

		float2 fixedPos = tex-center;
		float2 corner[] = {center-nRadius.x,center-nRadius.y,center-nRadius.z,center-nRadius.w};
		//LTCorner
		if(-fixedPos.x >= corner[0].x && -fixedPos.y >= corner[0].y)
		{
			float dis = distance(-fixedPos,corner[0]);
			alp = 1-(dis-nRadius.x+aA)/aA;
		}
		//RTCorner
		if(fixedPos.x >= corner[1].x && -fixedPos.y >= corner[1].y)
		{
			float dis = distance(float2(fixedPos.x,-fixedPos.y),corner[1]);
			alp = 1-(dis-nRadius.y+aA)/aA;
		}
		//RBCorner
		if(fixedPos.x >= corner[2].x && fixedPos.y >= corner[2].y)
		{
			float dis = distance(float2(fixedPos.x,fixedPos.y),corner[2]);
			alp = 1-(dis-nRadius.z+aA)/aA;
		}
		//LBCorner
		if(-fixedPos.x >= corner[3].x && fixedPos.y >= corner[3].y)
		{
			float dis = distance(float2(-fixedPos.x,fixedPos.y),corner[3]);
			alp = 1-(dis-nRadius.w+aA)/aA;
		}
		if (fixedPos.y <= 0 && -fixedPos.x <= corner[0].x && fixedPos.x <= corner[1].x && (nRadius[0] || nRadius[1])){
			alp = (fixedPos.y+center.y)/aA;
		}else if (fixedPos.y >= 0 && -fixedPos.x <= corner[3].x && fixedPos.x <= corner[2].x && (nRadius[2] || nRadius[3])){
			alp = (-fixedPos.y+center.y)/aA;
		}else if (fixedPos.x <= 0 && -fixedPos.y <= corner[0].y && fixedPos.y <= corner[3].y && (nRadius[0] || nRadius[3])){
			alp = (fixedPos.x+center.x)/aA;
		}else if (fixedPos.x >= 0 && -fixedPos.y <= corner[1].y && fixedPos.y <= corner[2].y && (nRadius[1] || nRadius[2])){
			alp = (-fixedPos.x+center.x)/aA;
		}
		alp = clamp(alp,0,1);
		]]..(woF or [[
		float2 newborderThickness = borderThickness*dd*100;
		tex_bk = tex_bk+tex_bk*newborderThickness;
		dx = ddx(tex_bk);
		dy = ddy(tex_bk);
		dd = float2(length(float2(dx.x,dy.x)),length(float2(dx.y,dy.y)));
		a = dd.x/dd.y;
		center = 0.5*float2(1/(a<=1?a:1),a<=1?1:a);
		aA = borderSoft*100;
		if(a<=1){
			tex_bk.x /= a;
			aA *= dd.y;
			nRadius = float4(isRelative.x==1?radius.x/2:radius.x*dd.y,isRelative.y==1?radius.y/2:radius.y*dd.y,isRelative.z==1?radius.z/2:radius.z*dd.y,isRelative.w==1?radius.w/2:radius.w*dd.y);
		}
		else{
			tex_bk.y *= a;
			aA *= dd.x;
			nRadius = float4(isRelative.x==1?radius.x/2:radius.x*dd.x,isRelative.y==1?radius.y/2:radius.y*dd.x,isRelative.z==1?radius.z/2:radius.z*dd.x,isRelative.w==1?radius.w/2:radius.w*dd.x);
		}
		fixedPos = (tex_bk-center*(newborderThickness+1));
		float4 nRadiusHalf = nRadius*radiusMultipler;
		corner[0] = center-nRadiusHalf.x;
		corner[1] = center-nRadiusHalf.y;
		corner[2] = center-nRadiusHalf.z;
		corner[3] = center-nRadiusHalf.w;
		//LTCorner
		float nAlp = 0;
		if(-fixedPos.x >= corner[0].x && -fixedPos.y >= corner[0].y)
		{
			float dis = distance(-fixedPos,corner[0]);
			nAlp = (dis-nRadiusHalf.x+aA)/aA;
		}
		//RTCorner
		if(fixedPos.x >= corner[1].x && -fixedPos.y >= corner[1].y)
		{
			float dis = distance(float2(fixedPos.x,-fixedPos.y),corner[1]);
			nAlp = (dis-nRadiusHalf.y+aA)/aA;
		}
		//RBCorner
		if(fixedPos.x >= corner[2].x && fixedPos.y >= corner[2].y)
		{
			float dis = distance(float2(fixedPos.x,fixedPos.y),corner[2]);
			nAlp = (dis-nRadiusHalf.z+aA)/aA;
		}
		//LBCorner
		if(-fixedPos.x >= corner[3].x && fixedPos.y >= corner[3].y)
		{
			float dis = distance(float2(-fixedPos.x,fixedPos.y),corner[3]);
			nAlp = (dis-nRadiusHalf.w+aA)/aA;
		}
		if (fixedPos.y <= 0 && -fixedPos.x <= corner[0].x && fixedPos.x <= corner[1].x && (nRadiusHalf[0] || nRadiusHalf[1])){
			nAlp = 1-(fixedPos.y+center.y)/aA;
		}else if (fixedPos.y >= 0 && -fixedPos.x <= corner[3].x && fixedPos.x <= corner[2].x && (nRadiusHalf[2] || nRadiusHalf[3])){
			nAlp = 1-(-fixedPos.y+center.y)/aA;
		}else if (fixedPos.x <= 0 && -fixedPos.y <= corner[0].y && fixedPos.y <= corner[3].y && (nRadiusHalf[0] || nRadiusHalf[3])){
			nAlp = 1-(fixedPos.x+center.x)/aA;
		}else if (fixedPos.x >= 0 && -fixedPos.y <= corner[1].y && fixedPos.y <= corner[2].y && (nRadiusHalf[1] || nRadiusHalf[2])){
			nAlp = 1-(-fixedPos.x+center.x)/aA;
		}
		alp *= clamp(nAlp,0,1);
		]])..[[
		result.rgb = colorOverwritten?result.rgb:_color.rgb;
		result.a *= _color.a*alp;
		return result;
	}
	
	
	technique rndRectTech
	{
		pass P0
		{
			PixelShader = compile ps_2_a rndRect();
		}
	}
	]]
end

converColor = function(int,useMath,relative)
    local a,r,g,b
    if useMath then
        b = int%256
        local int = (int-b)/256
        g = int%256
        local int = (int-g)/256
        r = int%256
        local int = (int-r)/256
        a = int%256
    else
        a,r,g,b = getColorFromString(format("#%.8x",int))
    end
    if relative then
        a,r,g,b = a/255,r/255,g/255,b/255
    end
    return r,g,b,a
end

dxDrawRoundedRectangle = function(txtName,radius,color)
    local shader = dxCreateShader(requestRoundRectangleShader())
    local color = color or tocolor(255,255,255,255)
    dxSetShaderValue(shader,"color",{converColor(color,true,true)})
    if tonumber(radius) > 100 then
        radius = 1
    else
        radius = radius/100
    end
    dxSetShaderValue(shader,"radius",{radius,radius,radius,radius})
    if txtName then
        local texsta = dxCreateTexture(tostring(txtName))
        if texsta == false then
            assert(isElement(texsta), " (значение - " .. type(texsta) .. ") - Неудалось создать текстуру {проверь имя текстуры} ")
        else
            dxSetShaderValue(shader,"textureLoad",true)
            dxSetShaderValue(shader,"sourceTexture",texsta)
        end
    end

    return shader
end



createShaderCirleLua = function()
    return [[float borderSoft = 0.02;
float radius = 0.2;
float thickness = 0.02;
float2 progress = float2(0,001);
float4 indicatorColor = float4(0,1,1,1);
float PI2 = 6.283185;

float4 blend(float4 c1, float4 c2){
	float alp = c1.a+c2.a-c1.a*c2.a;
	float3 color = (c1.rgb*c1.a*(1.0-c2.a)+c2.rgb*c2.a)/alp;
	return float4(color,alp);
}

float4 myShader(float2 tex:TEXCOORD0,float4 color:COLOR0):COLOR0{
	float2 dxy = float2(length(ddx(tex)),length(ddy(tex)));
	float nBS = borderSoft*sqrt(dxy.x*dxy.y)*100;
	float4 bgColor = color;
	float4 inColor = 0;
	float2 texFixed = tex-0.5;
	float delta = clamp(1-(abs(length(texFixed)-radius)-thickness+nBS)/nBS,0,1);
	bgColor.a *= delta;
	float2 progFixed = progress*PI2;
	float angle = atan2(tex.y-0.5,0.5-tex.x)+0.5*PI2;
	bool tmp1 = angle>progFixed.x;
	bool tmp2 = angle<progFixed.y;
	float dis_ = distance(float2(cos(progFixed.x),-sin(progFixed.x))*radius,texFixed);
	float4 Color1,Color2;
	if(dis_<=thickness){
		float tmpDelta = clamp(1-(dis_-thickness+nBS)/nBS,0,1);
		Color1 = indicatorColor;
		inColor = indicatorColor;
		Color1.a *= tmpDelta;
	}
	dis_ = distance(float2(cos(progFixed.y),-sin(progFixed.y))*radius,texFixed);
	if(dis_<=thickness){
		float tmpDelta = clamp(1-(dis_-thickness+nBS)/nBS,0,1);
		Color2 = indicatorColor;
		inColor = indicatorColor;
		Color2.a *= tmpDelta;
	}
	inColor.a = max(Color1.a,Color2.a);
	if(progress.x>=progress.y){
		if(tmp1+tmp2){
			inColor = indicatorColor;
			inColor.a *= delta;
		}
	}else{
		if(tmp1*tmp2){
			inColor = indicatorColor;
			inColor.a *= delta;
		}
	}
	return blend(bgColor,inColor);
}

technique DrawCircle{
	pass P0	{
		PixelShader = compile ps_2_a myShader();
	}
}
]]
end
-----------------------------------------------------------------------------------
dxDrawCircleFx = function(Thickness,color)
    local cricleShader = dxCreateShader(createShaderCirleLua())
    local color = color or tocolor(200,25,75,255)
    local Thickness = Thickness or 30
    setCricleThickness(cricleShader,Thickness)
    dxSetShaderValue(cricleShader,"indicatorColor",{converColor(color,true,true)})
    dxSetShaderValue(cricleShader,"progress",0,.0001,false,false)
    dxSetShaderValue(cricleShader,"rotation",360)
    return cricleShader
end

setCircleProgress = function(Element,progress)
    local call = utf8.find(tostring(progress), "-")
    if call then
        dxSetShaderValue(Element,"progress",0,.0001)
        return true end
    if progress == 0 then
        dxSetShaderValue(Element,"progress",0,.0001)
        return true end
    if progress > 100 then
        dxSetShaderValue(Element,"progress",0,1)
        return true end
    dxSetShaderValue(Element,"progress",0,progress/100 or .0001)
end


setCricleThickness = function(Element,value)
    local call = utf8.find(tostring(value), "-")
    if call then
        dxSetShaderValue(Element,"thickness",.02)
        return true end
    if value == 0 then
        dxSetShaderValue(Element,"thickness",.01)
        return true end
    if value >= 100 then
        dxSetShaderValue(Element,"thickness",.1)
        return true end
    dxSetShaderValue(Element,"thickness",value/1000)
    return true
end

img = {
    -- 1) Имя текстуры  2) степень скругления 0-100  3) цвет R_G_B_A (красынй,зеленый,синий,прозрачность 0-255)
    none = dxDrawRoundedRectangle(nil,100,tocolor(0,0,0,150)),
    visible = dxDrawRoundedRectangle(nil,35,tocolor(0,0,0,150)),
    car = dxDrawRoundedRectangle(nil,50,tocolor(0,234,42,255)),
    main = dxDrawRoundedRectangle(nil,50,tocolor(0,255,255,255)),
    fone = dxDrawRoundedRectangle(nil,15,tocolor(0,0,0,150)),
    Progress = dxDrawRoundedRectangle("resources/image/accelerate.png",75,tocolor(255,0,255,255)),
    ProgressFone = dxDrawRoundedRectangle(nil,75,tocolor(0,0,0,150)),
    gear = dxDrawRoundedRectangle("resources/image/accelerate.png",75,tocolor(10,10,255,255)),
    enter = dxDrawRoundedRectangle(nil, 100, tocolor(255, 0, 0, 200)),
    point = dxDrawRoundedRectangle(nil, 100, tocolor(255, 165, 0, 255)),
}
