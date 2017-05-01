classdef UserClass
    % Tushar Malik
    % E177 Final Project
    
    properties
        Height = {}
        Weight ={}
        Name = {}
        History = 0
    end
    
    methods
        function B = BMI(obj,weight,height)
            B = (str2double(weight)/(str2double(height))^2);
       % Function to Calculate BMI of the User.
       % This function takes in the weight and height of the user and
       % outputs their BMI.
        end
        
        function D = Drink(obj,weight)
            D = str2double(weight)/2;
       % Function to calucate the recommended amount of water a user should
       % drink.
       % This function takes in the user's height and divided] it by two to
       % output the recommendation for the user.
        end

        function H = history(obj,historyy)
                if isequal(obj.History,0)
                    obj.History = str2double(historyy);
                    H = str2double(historyy);
                else
                    H = str2double(historyy)+obj.History;
                    obj.History = str2double(historyy);
                end
       % This Function allows the user to keep adding the history of water
       % that they are drinking.
        end
        
        function P = PBS(obj,hiss) 
            P = (hiss/16.9);
        % This function calculates the amount of plastic bottles that the
        % User is saving by taking in the User history of drinking water. 
        end
        

        function M = Meters(obj,ft,inches)
             M = (str2double(ft)*12 + str2double(inches))/39.3701;
        % This function takes in length in fts and inches and convets it
        % into meters.
        end
        

        function L = Lbs(obj,kgs)
             L = str2double(kgs)*2.20462;
        % This function takes in weight in Kilograms and convets it into
        % Pounds.
        end
    end
    
end

