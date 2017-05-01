classdef WaterDataGUI < WaterData
    % Micah Cox
    % E177 Spring 2017 Final Project
   
    properties
        Figure
    end
    
    methods
        function obj = WaterDataGUI()
            obj = obj@WaterData();
        end
        
        function StartGUI(obj)
            % Initialize GUI
            if isempty(obj.Figure)
                obj.Figure = figure('Name','Berkley Water Data GUI');
            end
            set(obj.Figure,'Units','normalized',...
                'Position',[0.2,0.25,0.6,0.5]);
            
            % Plot Panel (Top Left)
            plotPanel = uipanel('Parent',obj.Figure,...
                'Units','normalized',...
                'Position',[0,0.5,0.5,0.5],...
                'Title','Plot Data',...
                'TitlePosition','centertop');
            attributeTitle = uicontrol(plotPanel,...
                'Style','text',...
                'String','Select Desired Attribute:',...
                'Units','normalized',...
                'Position',[0.25,0.65,0.5,0.2]);
            attributeMenu = uicontrol(plotPanel,'Style','popupmenu',...
                'String',obj.Attributes,...
                'BackgroundColor','white',...
                'Units','normalized',...
                'Position',[0.2,0.55,0.6,0.2]);
            plotButton = uicontrol(plotPanel,'Style','pushbutton',...
                'String','Plot Data',...
                'Units','normalized',...
                'Position',[0.3,0.2,0.4,0.2],...
                'Callback',{@plotCallback});
            
            % Figure Panel (Bottom Left)
            imgPanel = uipanel('Parent',obj.Figure,...
                'Units','normalized',...
                'Position',[0,0,0.5,0.5],...
                'Title','Data Graphics',...
                'TitlePosition','centertop');
            leadButton = uicontrol(imgPanel,'Style','pushbutton',...
                'String','Display National Data',...
                'Units','normalized',...
                'Position',[0.3,0.7,0.4,0.2],...
                'Callback',{@leadCallback});
            bayButton = uicontrol(imgPanel,'Style','pushbutton',...
                'String','Display Bay Area Sources',...
                'Units','normalized',...
                'Position',[0.3,0.4,0.4,0.2],...
                'Callback',{@bayCallback});
            linkButton = uicontrol(imgPanel,...
                'String','Visit EBMUD Website',...
                'Units','normalized',...
                'Position',[0.3,0.1,0.4,0.2],...
                'callback',{@linkCallback});
            
            % Search Panel (RIGHT)
            searchPanel = uipanel('Parent',obj.Figure,...
                'Units','normalized',...
                'Position',[0.5,0,0.5,1],...
                'Title','Search Controls',...
                'TitlePosition','centertop');
            attributeTitleR = uicontrol(searchPanel,...
                'Style','text',...
                'String','Select Desired Attribute:',...
                'Units','normalized',...
                'Position',[0.25,0.73,0.5,0.2]);
            attributeMenuR = uicontrol(searchPanel,'Style','popupmenu',...
                'String',obj.Attributes,...
                'BackgroundColor','white',...
                'Units','normalized',...
                'Position',[0.2,0.68,0.6,0.2]);
            minButton = uicontrol(searchPanel,'Style','pushbutton',...
                'String','Find Minumim Value',...
                'Units','normalized',...
                'Position',[0.3,0.61,0.4,0.1],...
                'Callback',{@minCallback});
            maxButton = uicontrol(searchPanel,'Style','pushbutton',...
                'String','Find Maximum Value',...
                'Units','normalized',...
                'Position',[0.3,0.46,0.4,0.1],...
                'Callback',{@maxCallback});
            searchNote = uicontrol(searchPanel,...
                'Style','text',...
                'String',{'Note: Search includes all available data sets provided',...
                'by the East Bay Municipal Utility District (2009-2016)'},...
                'Units','normalized',...
                'Position',[0.15,0.08,0.7,0.1]);
            displayBox = uipanel('Parent',searchPanel,...
                'Units','normalized',...
                'Position',[0.2,0.2,0.6,0.2],...
                'Title','Search Results',...
                'TitlePosition','centertop',...
                'Background','w');
            searchResults = uicontrol(displayBox,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1,0.1,0.8,0.8],...
                'Background','w');

            
            
            % Callback Functions:
        
            function plotCallback(h,d)
                list = get(attributeMenu,'String');
                specAttribute = list{get(attributeMenu,'Value')};
                obj.plotData(specAttribute);
            end
            
            function leadCallback(h,d)
                figure('Name','  National Lead Data',...
                    'Units','normalized',...
                    'OuterPosition', [0.2 0.15 0.6 0.7]);
                ax1 = axes('Position',[0 0 1 1],'Visible','off');
                ax2 = axes('Position',[0.05 .2 0.9 .75]);
                imshow('Lead_TapWater.jpg')
                axes(ax1)
                text(0.1,0.1,['17.6 million people served by community water ',...
                    'systems with reported violations of the lead and copper rule (2015) - Source: CNN']);
            end
            
            function bayCallback(h,d)
                figure('Name','  Bay Area Sources',...
                    'Units','normalized',...
                    'OuterPosition', [0.2 0.15 0.6 0.7]);
                ax1 = axes('Position',[0 0 1 1],'Visible','off');
                ax2 = axes('Position',[0.05 .2 0.9 .75]);
                imshow('Bay_Area.jpg')
                axes(ax1)
                text(0.2,0.1,'Source: East Bay Municipal Utility District (EBMUD)');
            end
            
            function linkCallback(h,d)
                web('http://www.ebmud.com/water-and-drought/about-your-water/water-quality/');
            end
            
            function minCallback(h,d)
                list = get(attributeMenuR,'String');
                specAttribute = list{get(attributeMenuR,'Value')};
                [minV,year,units] = findMin(obj,specAttribute);
                minString = {['Min Value:   ', num2str(minV),' ', units];
                    ' ';
                    ['Year Occured:   ', num2str(year)]};
                set(searchResults, 'String', minString);
            end
            
            function maxCallback(h,d)
                list = get(attributeMenuR,'String');
                specAttribute = list{get(attributeMenuR,'Value')};
                [maxV,year,units] = findMax(obj,specAttribute);
                maxString = {['Max Value:   ', num2str(maxV),' ', units];
                    ' ';
                    ['Year Occured:   ', num2str(year)]};
                set(searchResults, 'String', maxString);
                
            end
        end
    end
end
            
            
            
            
            
            
            