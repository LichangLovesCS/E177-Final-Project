classdef MapDataGUI < MapData
    %MAPGUI is the class that provides user a GUI to iteract with Map 
    % @Author: Lichang Xu
    
    properties
        Figure;
    end
    
    methods
        % Class Constructor
        function obj = MapDataGUI()
            obj = obj@MapData();
        end
        
        % Start the map GUI
        function StartGUI(obj)
            % Open a dialog box
            myicon = imread('tapwater.jpg');
            msg_win = msgbox('Drink Tap Water and Stay Healthy!',...
                'Welcome!','custom',myicon);
            set(msg_win,'Pointer','hand');
            uiwait(msg_win);
            % Initialize the GUI
            if isempty(obj.Figure)
                obj.Figure = figure('Name','UC Berkeley Water Fountain GUI');
                set(obj.Figure,'Pointer','hand');
            end
            set(obj.Figure,'Units','normalized','Position',[0.2,0.25,0.6,0.5]);
            % User Input Panel (Top Left)
            userPanel = uipanel('Parent',obj.Figure,...
                'Units','normalized',...
                'Position',[0,0.5,0.5,0.5],...
                'Title','User Input',...
                'Fontsize',12,...
                'TitlePosition','centertop');
            fontText = uicontrol(userPanel,...
                'Style','text',...
                'String','Font Size',...
                'Units','normalized',...
                'Fontsize',12,...
                'Position',[-0.01,0.65,0.2,0.2]);
            fontBar = uicontrol(userPanel,...
                'Style','slider',...
                'Units','normalized',...
                'Max',16,'Min',8,...
                'SliderStep',[1/8 1/8],...
                'Value',12,...
                'Callback',@FontCallback,...
                'Position',[-0.05,0.38,0.15,0.4]);
            userLocation = uicontrol(userPanel,...
                'Style','text',...
                'String','Enter Your Current Location (e.g., 32,-122):',...
                'Units','normalized',...
                'Fontsize',12,...
                'Position',[0.25,0.65,0.5,0.2]);
            userBox = uicontrol(userPanel,'Style','edit',...
                'BackgroundColor','white',...
                'ForegroundColor','blue',...
                'Units','normalized',...
                'FontName','Arial',...
                'FontSize',16,...
                'Position',[0.2,0.55,0.6,0.2]);
            helpButton = uicontrol(userPanel,'Style','pushbutton',...
                'String','Help',...
                'Units','normalized',...
                'Position',[0.3,0.2,0.4,0.2],...
                'Fontsize',12,...
                'Callback',@helpCallback);
            % Hall Operating Hour Panel (bottom left)
            HallPanel = uipanel('Parent',obj.Figure,...
                'Units','normalized',...
                'Position',[0,0,0.5,0.5],...
                'Title','Hall Operating Hours',...
                'Fontsize',12,...
                'TitlePosition','centertop');
            ClockDisp = uicontrol(HallPanel,'Style','togglebutton',...
                'String','Time','Units','normalized','Fontsize',12,...
                'Callback',@clockCallback,...
                'Position', [0.8,0.9,0.1,0.12]);
            HallSelectionButton = uicontrol(HallPanel,'Style','popupmenu',...
                'String',obj.Hall,...
                'Units','normalized',...
                'Fontsize',12,...
                'Position',[0.3,0.62,0.4,0.2]);
            HourText = uicontrol(HallPanel,'Style','text',...
                'String','Operating Hours',...
                'Units','normalized',...
                'Fontsize',12,...
                'Position',[0.3,0.4,0.4,0.2]);
            HourDisp = uicontrol(HallPanel,'Style','pushbutton',...
                'String','Show',...
                'Units','normalized',...
                'Position',[0.3,0.3,0.4,0.2],...
                'Fontsize',12,...
                'Callback',@hourCallback);
            % Water Fountain Location Panel (top right)
            MapPanel = uipanel('Parent',obj.Figure,...
                'Units','normalized',...
                'Position',[0.5,0.5,0.5,0.5],...
                'Title','Water Fountain Map',...
                'Fontsize',12,...
                'TitlePosition','centertop');
            % Display different map types
            satButton = uicontrol(MapPanel,'Style','radiobutton',...
                'String','Satellite',...
                'Units','normalized',...
                'Fontsize',12,...
                'Position',[0.05,0.65,0.2,0.2]);
            roadButton = uicontrol(MapPanel,'Style','radiobutton',...
                'String','Roadmap',...
                'Units','normalized',...
                'Fontsize',12,...
                'Position',[0.05,0.50,0.2,0.2]);
            terButton = uicontrol(MapPanel,'Style','radiobutton',...
                'String','Terrain',...
                'Units','normalized',...
                'Fontsize',12,...
                'Position',[0.05,0.35,0.2,0.2]);
            hybButton = uicontrol(MapPanel,'Style','radiobutton',...
                'String','Hybrid',...
                'Units','normalized',...
                'Fontsize',12,...
                'Position',[0.05,0.20,0.2,0.2]);
            AllFountainButton = uicontrol(MapPanel,...
                'Style','pushbutton',...
                'String','UC Berkeley Water Fountain Map',...
                'Units','normalized',...
                'Callback',@WaterFountainCallback,...
                'Fontsize',12,...
                'Position',[0.28,0.73,0.5,0.2]);
            UserFountainButton = uicontrol(MapPanel,'Style','pushbutton',...
                'String','User Location Map',...
                'Units','normalized',...
                'Callback',@UserLocationCallback,...
                'Fontsize',12,...
                'Position',[0.28,0.43,0.5,0.2]);
            ShortestButton = uicontrol(MapPanel,'Style','pushbutton',...
                'String','Closest Water Fountain Map',...
                'Units','normalized',...
                'Callback',@ShortestCallback,...
                'Fontsize',12,...
                'Position',[0.28,0.13,0.5,0.2]);
            % draw the click button if the hall is closed
            CloseBox = uicontrol(MapPanel,'Style','checkbox',...
                'String','Hall Closed?',...
                'Units','normalized',...
                'Fontsize',12,...
                'Callback',@CloseCallback,...
                'Position',[0.8,0.4,0.3,0.3]);
           
            % Calculation Result Panel (bottom right)
            ResultPanel = uipanel('Parent',obj.Figure,...
                'Units','normalized',...
                'Position',[0.5,0,0.5,0.5],...
                'Title','Calculation Results',...
                'Fontsize',12,...
                'TitlePosition','centertop');
            DistButton = uicontrol(ResultPanel,'Style','text',...
                'String','Distance to Closest Water Fountain (mile)',...
                'Units','normalized',...
                'Fontsize',12,...
                'Position',[0.28,0.65,0.5,0.2]);
            DistResult = uicontrol(ResultPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.28,0.60,0.5,0.1],...
                'Foregroundcolor','g',...
                'Fontsize',16,...
                'Background','w');
            TimeButton = uicontrol(ResultPanel,'Style','text',...
                'String','Walking Time to the Fountain (minute)',...
                'Units','normalized',...
                'Fontsize',12,...
                'Position',[0.28,0.25,0.5,0.2]);
            TimeResult = uicontrol(ResultPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.28,0.20,0.5,0.1],...
                'Foregroundcolor','g',...
                'Fontsize',16,...
                'Background','w');
            
            % Callback Funtions
            function FontCallback(h,d)
                size = get(fontBar,'Value');
                % change the font size of each panel
                set(userPanel,'Fontsize',size);
                set(fontText,'Fontsize',size);
                set(userLocation,'Fontsize',size);
                set(userBox,'Fontsize',size);
                set(helpButton,'Fontsize',size);
                set(HallPanel,'Fontsize',size);
                set(ClockDisp,'Fontsize',size);
                set(HallSelectionButton,'Fontsize',size);
                set(HourText,'Fontsize',size);
                set(HourDisp,'Fontsize',size);
                set(MapPanel,'Fontsize',size);
                set(satButton,'Fontsize',size);
                set(roadButton,'Fontsize',size);
                set(terButton,'Fontsize',size);
                set(hybButton,'Fontsize',size);
                set(AllFountainButton,'Fontsize',size);
                set(UserFountainButton,'Fontsize',size);
                set(ShortestButton,'Fontsize',size);
                set(CloseBox,'Fontsize',size);
                set(ResultPanel,'Fontsize',size);
                set(DistButton,'Fontsize',size);
                set(DistResult,'Fontsize',size);
                set(TimeButton,'Fontsize',size);
                set(TimeResult,'Fontsize',size);
            end
            
            function helpCallback(h,d)
                han = helpdlg('Type Your Location in Google Map to Get Latitude and Longitude',...
                    'Reminder');
                set(han,'Pointer','hand');
                uiwait(han);
                web('https://www.gps-coordinates.net/');
            end
            
            function clockCallback(h,d)
                % display current time
                bool = get(ClockDisp,'Value');
                if(bool)
                   % display current time
                   str = datestr(now);
                   uicontrol(HallPanel,'Style','text',...
                   'String',str,'Units','normalized','Fontsize',12,...
                   'Position', [0.75,0.78,0.2,0.12]);
                else
                   uicontrol(HallPanel,'Style','text',...
                   'String','','Units','normalized','Fontsize',12,...
                   'Position', [0.75,0.78,0.2,0.12]);     
                end   
            end
            
            function hourCallback(h,d)
                % disp operating hours based on hall selection popupmenu
                all_hall_name = get(HallSelectionButton,'String');
                selectedIndex = get(HallSelectionButton,'Value');
                selected_hall = all_hall_name(selectedIndex);
                if isequal(selected_hall{1},'Barrows')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Barrows Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/barrows.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?barrows');
                    end
                end
                if isequal(selected_hall{1},'BAM Fountain')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Open All Day',...
                        'BAM Fountain',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/bam.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?class1914');
                    end
                end
                if isequal(selected_hall{1},'Beautiful Outdoor Fountain')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Open All Day 24/7',...
                        'Bueautiful Outdoor Fountain',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/beautiful.jpg');
                            imshow(img);
                        case 'More Details'
                            web('https://www.google.com/maps/d/u/0/viewer?mid=1pmALlRGdmaUSiQao0I85OiEkdSQ&hl=en&ll=37.87143508562357%2C-122.2597915&z=16');
                    end
                end
                if isequal(selected_hall{1},'Birge')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Birge Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/birge.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?birge');
                    end
                end
                if isequal(selected_hall{1},'Boalt')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Boalt Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/boalt.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?boalt');
                    end
                end
                if isequal(selected_hall{1},'Blum')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Blum Center',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/blum.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?blum');
                    end
                end
                if isequal(selected_hall{1},'Class of 52 Fountain')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Open All Day 24/7',...
                        'Class of 52 Fountain',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/52fountain.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map');
                    end
                end
                if isequal(selected_hall{1},'Cory')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Cory Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/cory.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?cory');
                    end
                end
                if isequal(selected_hall{1},'Dwinelle')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Dwinelle Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/dwinelle.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?dwinelle');
                    end
                end
                if isequal(selected_hall{1},'Doe Library')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 10pm Weekend: 8am - 10pm',...
                        'Doe Library',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/doe.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.lib.berkeley.edu/libraries/doe-library');
                    end
                end
                if isequal(selected_hall{1},'Etcheverry')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Etcheverry Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/etcheverry.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?etcheverry');
                    end
                end
                if isequal(selected_hall{1},'Evans')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Evans Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/evans.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?evans');
                    end
                end
                if isequal(selected_hall{1},'Eshelman')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Eshelman Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/eshelman.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?eshelman');
                    end
                end
                if isequal(selected_hall{1},'Faculty Glade')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Open All Day 24/7',...
                        'Faculty Glade',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/facultyglade.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map');
                    end
                end
                if isequal(selected_hall{1},'FSM')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 2am Weekend: 8am - 10pm',...
                        'FSM',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/fsm.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.lib.berkeley.edu/about/fsm-cafe');
                    end
                end
                if isequal(selected_hall{1},'Haas')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Haas School of Business',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/haas.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.haas.berkeley.edu/');
                    end
                end
                if isequal(selected_hall{1},'Hearst Gym')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Hearst Gym',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/hearst.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://eventservices.berkeley.edu/index.php/hearst-gym');
                    end
                end
                if isequal(selected_hall{1},'Kroeber')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Kroeber Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/kroeber.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?kroeber');
                    end
                end
                if isequal(selected_hall{1},'Li Ka Shing')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Li Ka Shing Center',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/likashing.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?likashing');
                    end
                end
                if isequal(selected_hall{1},'Mulford')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Mulford Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/mulford.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?mulford');
                    end
                end
                if isequal(selected_hall{1},'Music Library')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Music Library',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/music.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.lib.berkeley.edu/libraries/music-library');
                    end
                end
                if isequal(selected_hall{1},'RSF')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 1am Weekend: 6am - 11pm',...
                        'RSF',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/rsf.jpg');
                            imshow(img);
                        case 'More Details'
                            web('https://recsports.berkeley.edu/');
                    end
                end
                if isequal(selected_hall{1},'Sproul')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Sproul Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/sproul.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://admissions.berkeley.edu/sproulhall');
                    end
                end
                if isequal(selected_hall{1},'Stanley')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Stanley Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/Stanley.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?stanley');
                    end
                end
                if isequal(selected_hall{1},'Soda')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Soda Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/soda.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?soda');
                    end
                end
                if isequal(selected_hall{1},'Sutardja Dai')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Sutardja Dai Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/sd.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?sutardja');
                    end
                end
                if isequal(selected_hall{1},'Tang Cneter')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Tang Center',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/tangcenter.jpg');
                            imshow(img);
                        case 'More Details'
                            web('https://uhs.berkeley.edu/');
                    end
                end
                if isequal(selected_hall{1},'Tolman')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Tolman Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/tolman.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?tolman');
                    end
                end
                if isequal(selected_hall{1},'University')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'University Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/university.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?university');
                    end
                end
                if isequal(selected_hall{1},'VLSB')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'VLSB Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/vlsb.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?vlsb');
                    end
                end
                if isequal(selected_hall{1},'Wheeler')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Currently Under Construction',...
                        'Wheeler Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/wheeler.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?wheeler');
                    end
                end
                if isequal(selected_hall{1},'Wurster')
                    options.Interpreter = 'tex';
                    options.Default = 'Close';
                    choice = questdlg('Weekday: 6am - 7pm Weekend: closed',...
                        'Wurster Hall',...
                        'Show Image','Close','More Details',options);
                    switch choice
                        case 'Show Image'
                            f = figure;
                            set(f,'Pointer','hand');
                            img = imread('hallimages/wurster.jpg');
                            imshow(img);
                        case 'More Details'
                            web('http://www.berkeley.edu/map?wurster');
                    end
                end     
            end
            
            function WaterFountainCallback(h,d)
                % plot based on map type
                sat = get(satButton,'Value');
                road = get(roadButton,'Value');
                ter = get(terButton,'Value');
                hyb = get(hybButton,'Value');
                if((~sat) && (~road) && (~ter) && (~hyb))
                    warndlg('Must Select A Map Type!','!Warning!');
                elseif(sat && (~road) && (~ter) && (~hyb))
                    obj.WaterFountainPlot('satellite');
                elseif(~sat && (road) && (~ter) && (~hyb))
                    obj.WaterFountainPlot('roadmap');
                elseif(~sat && (~road) && (ter) && (~hyb))
                    obj.WaterFountainPlot('terrain');
                elseif(~sat && (~road) && (~ter) && (hyb))
                    obj.WaterFountainPlot('hybrid');
                else
                    warndlg('Cannot Select More Than One Map Type!','!Warning!');
                end  
            end
            
            function UserLocationCallback(h,d)
                % get user coords input
                data = get(userBox,'String');
                user_loc = strsplit(data,',');
                user_lat = str2double(user_loc{1});
                user_lon = str2double(user_loc{2});
                % plot based on map type
                sat = get(satButton,'Value');
                road = get(roadButton,'Value');
                ter = get(terButton,'Value');
                hyb = get(hybButton,'Value');
                if((~sat) && (~road) && (~ter) && (~hyb))
                    warndlg('Must Select A Map Type!','!Warning!');
                elseif(sat && (~road) && (~ter) && (~hyb))
                    obj.UserWaterFountainPlot('satellite',user_lat,user_lon);
                elseif(~sat && (road) && (~ter) && (~hyb))
                    obj.UserWaterFountainPlot('roadmap',user_lat,user_lon);
                elseif(~sat && (~road) && (ter) && (~hyb))
                    obj.UserWaterFountainPlot('terrain',user_lat,user_lon);
                elseif(~sat && (~road) && (~ter) && (hyb))
                    obj.UserWaterFountainPlot('hybrid',user_lat,user_lon);
                else
                    warndlg('Cannot Select More Than One Map Type!','!Warning!');
                end  
            end
            
            function ShortestCallback(h,d)
                % get user coords input
                data = get(userBox,'String');
                user_loc = strsplit(data,',');
                user_lat = str2double(user_loc{1});
                user_lon = str2double(user_loc{2});
                % plot based on map type
                sat = get(satButton,'Value');
                road = get(roadButton,'Value');
                ter = get(terButton,'Value');
                hyb = get(hybButton,'Value');
                if((~sat) && (~road) && (~ter) && (~hyb))
                    warndlg('Must Select A Map Type!','!Warning!');
                elseif(sat && (~road) && (~ter) && (~hyb))
                    [sd,t] = obj.DistTimeCal('satellite',user_lat,user_lon);
                    % display the distance and the walking time
                    set(DistResult,'String',sd);
                    set(TimeResult,'String',t);
                elseif(~sat && (road) && (~ter) && (~hyb))
                    [sd,t] = obj.DistTimeCal('roadmap',user_lat,user_lon);
                    % display the distance and the walking time
                    set(DistResult,'String',sd);
                    set(TimeResult,'String',t);
                elseif(~sat && (~road) && (ter) && (~hyb))
                    [sd,t] = obj.DistTimeCal('terrain',user_lat,user_lon);
                    % display the distance and the walking time
                    set(DistResult,'String',sd);
                    set(TimeResult,'String',t);
                elseif(~sat && (~road) && (~ter) && (hyb))
                    [sd,t] = obj.DistTimeCal('hybrid',user_lat,user_lon);
                    % display the distance and the walking time
                    set(DistResult,'String',sd);
                    set(TimeResult,'String',t);
                else
                    warndlg('Cannot Select More Than One Map Type!','!Warning!');
                end  
            end
            
            function CloseCallback(h,d)
                bool = get(CloseBox,'Value');
                if(bool)
                    % get user coords input
                    data = get(userBox,'String');
                    if isempty(data)
                        warndlg('Must Input User Location First!','!Warning!');
                    else
                        user_loc = strsplit(data,',');
                        user_lat = str2double(user_loc{1});
                        user_lon = str2double(user_loc{2});
                        % plot based on map type
                        sat = get(satButton,'Value');
                        road = get(roadButton,'Value');
                        ter = get(terButton,'Value');
                        hyb = get(hybButton,'Value');
                        if((~sat) && (~road) && (~ter) && (~hyb))
                            warndlg('Must Select A Map Type!','!Warning!');
                        elseif(sat && (~road) && (~ter) && (~hyb))
                            obj.OpenWaterFountainPlot('satellite',user_lat,user_lon);
                        elseif(~sat && (road) && (~ter) && (~hyb))
                            obj.OpenWaterFountainPlot('roadmap',user_lat,user_lon);
                        elseif(~sat && (~road) && (ter) && (~hyb))
                            obj.OpenWaterFountainPlot('terrain',user_lat,user_lon);
                        elseif(~sat && (~road) && (~ter) && (hyb))
                            obj.OpenWaterFountainPlot('hybrid',user_lat,user_lon);
                        else
                            warndlg('Cannot Select More Than One Map Type!','!Warning!');
                        end
                    end
                end   
            end
            
        end
    end 
    
end

