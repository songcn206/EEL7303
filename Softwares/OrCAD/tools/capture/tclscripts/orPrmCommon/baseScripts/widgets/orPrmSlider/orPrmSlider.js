var oOrPrmSliders = [];

function orPrmGetSlider(id)
{
    return oOrPrmSliders[id];
}

function orPrmSetSlider(id, slider)
{
    oOrPrmSliders[id] = slider;
}

function orPrmSlider(id, widgetDiv, sliderDiv, valueDiv)
{
    this.id = id;
    this.widgetDiv = widgetDiv;
    this.sliderDiv = sliderDiv;
    this.valueDiv = valueDiv;
}

function orPrmSliderInstall(id, widgetDiv, sliderDiv, valueDiv, defValue, minValue, maxValue, stepValue, slideCallback, slideStartCallback, slideStopCallback, position)
{
    if(null == orPrmGetSlider())
    {
        orPrmSetSlider(id, new orPrmSlider(id, widgetDiv, sliderDiv, valueDiv));
    }

    $(sliderDiv).slider(
    {
        value : defValue,
        min : minValue,
        max : maxValue,
        step : stepValue,
        animate: true,
        slide : function(event, ui)
        {
            $(valueDiv).val(ui.value);
            slideCallback.apply(null, [ui.value]);
        },
        start : function(event, ui)
        {
            $(valueDiv).val(ui.value);
            slideStartCallback.apply(null, [ui.value]);
        },
        stop : function(event, ui)
        {
            $(valueDiv).val(ui.value);
            slideStopCallback.apply(null, [ui.value]);
        }
    });

    $(valueDiv).val($(sliderDiv).slider('value'));

    $(widgetDiv).dialog(
    {
        height : 80,
        position : position,
        resizable : false,
        hide :
        {
            effect : 'drop',
            direction : 'up'
        }
    });
}

function orPrmSliderSetStep(id, step)
{
    var oSlider = orPrmGetSlider(id);
    if(!oSlider)
    {
        return;
    }

    $(oSlider.sliderDiv).slider('option', 'step', step);
}

function orPrmSliderSetOrientation(id, orientation)
{
    var oSlider = orPrmGetSlider(id);
    if(!oSlider)
    {
        return;
    }

    $(oSlider.sliderDiv).slider('option', 'orientation', orientation);
}

function orPrmSliderSetMaxValue(id, level)
{
    var oSlider = orPrmGetSlider(id);
    if(!oSlider)
    {
        return;
    }

    $(oSlider.sliderDiv).slider('option', 'max', level);
}

function orPrmSliderSetMinValue(id, level)
{
    var oSlider = orPrmGetSlider(id);
    if(!oSlider)
    {
        return;
    }

    $(oSlider.sliderDiv).slider('option', 'min', level);
}

function orPrmSliderSetValue(id, level)
{
    var oSlider = orPrmGetSlider(id);
    if(!oSlider)
    {
        return;
    }

    $(oSlider.sliderDiv).slider('value', level);
    $(oSlider.valueDiv).val($(oSlider.sliderDiv).slider('value'));
}

