classdef MapData
    %MAPPLOTTER plots the water fountain locations on UC Berkeley campus
    % @Author: Lichang Xu
    
    properties
        lat;
        lon;
        Hall;
    end
    
    methods
        % Class Constructor
        function obj = MapData()
            obj.Hall = {'Barrows','BAM Fountain','Beautiful Outdoor Fountain',...
                'Birge','Boalt','Blum','Class of 52 Fountain','Cory','Dwinelle',...
                'Doe Library','Etcheverry','Evans','Eshelman','Faculty Glade',...
                'FSM','Haas','Hearst Gym','Kroeber','Li Ka Shing',...
                'Mulford','Music Library','RSF','Sproul','Stanley','Soda',...
                'Sutardja Dai','Tang Cneter','Tolman','University',...
                'VLSB','Wheeler','Wurster'};
            obj.lat = [37.870066 37.871047 37.869607 37.872241 37.869960...
            37.874895 37.869509 37.875070 37.870566 37.872226...
            37.875688 37.873738 37.868786 37.871434 37.872650...
            37.871583 37.869484 37.869861 37.873202 37.872640...
            37.870495 37.868586 37.869616 37.873975 37.875667...
            37.874868 37.867668 37.874130 37.871897 37.871521...
            37.871545 37.870586];
        
            obj.lon = [-122.257570 -122.266434 -122.258465 -122.256739...
            -122.252390 -122.258592 -122.253805 -122.262182 -122.256938...
            -122.260164 -122.259067 -122.258680 -122.257048 -122.259955...
            -122.256626 -122.260451 -122.253470 -122.257233 -122.254562...
            -122.264448 -122.264037 -122.255607 -122.262450 -122.258486...
            -122.255720 -122.258257 -122.257691 -122.263760 -122.263580...
            -122.261431 -122.258742 -122.254250];
        end
                
        % Plot all the water fountain locations via Google Map API
        function WaterFountainPlot(plotter_obj,map_type)
            if(nargin ~= 2)
                error('must input a specific map type');
            end
            han = waitbar(0,'Loading All Fountain Locations...');
            set(han,'Pointer','hand');
            steps = 400;
            for step = 1:steps
                waitbar(step / steps)
            end
            close(han)
            f = figure('Name','UC Berkeley Water Fountain Map');
            set(f,'Pointer','hand');
            set(f,'Units','normalized','Position',[0.2,0.25,0.6,0.5]);
            plot(plotter_obj.lon,plotter_obj.lat,'.m','MarkerSize',30);
            legend('Water Fountain Location');
            google_map('maptype',map_type)
        end
        
        % plot water fountains that open 24 hours
        function OpenWaterFountainPlot(plotter_obj,map_type,user_lat,user_lon)
            fountain_lat = [37.870861,37.869582,37.869763,37.872616,...
                            37.870487,37.868595];
            fountain_lon = [-122.266080,-122.258550,-122.254610,-122.260383,...
                            -122.255725,-122.262374];
            han = waitbar(0,'Loading Open Fountain Locations...');
            set(han,'Pointer','hand');
            steps = 400;
            for step = 1:steps
                waitbar(step / steps)
            end
            close(han)
            % Plot user location and open water fountains
            f = figure('Name','Possibly Open Water Fountain Map');
            set(f,'Pointer','hand');
            set(f,'Units','normalized','Position',[0.2,0.25,0.6,0.5]);
            plot(fountain_lon,fountain_lat,'pr','MarkerSize',30);
            hold on;
            plot(user_lon,user_lat,'*b','MarkerSize',40);
            % add proper annotation and legend
            txt1 = 'Your Location';
            text(user_lon,user_lat,txt1);
            legend('Possibly Open Water Fountain','You');
            google_map('maptype',map_type)
        end
        
        % Plot water fountain locations together with user location
        function UserWaterFountainPlot(plotter_obj,map_type,user_lat,user_lon)
            if(nargin ~= 4)
                error('must input map type or current user location!');
            end
            han = waitbar(0,'Loading User Locations...');
            set(han,'Pointer','hand');
            steps = 400;
            for step = 1:steps
                waitbar(step / steps)
            end
            close(han)
            f = figure('Name','User Location Map');
            set(f,'Pointer','hand');
            set(f,'Units','normalized','Position',[0.2,0.25,0.6,0.5]);
            plot(plotter_obj.lon,plotter_obj.lat,'.r','MarkerSize',30);
            hold on;
            % mark user location on the graph
            plot(user_lon,user_lat,'hb','MarkerSize',40);
            % add proper annotation and legend
            txt1 = 'Your Location';
            text(user_lon,user_lat,txt1);
            legend('Water Fountain','You');
            google_map('maptype',map_type)
        end
        
        % Output shortest distance between user location and water fountain
        % Output the walking time from user location to fountain (min)
        function [sd,t] = DistTimeCal(plotter_obj,map_type,user_lat,user_lon)
            if(nargin ~= 4)
                error('must input the current user latitude and longitude!');
            end
            % assign sd to an initial value
            sd = DistConverter(user_lat, user_lon,...
                plotter_obj.lat(1), plotter_obj.lat(1));
            for i = 2:numel(plotter_obj.lat)
                fountain_lat = plotter_obj.lat(i);
                fountain_lon = plotter_obj.lon(i);
                shortest_d = DistConverter(user_lat,user_lon,...
                             fountain_lat, fountain_lon);
                % update sd if necessary
                if(shortest_d < sd)
                    sd = shortest_d;
                    closest_f_lat = plotter_obj.lat(i);
                    closest_f_lon = plotter_obj.lon(i);
                end
            end
            % get the closest hall name
            index = find(plotter_obj.lat == closest_f_lat);
            f_name = plotter_obj.Hall{index};
            
            han = waitbar(0,'Loading Closest Fountain Location...');
            set(han,'Pointer','hand');
            steps = 400;
            for step = 1:steps
                waitbar(step / steps)
            end
            close(han)
            % Plot user location and the closest water fountain
            f = figure('Name','Closest Water Fountain Map');
            set(f,'Pointer','hand');
            set(f,'Units','normalized','Position',[0.2,0.25,0.6,0.5]);
            plot(closest_f_lon,closest_f_lat,'sk','MarkerSize',30);
            hold on;
            plot(user_lon,user_lat,'.b','MarkerSize',50);
            % connect user location with the fountain location
            plot([user_lon,closest_f_lon],[user_lat,closest_f_lat],...
                'r-.','LineWidth',2);
            % add proper annotation and legend
            txt1 = 'Your Location';
            text(user_lon,user_lat,txt1);
            txt2 = f_name;
            text(closest_f_lon,closest_f_lat,txt2);
            legend('Closest Water Fountain','You');
            google_map('maptype',map_type)
            % calculate the walking time t
            human_vel = 0.051667; % mile/min
            t = sd / human_vel; % min
            % Subfunction to calculate distance from latitude and longitude
            function dist = DistConverter(lat1,lon1,lat2,lon2)
                R = 3961; % earth radius (miles)
                d_lat = deg2rad(lat2 - lat1);
                d_lon = deg2rad(lon2 - lon1);
                a = sin(d_lat/2)*sin(d_lat/2)+cos(deg2rad(lat1))...
                    *cos(deg2rad(lat2))*sin(d_lon/2)*sin(d_lon/2);
                c = 2*atan2(sqrt(a),sqrt(1-a));
                dist = R*c;
                % helper function to convert degree to radian
                function rad = deg2rad(deg)
                    rad = deg*(pi/180);
                end
            end
        end
               
    end
    
end

