% Utility class to cast statistic values to String and format them for print output.
%   Used in AnalyseAction
classdef StringStatistics
    
    properties
    end
    
    methods
        %% Creates printable string table from matrix
        function stats = matrixToString(self,matrix,cSep)
            widths = self.maxColumnWidths(matrix);
            [x,y] = size(matrix);
            stringMat = cell(x,1);
            for i=1:x
                row = matrix(i,:);
                cells = cell(1,y);
                for j=1:y
                    cells(j) = {self.formatCell(row(j),widths(j),cSep)};
                end
                s = sprintf('%s',cells{:});
                lastSep = strfind(fliplr(s),cSep);
                s = s(1:length(s)-(lastSep+length(cSep)-1));
                stringMat(i,:) = {s};
            end
            stats = strtrim(sprintf('%s\n' ,stringMat{:}));
        end
        
        %% Creates printable list from aplitudes 
        function ampString = aplitudesToString(self,amplitudes)
            emptyCells = cellfun(@isempty,amplitudes);
            emptyCells = emptyCells(emptyCells~=0);
            if length(amplitudes) == length(emptyCells)
                ampString='';
            else
                ampString = strtrim([sprintf('%s' ,amplitudes{1:1}) ': ' sprintf('%s, ' ,amplitudes{2:end})]);
                lastUnit = max(strfind(ampString,'S'));
                ampString =  ampString(1:lastUnit); % Amplitudes for intervals .....
            end
        end
        
        %% Creates printable list of delays 
        function delayString = delaysToString(self,delays)
            if isempty(delays{3}) && isempty(delays{2})
                delayString = delays(1); % No valid peaks found for Delta_t
            else
                delayString = [delays(1) ': ' delays(2) 'sec'%', ' delays(3) ', ' delays(4) ', ' delays(5)
                    ];
            end
            delayString = strtrim(sprintf('%s' ,delayString{:})); % Delta_t StimulusInterval X for intervals: ...  
        end
    end
    
    % Private helper methods related to table formatting 
    methods(Access=private)
        %% Finds the max column with for each column of an matrix
        %   Used to ensure correct aligned table columns 
        function maxWidth = maxColumnWidths(self,matrix)
            [~,y] = size(matrix);
            maxWidth = zeros(1,y);
            for i=1:y
                columnWidth = cellfun(@length,matrix(:,i));
                maxWidth(i) = max(columnWidth);
            end
        end
        
        %% Creates string representation of single table cell
        function cellString = formatCell(self,cell,targetSize,cellSep)
            cellLength = length(cell{:});
            numSpaces = targetSize-cellLength;
            %Default return value if cell is empty
            cellString = repmat(' ',1,numSpaces+length(cellSep)); 
            if ~isempty(cell) && cellLength>1
                %If not empty build cellString with: cell content, numSpaces
                %for correct aligmenty and terminating cell seperator 
                cellString = [cell repmat(' ',1,numSpaces) cellSep];
                cellString = sprintf('%s',cellString{:});
            end
        end
    end
end

