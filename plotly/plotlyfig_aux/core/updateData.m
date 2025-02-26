%----UPDATE PLOT DATA/STYLE----%

function obj = updateData(obj, dataIndex)

try
    
    %-update plot based on TreatAs PlotOpts-%
    
    if ~strcmpi(obj.PlotOptions.TreatAs, '_')
        if strcmpi(obj.PlotOptions.TreatAs, 'pie3')
            updatePie3(obj, dataIndex);
        elseif strcmpi(obj.PlotOptions.TreatAs, 'pcolor')
            updatePColor(obj, dataIndex);
        elseif strcmpi(obj.PlotOptions.TreatAs, 'polarplot')
            updatePolarplot(obj, dataIndex);
        end
        
    %-update plot based on plot call class-%
    
    else
        
        switch lower(obj.State.Plot(dataIndex).Class)

            %--CORE PLOT OBJECTS--%
            case 'heatmap'
                updateHeatmap(obj, dataIndex);
            case 'image'
                if ~obj.PlotOptions.Image3D
                    updateImage(obj, dataIndex);
                else
                    updateImage3D(obj, dataIndex);
                end
            case 'line'
                updateLineseries(obj, dataIndex);
            case 'categoricalhistogram'
                updateCategoricalHistogram(obj, dataIndex); 
            case 'histogram'
                if strcmpi(obj.State.Axis(dataIndex).Handle.Type, 'polaraxes')
                    updateHistogramPolar(obj, dataIndex); 
                else
                    updateHistogram(obj, dataIndex);
                end
            case 'histogram2'
                updateHistogram2(obj, dataIndex);
            case 'patch'
                % check for histogram
                if isHistogram(obj,dataIndex)
                    updateHistogram(obj,dataIndex);
                else
                    updatePatch(obj, dataIndex);
                end
            case 'rectangle'
                updateRectangle(obj,dataIndex);
            case 'surface'
                updateSurfaceplot(obj,dataIndex);
            case 'functionsurface'
                updateFunctionSurface(obj,dataIndex);
            case 'implicitfunctionsurface'
                updateImplicitFunctionSurface(obj,dataIndex);

                %-GROUP PLOT OBJECTS-%
            case 'area'
                updateArea(obj, dataIndex); 
            case 'areaseries'
                updateAreaseries(obj, dataIndex);
            case 'bar'
                updateBar(obj, dataIndex); 
            case 'barseries'
                updateBarseries(obj, dataIndex);
            case 'baseline'
                updateBaseline(obj, dataIndex);
            case {'contourgroup','contour'}
                if ~obj.PlotOptions.ContourProjection
                    updateContourgroup(obj,dataIndex);
                else
                    updateContourProjection(obj,dataIndex);
                end
            case 'functioncontour'
                updateFunctionContour(obj,dataIndex);
            case 'errorbar'
                updateErrorbar(obj,dataIndex); 
            case 'errorbarseries'
                updateErrorbarseries(obj,dataIndex);
            case 'lineseries'
                updateLineseries(obj, dataIndex);
            case 'quiver'
                updateQuiver(obj, dataIndex); 
            case 'quivergroup'
                updateQuivergroup(obj, dataIndex);
            case 'scatter'
                if strcmpi(obj.State.Axis(dataIndex).Handle.Type, 'polaraxes')
                    updateScatterPolar(obj, dataIndex); 
                else
                    updateScatter(obj, dataIndex); 
                end
            case 'scattergroup'
                updateScattergroup(obj, dataIndex);
            case 'stair'
                updateStair(obj, dataIndex); 
            case 'stairseries'
                updateStairseries(obj, dataIndex);
            case 'stem'
                updateStem(obj, dataIndex); 
            case 'stemseries'
                updateStemseries(obj, dataIndex);
            case 'surfaceplot'
                updateSurfaceplot(obj,dataIndex);
            case 'implicitfunctionline'
                updateLineseries(obj, dataIndex);

                %--Plotly supported MATLAB group plot objects--%
            case {'hggroup','group'}
                % check for boxplot
                if isBoxplot(obj, dataIndex)
                    updateBoxplot(obj, dataIndex);
                end
        end
    end
    
catch exception
    if obj.UserData.Verbose
        fprintf([exception.message '\nWe had trouble parsing the ' obj.State.Plot(dataIndex).Class ' object.\n',...
                 'This trace might not render properly.\n\n']);
    end
end

%------------------------AXIS/DATA CLEAN UP-------------------------------%

try
    %-AXIS INDEX-%
    axIndex = obj.getAxisIndex(obj.State.Plot(dataIndex).AssociatedAxis);

    %-CHECK FOR MULTIPLE AXES-%
    [xsource, ysource] = findSourceAxis(obj,axIndex);

    %-AXIS DATA-%
    eval(['xaxis = obj.layout.xaxis' num2str(xsource) ';']);
    eval(['yaxis = obj.layout.yaxis' num2str(ysource) ';']);

    %---------------------------------------------------------------------%

    % check for xaxis dates
    if strcmpi(xaxis.type, 'date')
        obj.data{dataIndex}.x =  convertDate(obj.data{dataIndex}.x);
    end

    % check for xaxis categories
    if strcmpi(xaxis.type, 'category') && ...
            ~strcmp(obj.data{dataIndex}.type,'box')
        obj.data{dataIndex}.x =  get(obj.State.Plot(dataIndex).AssociatedAxis,'XTickLabel');
    end

    % check for yaxis dates
    if strcmpi(yaxis.type, 'date')
        obj.data{dataIndex}.y =  convertDate(obj.data{dataIndex}.y);
    end

    % check for yaxis categories
    if strcmpi(yaxis.type, 'category') && ...
            ~strcmp(obj.data{dataIndex}.type,'box')
        obj.data{dataIndex}.y =  get(obj.State.Plot(dataIndex).AssociatedAxis,'YTickLabel');
    end
catch
    % TODO to the future
    % disp('catch at line 157 in updateData.m file')
end

%-------------------------------------------------------------------------%

end
