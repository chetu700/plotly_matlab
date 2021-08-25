%----UPDATE AXIS DATA/layout----%

function obj = updateAxis(obj,axIndex)

% title: ...[DONE]
% titlefont:...[DONE]
% range:...[DONE]
% domain:...[DONE]
% type:...[DONE]
% rangemode:...[NOT SUPPORTED IN MATLAB]
% autorange:...[DONE]
% showgrid:...[DONE]
% zeroline:...[DONE]
% showline:...[DONE
% autotick:...[DONE]
% nticks:...[DONE]
% ticks:...[DONE]
% showticklabels:...[DONE]
% tick0:...[DONE]
% dtick:...[DONE]
% ticklen:...[DONE]
% tickwidth:...[DONE]
% tickcolor:...[DONE]
% tickangle:...[NOT SUPPORTED IN MATLAB]
% tickfont:...[DONE]
% tickfont.family...[DONE]
% tickfont.size...[DONE]
% tickfont.color...[DONE]
% tickfont.outlinecolor...[NOT SUPPORTED IN MATLAB]
% exponentformat:...[DONE]
% showexponent:...[NOT SUPPORTED IN MATLAB]
% mirror:...[DONE]
% gridcolor:...[DONE]
% gridwidth:...[DONE]
% zerolinecolor:...[NOT SUPPORTED IN MATLAB]
% zerolinewidth:...[NOT SUPPORTED IN MATLAB]
% linecolor:...[DONE]
% linewidth:...[DONE]
% anchor:...[DONE]
% overlaying:...[DONE]
% side:...[DONE]
% position:...[NOT SUPPORTED IN MATLAB]

%-STANDARDIZE UNITS-%
axisunits = get(obj.State.Axis(axIndex).Handle,'Units');
fontunits = get(obj.State.Axis(axIndex).Handle,'FontUnits');
set(obj.State.Axis(axIndex).Handle,'Units','normalized');
set(obj.State.Axis(axIndex).Handle,'FontUnits','points');

%-AXIS DATA STRUCTURE-%
axis_data = get(obj.State.Axis(axIndex).Handle);

%-------------------------------------------------------------------------%

%-xaxis-%
xaxis = extractAxisData(obj,axis_data,'X');

%-------------------------------------------------------------------------%

%-yaxis-%
yaxis = extractAxisData(obj,axis_data,'Y');

%-------------------------------------------------------------------------%

%-xaxis domain-%
xaxis.domain = min([axis_data.Position(1) axis_data.Position(1)+axis_data.Position(3)],1);

%-------------------------------------------------------------------------%

%-yaxis domain-%
yaxis.domain = min([axis_data.Position(2) axis_data.Position(2)+axis_data.Position(4)],1);

%-------------------------------------------------------------------------%

[xsource, ysource, xoverlay, yoverlay] = findSourceAxis(obj,axIndex);

%-------------------------------------------------------------------------%

%-xaxis anchor-%
xaxis.anchor = ['y' num2str(ysource)];

%-------------------------------------------------------------------------%

%-yaxis anchor-%
yaxis.anchor = ['x' num2str(xsource)];

%-------------------------------------------------------------------------%

%-xaxis overlaying-%
if xoverlay
    xaxis.overlaying = ['x' num2str(xoverlay)];
end

%-------------------------------------------------------------------------%

%-yaxis overlaying-%
if yoverlay
    yaxis.overlaying = ['y' num2str(yoverlay)];
end

%-------------------------------------------------------------------------%

% update the layout field (do not overwrite source)
if xsource == axIndex
    obj.layout = setfield(obj.layout,['xaxis' num2str(xsource)],xaxis);
else
    
end

%-------------------------------------------------------------------------%

% update the layout field (do not overwrite source)
if ysource == axIndex
    obj.layout = setfield(obj.layout,['yaxis' num2str(ysource)],yaxis);
else
    
end

%-------------------------------------------------------------------------%

%-REVERT UNITS-%
set(obj.State.Axis(axIndex).Handle,'Units',axisunits);
set(obj.State.Axis(axIndex).Handle,'FontUnits',fontunits);

end
