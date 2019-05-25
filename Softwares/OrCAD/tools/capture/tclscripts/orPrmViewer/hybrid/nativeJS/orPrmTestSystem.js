function isTestMode()
{
    return orPrmTestMode;
}

function setTestMode(pTestMode)
{
    orPrmTestMode = pTestMode;
}

function debugPaint()
{
    return false.toString();
}

function xform(x, y, l, t, r, b, rotation, mX, mY, offX, offY)
{
    var rX = x;
    var rY = y;
    var width = r - l;
    var height = b - t;

    if(mX)
    {
        rX = -rX + width;
    }

    if(mY)
    {
        rY = -rY + height;
    }

    var temp = 0;

    switch(rotation)
    {
    case 1:
        temp = rY;
        rY = -rX + width;
        rX = temp;
        break;
    case 2:
        rX = -rX + width;
        rY = -rY + height;
        break;
    case 3:
        temp = rY;
        rY = rX;
        rX = -temp + height;
        break;
    }

    rX = rX + offX;
    rY = rY + offY;
    
    return { x: rX, y: rY };
}

