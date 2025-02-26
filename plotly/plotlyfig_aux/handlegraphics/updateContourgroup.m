function obj = updateContourgroup(obj,contourIndex)

% z: ...[DONE]
% x: ...[DONE]
% y: ...[DONE]
% name: ...[DONE]
% zauto: ...[DONE]
% zmin: ...[DONE]
% zmax: ...[DONE]
% autocontour: ...[DONE]
% ncontours: ...[N/A]
% contours: ...[DONE]
% colorscale: ...[DONE]
% reversescale: ...[DONE]
% showscale: ...[DONE]
% colorbar: ...[DONE]
% opacity: ---[TODO]
% xaxis: ...[DONE]
% yaxis: ...[DONE]
% showlegend: ...[DONE]
% stream: ...[HANDLED BY PLOTLYSTREAM]
% visible: ...[DONE]
% x0: ...[DONE]
% dx: ...[DONE]
% y0: ...[DONE]
% dy: ...[DONE]
% xtype: ...[DONE]
% ytype: ...[DONE]
% type: ...[DONE]

% LINE

% color: ...[DONE]
% width: ...[DONE]
% dash: ...[DONE]
% opacity: ---[TODO]
% shape: ...[NOT SUPPORTED IN MATLAB]
% smoothing: ...[DONE]
% outliercolor: ...[N/A]
% outlierwidth: ...[N/A]

%-FIGURE DATA STRUCTURE-%
figure_data = get(obj.State.Figure.Handle);

%-AXIS INDEX-%
axIndex = obj.getAxisIndex(obj.State.Plot(contourIndex).AssociatedAxis);

%-AXIS DATA STRUCTURE-%
axis_data = get(obj.State.Plot(contourIndex).AssociatedAxis);

%-PLOT DATA STRUCTURE- %
contour_data = get(obj.State.Plot(contourIndex).Handle);

%-CHECK FOR MULTIPLE AXES-%
[xsource, ysource] = findSourceAxis(obj,axIndex);

%-AXIS DATA-%
eval(['xaxis = obj.layout.xaxis' num2str(xsource) ';']);
eval(['yaxis = obj.layout.yaxis' num2str(ysource) ';']);

%-------------------------------------------------------------------------%

%-contour xaxis-%
obj.data{contourIndex}.xaxis = ['x' num2str(xsource)];

%-------------------------------------------------------------------------%

%-contour yaxis-%
obj.data{contourIndex}.yaxis = ['y' num2str(ysource)];

%-------------------------------------------------------------------------%

%-contour name-%
obj.data{contourIndex}.name = contour_data.DisplayName;

%-------------------------------------------------------------------------%

%-setting the plot-%
xdata = contour_data.XData;
ydata = contour_data.YData;
zdata = contour_data.ZData;

if isvector(zdata)
    
    %-contour type-%
    obj.data{contourIndex}.type = 'contour';
    
    %-contour x data-%
    if ~isvector(x)
        obj.data{contourIndex}.xdata = xdata(1,:);
    else
        obj.data{contourIndex}.xdata = xdata;
    end

    %-contour y data-%
    if ~isvector(y)
        obj.data{contourIndex}.ydata = ydata';
    else
        obj.data{contourIndex}.ydata = ydata';
    end
    
    %-contour z data-%
    obj.data{contourIndex}.z = zdata;
    
else
    
    %-contour type-%
    obj.data{contourIndex}.type = 'surface';
    
    %-contour x and y data
    if isvector(xdata)
        [xdata, ydata] = meshgrid(xdata, ydata);
    end
    obj.data{contourIndex}.x = xdata;
    obj.data{contourIndex}.y = ydata;
    
    %-contour z data-%
    obj.data{contourIndex}.z = zdata;
    
    %-setting for contour lines z-direction-%
    if length(contour_data.LevelList) > 1
        zstart = contour_data.LevelList(1);
        zend = contour_data.LevelList(end);
        zsize = mean(diff(contour_data.LevelList));
    else
        zstart = contour_data.LevelList(1) - 1e-3;
        zend = contour_data.LevelList(end) + 1e-3;
        zsize = 2e-3;
    end
    l = 30;
    obj.data{contourIndex}.contours.z.start = zstart;
    obj.data{contourIndex}.contours.z.end = zend;
    obj.data{contourIndex}.contours.z.size = zsize;
    obj.data{contourIndex}.contours.z.show = true;
    obj.data{contourIndex}.contours.z.usecolormap = true;
    obj.data{contourIndex}.contours.z.width = contour_data.LineWidth;
    obj.data{contourIndex}.hidesurface = true;
    
