% Representation of a complete device 
%   Contains:
%           a device name, 
%           a sampling rate 
%           device specific features such as electrode positions(e.g. only for EEG)
%   hence, two different constructors are necessary.
%
% Author: Gernot Heisenberg
%
classdef Device

	properties
        name = "EMPTY";
        samplingRate = 0;
        % electrodePositions is a cell containing the strings for each electrode position
        % access them via electrodePositions(n) 
        electrodePositions = {}; 
	end
	
	methods
        %% Constructor: Creates new EEG device object and sets properties _Name_, _SamplingRate_, _ElectrodePositions_
        function EEGdevice = createEEGDevice(self, name,samplingRate,electrodePositions)
            EEGdevice.name = name; 
            EEGdevice.samplingRate = samplingRate;
            EEGdevice.electrodePositions = electrodePositions;
        end 
        
        %% Constructor: Creates new standard device object (EDA or HRV ) and sets properties _Name_, _SamplingRate_
        function Standarddevice = createStandardDevice(self,name,samplingRate)
            Standarddevice.name = name; 
            Standarddevice.samplingRate = samplingRate;
        end
        
    end
end
