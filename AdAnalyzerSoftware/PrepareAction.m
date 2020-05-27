classdef PrepareAction
    % PrepareAction Summary of this class goes here
    % 
    % PrepareAction creates three Objects: 
    %   - ConfigManager : load, save and validate _Config_ objects
    %   - DataFactory   : parses StimulusInterval definitions
    %   - DeviceFactory : pares device config files and sets global
    %                     parameters
    %
    % Author: Gernot Heisenberg
    %
    
    properties
        configManager = ConfigManager(); 
        dataFactory = DataFactory();
    end
    
    methods
        %utilize the different factories
        function data = prepare(self,conf,eegDevice,edaDevice,hrvDevice)
            % validate first all paths and settings and if OK 
            % then create the corresponding data
            isValid = self.configManager.validate(conf);
            
            if (isValid)
                                
                data  = self.dataFactory.createData(conf,eegDevice,edaDevice,hrvDevice);
                data.isValid = 1; 

            end
        end
    end
    
end

