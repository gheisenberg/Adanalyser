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
        function data = prepare(self,conf)
            % validate first and if OK then create the corresponding data
            isValid = self.configManager.validate(conf);
            if (isValid)
                data  = self.dataFactory.createData(conf);
                data.isValid = 1; 
            end
            % parse the device files and create those
            eegDevice = self.deviceFactory.createEEGDevice(conf);
            edaDevice = self.deviceFactory.createEDADevice(conf);
            hrvDevice = self.deviceFactory.createHRVDevice(conf);
            
            % this works - but I cannot pass them out as global vars :-(
            %disp(eegDevice.electrodePositions(1));
            %disp(edaDevice.samplingRate);
            %disp(hrvDevice.samplingRate);
        end
    end
    
end

