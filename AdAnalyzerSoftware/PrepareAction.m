classdef PrepareAction
    %PREPAREACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        configManager = ConfigManager(); 
        dataFactory = DataFactory();
    end
    
    methods
        function data = prepare(self,conf)
            isValid = self.configManager.validate(conf);
            if (isValid)
                data  = self.dataFactory.createData(conf);
                data.isValid = 1; 
            end
        end
    end
    
end

