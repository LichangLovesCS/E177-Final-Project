classdef WaterData
    % Micah Cox
    % E177 Spring 2017 Final Project
    
    properties
        Attributes
        Units
        MaxValue
        Years
        Cause
    end
    
    methods
        function obj = WaterData()
            % Pull all data from EBMUD XLS Files
            [~,obj.Attributes,~] = xlsread('2016.xlsx','E2:E14');
            [~,obj.Units,~] = xlsread('2016.xlsx','F2:F14');
            [obj.MaxValue,~,~] = xlsread('2016.xlsx','G2:G14');
            obj.Years = [2009,2010,2011,2012,2013,2014,2015,2016];
            [~,obj.Cause,~] = xlsread('2016.xlsx','D2:D14');
        end
        
        function [maxV,year,units] = findMax(obj,specAttribute)
            yearData = zeros(numel(obj.Years),1);
            % Find index of desired water quality attribute:
            for i = 1:numel(obj.Attributes)
                if strcmp(specAttribute,obj.Attributes{i})
                    index = i;
                    break
                end
            end
            % Extract specific value from each spreadsheet, place in list:
            for i = 1:numel(obj.Years)
                filename = strcat(num2str(obj.Years(i)),'.xlsx');
                allYearData = xlsread(filename,'B2:B14');
                yearData(i,1) = allYearData(index,1);
            end
            % Return max value of list, and corresponding year:
            [maxV, yearI] = max(yearData);
            year = obj.Years(yearI); 
            units = obj.Units{index};
        end
        
        function [minV,year,units] = findMin(obj,specAttribute)
            yearData = zeros(numel(obj.Years),1);
            % Find index of desired water quality attribute:
            for i = 1:numel(obj.Attributes)
                if strcmp(specAttribute,obj.Attributes{i})
                    index = i;
                    break
                end
            end
            % Extract specific value from each spreadsheet, place in list:
            for i = 1:numel(obj.Years)
                filename = strcat(num2str(obj.Years(i)),'.xlsx');
                allYearData = xlsread(filename,'B2:B14');
                yearData(i,1) = allYearData(index,1);
            end
            % Return min value of list, and corresponding year:
            [minV, yearI] = min(yearData);
            year = obj.Years(yearI); 
            units = obj.Units{index};
        end
        
        function plotData(obj,specAttribute)
            yearData = zeros(1,numel(obj.Years));
            % Find index of desired water quality attribute:
            for i = 1:numel(obj.Attributes)
                if strcmp(specAttribute,obj.Attributes{i})
                    index = i;
                    break
                end
            end
            % Extract specific value from each spreadsheet, place in list:
            for i = 1:numel(obj.Years)
                filename = strcat(num2str(obj.Years(i)),'.xlsx');
                allYearData = xlsread(filename,'B2:B14');
                yearData(1,i) = allYearData(index,1);
            end
            legalMax = obj.MaxValue(index)*ones(1,numel(obj.Years));
            % Plot all data:
            figure('Name',['  Yearly Trend Data: ',specAttribute],...
                'Units','normalized',...
                'OuterPosition', [0.2 0.15 0.6 0.7]);
            ax1 = axes('Position',[0 0 1 1],'Visible','off');
            ax2 = axes('Position',[0.1 .2 0.8 .75]);
            
            hold on
            plot(obj.Years,yearData,'bo-')
            plot(obj.Years,legalMax,'r')
            title(['  Yearly Trend Data: ',specAttribute])
            xlabel('Year')
            ylabel(obj.Units{index})
            % Special Data for Lead:
            if strcmp(specAttribute,'Lead')
                plot(obj.Years,5*ones(1,numel(obj.Years)),'m--')
                legend('Yearly Trend Data','FDA Maximum (Tap Water)','FDA Maximum (Bottled Water)')
                note = {'Fun Fact: In 2014, Lead levels in Flint, Michigan reached levels of 104 to 13,200 ppb.'};
                axes(ax1)
                text(0.1,0.1,note)
                text(0.1,0.06,['Cause(s):  ',obj.Cause{index}])
            else
                legend('Yearly Trend Data','FDA Maximum (Tap Water)')
                axes(ax1)
                text(0.1,0.1,['Cause(s):  ',obj.Cause{index}])
            end
            hold off 
        end 
        
    end
    
    
end









