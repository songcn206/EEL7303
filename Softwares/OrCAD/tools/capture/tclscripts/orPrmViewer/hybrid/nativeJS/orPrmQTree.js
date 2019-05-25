// Copyright 2012 Cadence Design Systems, Inc. All rights reserved worldwide.

function OrPrmPoint(x, y)
{
    this.x = x;
    this.y = y;
}

function OrPrmRect(uL, lR)
{
    this.uL = uL;
    this.lR = lR;
}

function orPrmRectGetCenter(rect)
{
    var centerX = (rect.uL.x + rect.lR.x) / 2;
    var centerY = (rect.uL.y + rect.lR.y) / 2;
    var center =
    {
        x : centerX,
        y : centerY
    };

    return center;
}

function orPrmRectGetBot(rect)
{
    return rect.lR.y;
}

function orPrmRectGetTop(rect)
{
    return rect.uL.y;
}

function orPrmRectGetRight(rect)
{
    return rect.lR.x;
}

function orPrmRectGetLeft(rect)
{
    return rect.uL.x;
}

function orPrmRectNormalize(rect)
{
    var temp = null;
    if(rect.uL.x > rect.lR.x)
    {
        temp = rect.uL.x;
        rect.uL.x = rect.lR.x;
        rect.lR.x = temp;
    }

    if(rect.uL.y > rect.lR.y)
    {
        temp = rect.uL.y;
        rect.uL.y = rect.lR.y;
        rect.lR.y = temp;
    }
}

function orPrmRectIntersects(lhs, rhs)
{
    return !(orPrmRectGetLeft(lhs) > orPrmRectGetRight(rhs)
            || orPrmRectGetRight(lhs) < orPrmRectGetLeft(rhs)
            || orPrmRectGetTop(lhs) > orPrmRectGetBot(rhs) || orPrmRectGetBot(lhs) < orPrmRectGetTop(rhs));
}

function orPrmRectGetQuadrant(rect, subjectBox)
{
    var left = orPrmRectGetLeft(subjectBox);
    var right = orPrmRectGetRight(subjectBox);
    var top = orPrmRectGetTop(subjectBox);
    var bot = orPrmRectGetBot(subjectBox);
    var center = orPrmRectGetCenter(rect);

    if(left >= center.x && bot <= center.y)
    {
        return Quadrant.NE;
    }

    if(left >= center.x && top >= center.y)
    {
        return Quadrant.SE;
    }

    if(right <= center.x && bot <= center.y)
    {
        return Quadrant.NW;
    }

    if(right <= center.x && top >= center.y)
    {
        return Quadrant.SW;
    }

    return Quadrant.UNK;
}

var Quadrant =
{
    UNK : -1,
    NE : 0,
    SE : 1,
    SW : 2,
    NW : 3,
};

function OrPrmQTree(left, top, right, bottom, parentTree)
{
    this.box =
    {
        uL :
        {
            x : left,
            y : top
        },
        lR :
        {
            x : right,
            y : bottom
        }
    };

    this.childTrees = [null, null, null, null]
    this.children = new Array();
    this.parentTree = parentTree;
    this.linearSearchCount = 0;
    this.qRect =
    {
        uL :
        {
            x : 0,
            y : 0
        },
        lR :
        {
            x : 0,
            y : 0
        }
    };

    if(null != parentTree)
    {
        this.depth = parentTree.depth + 1;
    }
    else
    {
        this.depth = 0;
    }
}

// defaults
OrPrmQTree.prototype.selectionToleranceX = 2;
OrPrmQTree.prototype.selectionToleranceY = 2;
OrPrmQTree.prototype.maxDepth = 10;

OrPrmQTree.prototype.setSelectionToleranceX = function(tolX)
{
    OrPrmQTree.prototype.selectionToleranceX = tolX;
};

OrPrmQTree.prototype.setSelectionToleranceY = function(tolY)
{
    OrPrmQTree.prototype.selectionToleranceY = tolY;
};

OrPrmQTree.prototype.setMaxDepth = function(depth)
{
    OrPrmQTree.prototype.maxDepth = depth;
};

OrPrmQTree.prototype.addShape = function(shape)
{
    var box = shape.box;
    var quadrant = orPrmRectGetQuadrant(this.box, box);
    if(Quadrant.UNK == quadrant || this.depth >= this.maxDepth)
    {
        this.children.push(shape);
        return;
    }

    if(this.childTrees[quadrant] == null)
    {
        var left = 0;
        var top = 0;
        var right = 0;
        var bot = 0;

        var center = orPrmRectGetCenter(this.box);
        switch(quadrant)
        {
        case Quadrant.NE:
            left = center.x;
            top = orPrmRectGetTop(this.box);
            right = orPrmRectGetRight(this.box);
            bot = center.y;
            break;
        case Quadrant.SE:
            left = center.x;
            top = center.y;
            right = orPrmRectGetRight(this.box);
            bot = orPrmRectGetBot(this.box);
            break;
        case Quadrant.SW:
            left = orPrmRectGetLeft(this.box);
            top = center.y;
            right = center.x;
            bot = orPrmRectGetBot(this.box);
            break;
        case Quadrant.NW:
            left = orPrmRectGetLeft(this.box);
            top = orPrmRectGetTop(this.box);
            right = center.x;
            bot = center.y;
            break;
        }
        this.childTrees[quadrant] = new OrPrmQTree(left, top, right, bot, this);
    }

    if(this.childTrees[quadrant] == null)
    {
        alert("Invalid application state - cannot create viewer");
    }
    else
    {
        this.childTrees[quadrant].addShape(shape);
    }
};

OrPrmQTree.prototype.removeShape = function(shape)
{
};

OrPrmQTree.prototype.getShapesAt = function(point)
{
    this.qRect.uL.x = point.x - this.selectionToleranceX;
    this.qRect.uL.y = point.y - this.selectionToleranceY;
    this.qRect.lR.x = point.x + this.selectionToleranceX;
    this.qRect.lR.y = point.y + this.selectionToleranceY;

    return this.getShapesIn(this.qRect);
};

OrPrmQTree.prototype.getShapes = function(rect, store)
{
    if(this.depth >= this.maxDepth)
    {
        if((null != this.children) && this.children.length > 0)
        {
            store.push(this.children);
        }
        return;
    }

    if((null != this.children) && this.children.length > 0)
    {
        store.push(this.children);
    }

    var quadrant = orPrmRectGetQuadrant(this.box, rect);
    if(Quadrant.UNK == quadrant || this.childTrees[quadrant] == null)
    {
        return;
    }
    this.childTrees[quadrant].getShapes(rect, store);
};

OrPrmQTree.prototype.getShapesIn = function(rect)
{
    var store = new Array();
    this.getShapes(rect, store);
    var matches = null;
    if(store.length > 0)
    {
        matches = new Array();
        this.linearSearchCount = 0;
        for(i in store)
        {
            var children = store[i];
            for(j in children)
            {
                ++this.linearSearchCount;
                var shape = children[j];
                if(orPrmRectIntersects(shape.box, rect))
                    matches.push(shape);
            }
        }
    }
    delete store;
    return matches;
};
