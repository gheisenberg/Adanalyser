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
        function [data,conf] = prepare(self,conf,eegDevice,edaDevice,hrvDevice)
            
            % reset output directory
            olddirectory = conf.OutputDirectory;
            index = strfind(olddirectory,'\');
            if length(index) > 1
                conf.OutputDirectory = conf.OutputDirectory(1:index(2)-1);
            end
            
            % save used electodes in conifg
            counter = 1;
            conf.electrodes = {};
            for i = 1:length(eegDevice.electrodePositions)
                if eegDevice.electrodeState{i} == 1
                    conf.electrodes{counter} = eegDevice.electrodePositions{i};
                    counter = counter + 1;
                end
            end
            
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

