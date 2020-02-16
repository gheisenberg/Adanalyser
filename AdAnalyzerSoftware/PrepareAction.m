classdef PrepareAction
    % PrepareAction Summary of this class goes here
    % 
    % PrepareAction creates three Objects: 
    %   - ConfigManager : load, save and validate _Config_ objects
    %   - DataFactory   : parses StimulusInterval definitions
    %   - DeviceFactory : pares device config files and sets global
    %                     parameters
    %
    
    properties
        configManager = ConfigManager(); 
        dataFactory = DataFactory();
        deviceFactory = DeviceFactory();
    end
    
    methods
        function [data, eegDevice, edaDevice, hrvDevice] = prepare(self,conf)
            % validate first all paths and settings and if OK 
            % then create the corresponding data
            isValid = self.configManager.validate(conf);
            
            if (isValid)
                
                % parse the device files and create those
                eegDevice = self.deviceFactory.createEEGDevice(conf);
                edaDevice = self.deviceFactory.createEDADevice(conf);
                hrvDevice = self.deviceFactory.createHRVDevice(conf);
                                
                data  = self.dataFactory.createData(conf,eegDevice,edaDevice,hrvDevice);
                data.isValid = 1; 
            end
        end
    end
    
end