end

%-------------------------------------------------------------------------%

if isvector(zdata)
    
    %-contour x type-%

    obj.data{contourIndex}.xtype = 'array';

    %-------------------------------------------------------------------------%

    %-contour y type-%

    obj.data{contourIndex}.ytype = 'array';
    
end

%-------------------------------------------------------------------------%

%-contour visible-%

obj.data{contourIndex}.visible = strcmp(contour_data.Visible,'on');

%-------------------------------------------------------------------------%

%-contour showscale-%
obj.data{contourIndex}.showscale = false;

%-------------------------------------------------------------------------%

if isvector(zdata)
    %-zauto-%
    obj.data{contourIndex}.zauto = false;

    %-------------------------------------------------------------------------%

    %-zmin-%
    obj.data{contourIndex}.zmin = axis_data.CLim(1);

    %-------------------------------------------------------------------------%

    %-zmax-%
    obj.data{contourIndex}.zmax = axis_data.CLim(2);
end

%-------------------------------------------------------------------------%

%-colorscale (ASSUMES PATCH CDATAMAP IS 'SCALED')-%
colormap = figure_data.Colormap;

for c = 1:size((colormap),1)
    col =  255*(colormap(c,:));
    obj.data{contourIndex}.colorscale{c} = {(c-1)/(size(colormap,1)-1), ['rgb(' num2str(col(1)) ',' num2str(col(2)) ',' num2str(col(3)) ')']};
end

%-------------------------------------------------------------------------%

%-contour reverse scale-%
obj.data{contourIndex}.reversescale = false;

%-------------------------------------------------------------------------%

if isvector(zdata)
    
    %-autocontour-%
    obj.data{contourIndex}.autocontour = false;
    
end

%-------------------------------------------------------------------------%

if isvector(zdata)
    
    %-contour contours-%

    %-coloring-%
    switch contour_data.Fill
        case 'off'
            obj.data{contourIndex}.contours.coloring = 'lines';
        case 'on'
            obj.data{contourIndex}.contours.coloring = 'fill';
    end

    %-start-%
    obj.data{contourIndex}.contours.start = contour_data.TextList(1);

    %-end-%
    obj.data{contourIndex}.contours.end = contour_data.TextList(end);

    %-step-%
    obj.data{contourIndex}.contours.size = diff(contour_data.TextList(1:2));
    
end

%-------------------------------------------------------------------------%

if isvector(zdata)
    if(~strcmp(contour_data.LineStyle,'none'))

        %-contour line colour-%
        if isnumeric(contour_data.LineColor)
            col = 255*contour_data.LineColor;
            obj.data{contourIndex}.line.color = ['rgb(' num2str(col(1)) ',' num2str(col(2)) ',' num2str(col(3)) ')'];
        else
            obj.data{contourIndex}.line.color = 'rgba(0,0,0,0)';
        end

        %-contour line width-%
        obj.data{contourIndex}.line.width = contour_data.LineWidth;

        %-contour line dash-%
        switch contour_data.LineStyle
            case '-'
                LineStyle = 'solid';
            case '--'
                LineStyle = 'dash';
            case ':'
                LineStyle = 'dot';
            case '-.'
                LineStyle = 'dashdot';
        end

        obj.data{contourIndex}.line.dash = LineStyle;

        %-contour smoothing-%
        obj.data{contourIndex}.line.smoothing = 0;

    else

        %-contours showlines-%
        obj.data{contourIndex}.contours.showlines = false;

    end
end

%-------------------------------------------------------------------------%

%-contour showlegend-%

leg = get(contour_data.Annotation);
legInfo = get(leg.LegendInformation);

switch legInfo.IconDisplayStyle
    case 'on'
        showleg = true;
    case 'off'
        showleg = false;
end

obj.data{contourIndex}.showlegend = showleg;

%-------------------------------------------------------------------------%

end
