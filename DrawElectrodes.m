function DrawElectrodes()
%FUNCTION SHOULD BE OBSOLETE

            SignalsList = getappdata(gcf,'SignalsList');
            
            for i=1:length(SignalsList)
                
                if strcmp(SignalsList{i}.IsDrawn,'on')
                    
                    
                    if ~isempty(SignalsList{i}.Height)
                        
                        SignalsList{i} = SignalsList{i}.drawElectrode();
                    else
                        
                    end
                    
                end
            end
            setappdata(gcf,'SignalsList',SignalsList);

end

