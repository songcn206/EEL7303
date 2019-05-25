var orPrmPinLib =
{
    pinMasters : [
    {
        "id" : "busEntryR",
        "type" : "LINE",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "st" :
        {
            "x" : 0,
            "y" : 0
        },
        "end" :
        {
            "x" : 10,
            "y" : 10
        }
    },
    {
        "id" : "busEntryL",
        "type" : "LINE",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "st" :
        {
            "x" : 10,
            "y" : 0
        },
        "end" :
        {
            "x" : 0,
            "y" : 10
        }
    },
    // pin shapes
    // POLYGONS
    // SHORT
    {
        "id" : "shortClockPoly",
        "type" : "POLYGON",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "pts" : [
        {
            "x" : 10,
            "y" : -3
        },
        {
            "x" : 14,
            "y" : 0
        },
        {
            "x" : 10,
            "y" : 3
        }]
    },
    {
        "id" : "shortInPoly",
        "type" : "POLYGON",
        "lyr" : 0,
        "vis" : true,
        "fS" : "redFS",
        "sS" : "redSS",
        "pntrId" : "",
        "pts" : [
        {
            "x" : 6,
            "y" : -3
        },
        {
            "x" : 10,
            "y" : 0
        },
        {
            "x" : 6,
            "y" : 3
        }]
    },
    {
        "id" : "longClockPoly",
        "type" : "POLYGON",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "pts" : [
        {
            "x" : 0,
            "y" : -3
        },
        {
            "x" : 4,
            "y" : 0
        },
        {
            "x" : 0,
            "y" : 3
        }]
    },
    {
        "id" : "longInPoly",
        "type" : "POLYGON",
        "lyr" : 0,
        "vis" : true,
        "fS" : "redFS",
        "sS" : "redSS",
        "pntrId" : "",
        "pts" : [
        {
            "x" : -4,
            "y" : -3
        },
        {
            "x" : 0,
            "y" : 0
        },
        {
            "x" : -4,
            "y" : 3
        }]
    },
    {
        "id" : "shortEllipse",
        "type" : "ELLIPSE",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "box" :
        {
            "uL" :
            {
                "x" : 6,
                "y" : -2
            },
            "lR" :
            {
                "x" : 10,
                "y" : 2
            }
        }
    },
    {
        "id" : "longEllipse",
        "type" : "ELLIPSE",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "box" :
        {
            "uL" :
            {
                "x" : -4,
                "y" : 2
            },
            "lR" :
            {
                "x" : 0,
                "y" : -2
            }
        }
    },
    {
        "id" : "shortLine",
        "type" : "LINE",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "st" :
        {
            "x" : -10,
            "y" : 0
        },
        "end" :
        {
            "x" : 0,
            "y" : 0
        }
    },
    {
        "id" : "longLine",
        "type" : "LINE",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "st" :
        {
            "x" : -30,
            "y" : 0
        },
        "end" :
        {
            "x" : 0,
            "y" : 0
        }
    },
    {
        "id" : "shortSmallLine",
        "type" : "LINE",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "st" :
        {
            "x" : -6,
            "y" : 0
        },
        "end" :
        {
            "x" : 0,
            "y" : 0
        }
    },
    {
        "id" : "longSmallLine",
        "type" : "LINE",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "st" :
        {
            "x" : -30,
            "y" : 0
        },
        "end" :
        {
            "x" : -4,
            "y" : 0
        }
    },
    {
        "id" : "pwrEllipse",
        "type" : "ELLIPSE",
        "lyr" : 0,
        "vis" : true,
        "fS" : "",
        "sS" : "redSS",
        "pntrId" : "",
        "box" :
        {
            "uL" :
            {
                "x" : -5,
                "y" : -3
            },
            "lR" :
            {
                "x" : 5,
                "y" : 3
            }
        }
    },
    {
        "id" : "pwrCross",
        "type" : "COMPOSITE",
        "lyr" : 4,
        "vis" : true,
        "shapes" : [
        {
            "id" : "vertLine",
            "type" : "LINE",
            "lyr" : 0,
            "vis" : true,
            "fS" : "",
            "sS" : "redSS",
            "pntrId" : "",
            "st" :
            {
                "x" : 0,
                "y" : -3
            },
            "end" :
            {
                "x" : 0,
                "y" : 3
            }
        },
        {
            "id" : "horizLine",
            "type" : "LINE",
            "lyr" : 0,
            "vis" : true,
            "fS" : "",
            "sS" : "redSS",
            "pntrId" : "",
            "st" :
            {
                "x" : -5,
                "y" : 0
            },
            "end" :
            {
                "x" : 5,
                "y" : 0
            }
        }]
    },
    // DRAWN INST POLY
    {
        "id" : "ioDrawnPinPoly",
        "type" : "POLYGON",
        "lyr" : 0,
        "vis" : true,
        "fS" : "darkGreenFS",
        "sS" : "dardGreenSS",
        "pntrId" : "",
        "pts" : [
        {
            "x" : 5,
            "y" : -5
        },
        {
            "x" : 10,
            "y" : 0
        },
        {
            "x" : 5,
            "y" : 5
        },
        {
            "x" : 0,
            "y" : 0
        }]
    },
    {
        "id" : "pasDrawnPinPoly",
        "type" : "POLYGON",
        "lyr" : 0,
        "vis" : true,
        "fS" : "darkGreenFS",
        "sS" : "dardGreenSS",
        "pntrId" : "",
        "pts" : [
        {
            "x" : 0,
            "y" : -5
        },
        {
            "x" : 10,
            "y" : -5
        },
        {
            "x" : 10,
            "y" : 5
        },
        {
            "x" : 0,
            "y" : 5
        }]
    },
    {
        "id" : "inDrawPinPoly",
        "type" : "POLYGON",
        "lyr" : 0,
        "vis" : true,
        "fS" : "darkGreenFS",
        "sS" : "darkGreenSS",
        "pntrId" : "",
        "pts" : [
        {
            "x" : 0,
            "y" : -5
        },
        {
            "x" : 5,
            "y" : -5
        },
        {
            "x" : 10,
            "y" : 0
        },
        {
            "x" : 5,
            "y" : 5
        },
        {
            "x" : 0,
            "y" : 5
        }]
    },
    {
        "id" : "outDrawnPinPoly",
        "type" : "POLYGON",
        "lyr" : 0,
        "vis" : true,
        "fS" : "darkGreenFS",
        "sS" : "darkGreenSS",
        "pntrId" : "",
        "pts" : [
        {
            "x" : 0,
            "y" : 0
        },
        {
            "x" : 5,
            "y" : -5
        },
        {
            "x" : 10,
            "y" : -5
        },
        {
            "x" : 10,
            "y" : 5
        },
        {
            "x" : 5,
            "y" : 5
        }]
    },
    // /// PINS
    // short pins
    {
        "id" : "shortVisIn",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortSmallLine",
            "mType" : "LINE"
        },
        {
            "id" : "inArrow",
            "type" : "REFERENCE",
            "mid" : "shortInPoly",
            "mType" : "POLYGON"
        }]
    },
    {
        "id" : "shortVisOut",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "shortClockVisIn",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortLine",
            "mType" : "LINE"
        },
        {
            "id" : "inArrow",
            "type" : "REFERENCE",
            "mid" : "shortClockPoly",
            "mType" : "POLYGON"
        }]
    },
    // LONG PINS
    // vis pas pins
    {
        "id" : "visPas",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortLine",
            "mType" : "LINE"
        }]
    },
    // vis io pins
    {
        "id" : "visIO",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortLine",
            "mType" : "LINE"
        }]
    },
    // vis in pins
    {
        "id" : "visIn",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortLine",
            "mType" : "LINE"
        },
        {
            "id" : "inArrow",
            "type" : "REFERENCE",
            "mid" : "longInPoly",
            "mType" : "POLYGON"
        }]
    },
    // vis out pins
    {
        "id" : "visOut",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortLine",
            "mType" : "LINE"
        }]
    },
    // long vis pas pins
    {
        "id" : "longVisPas",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longLine",
            "mType" : "LINE"
        }]
    },
    // long vis hiz
    {
        "id" : "longVisHiz",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longLine",
            "mType" : "LINE"
        }]
    },
    // long vis pins
    {
        "id" : "longClockVisIn",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longLine",
            "mType" : "LINE"
        },
        {
            "id" : "inArrow",
            "type" : "REFERENCE",
            "mid" : "longClockPoly",
            "mType" : "POLYGON"
        }]
    },
    {
        "id" : "longClockDotVisIn",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longEllipse",
            "mType" : "ELLIPSE"
        },
        {
            "id" : "ref2",
            "type" : "REFERENCE",
            "mid" : "longSmallLine",
            "mType" : "LINE"
        },
        {
            "id" : "clockSym",
            "type" : "REFERENCE",
            "mid" : "longClockPoly",
            "mType" : "POLYGON"
        }]
    },
    // long clock vis passive
    {
        "id" : "longClockVisPas",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longLine",
            "mType" : "LINE"
        },
        {
            "id" : "inArrow",
            "type" : "REFERENCE",
            "mid" : "longClockPoly",
            "mType" : "POLYGON"
        }]
    },
    {
        "id" : "longVisIn",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longSmallLine",
            "mType" : "LINE"
        },
        {
            "id" : "filledInArrow",
            "type" : "REFERENCE",
            "mid" : "longInPoly",
            "mType" : "POLYGON"
        }]
    },

    {
        "id" : "longVisOut",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "longVisIO",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "longVisGlobalPower",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "longLPRPVisPas",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "pasDrawnPinPoly",
            "mType" : "POLYGON"
        }]
    },
    {
        "id" : "longLPRPVisIO",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "ioDrawnPinPoly",
            "mType" : "POLYGON"
        }]
    },
    {
        "id" : "longLPRPVisIn",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "inDrawPinPoly",
            "mType" : "POLYGON"
        }]
    },
    {
        "id" : "longLPRPVisOut",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "outDrawnPinPoly",
            "mType" : "POLYGON"
        }]
    },
    {
        "id" : "zeroLPRPVisPas",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "pasDrawnPinPoly",
            "mType" : "POLYGON"
        }]
    },
    {
        "id" : "zeroLPRPVisIO",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "ioDrawnPinPoly",
            "mType" : "POLYGON"
        }]
    },
    {
        "id" : "zeroLPRPVisIn",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "inDrawPinPoly",
            "mType" : "POLYGON"
        }]
    },
    {
        "id" : "zeroLPRPVisOut",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "outDrawnPinPoly",
            "mType" : "POLYGON"
        }]
    },
    // SHORT PINS
    // short dot vis pins
    {
        "id" : "shortVisPas",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "shortDotVisIO",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortEllipse",
            "mType" : "ELLIPSE"
        },
        {
            "id" : "ref2",
            "type" : "REFERENCE",
            "mid" : "shortSmallLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "shortDotVisPas",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortEllipse",
            "mType" : "ELLIPSE"
        },
        {
            "id" : "ref2",
            "type" : "REFERENCE",
            "mid" : "shortSmallLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "shortDotVisOut",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortEllipse",
            "mType" : "ELLIPSE"
        },
        {
            "id" : "ref2",
            "type" : "REFERENCE",
            "mid" : "shortSmallLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "shortDotVisIn",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "shortEllipse",
            "mType" : "ELLIPSE"
        },
        {
            "id" : "ref2",
            "type" : "REFERENCE",
            "mid" : "shortSmallLine",
            "mType" : "LINE"
        }]
    },
    // long dot vis pins
    {
        "id" : "longDotVisIO",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longEllipse",
            "mType" : "ELLIPSE"
        },
        {
            "id" : "ref2",
            "type" : "REFERENCE",
            "mid" : "longSmallLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "longDotVisPas",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longEllipse",
            "mType" : "ELLIPSE"
        },
        {
            "id" : "ref2",
            "type" : "REFERENCE",
            "mid" : "longSmallLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "longDotVisOut",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longEllipse",
            "mType" : "ELLIPSE"
        },
        {
            "id" : "ref2",
            "type" : "REFERENCE",
            "mid" : "longSmallLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "longDotVisIn",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longEllipse",
            "mType" : "ELLIPSE"
        },
        {
            "id" : "ref2",
            "type" : "REFERENCE",
            "mid" : "longSmallLine",
            "mType" : "LINE"
        }]
    },
    {
        "id" : "longDotVisHiz",
        "type" : "COMPOSITE",
        "shapes" : [
        {
            "id" : "ref1",
            "type" : "REFERENCE",
            "mid" : "longEllipse",
            "mType" : "ELLIPSE"
        },
        {
            "id" : "ref2",
            "type" : "REFERENCE",
            "mid" : "longSmallLine",
            "mType" : "LINE"
        }]
    },
    // power pins
    {
        "id" : "zeroVisIn",
        "type" : "COMPOSITE",
        "vis" : true,
        "shapes" : [
        {
            "id" : "comp1",
            "type" : "REFERENCE",
            "mid" : "pwrEllipse",
            "mType" : "ELLIPSE",
            "origin" :
            {
                "x" : 0,
                "y" : 0
            }
        },
        {
            "id" : "comp2",
            "type" : "REFERENCE",
            "mid" : "pwrCross",
            "mType" : "COMPOSITE",
            "origin" :
            {
                "x" : 0,
                "y" : 0
            }
        }]
    },
    {
        "id" : "globalPower",
        "type" : "COMPOSITE",
        "vis" : true,
        "shapes" : [
        {
            "id" : "comp1",
            "type" : "REFERENCE",
            "mid" : "pwrEllipse",
            "mType" : "ELLIPSE",
            "origin" :
            {
                "x" : 0,
                "y" : 0
            }
        },
        {
            "id" : "comp2",
            "type" : "REFERENCE",
            "mid" : "pwrCross",
            "mType" : "COMPOSITE",
            "origin" :
            {
                "x" : 0,
                "y" : 0
            }
        }]
    }]
};
