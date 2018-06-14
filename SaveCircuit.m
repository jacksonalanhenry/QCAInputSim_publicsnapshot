function SaveCircuit(f,handles)
%   Detailed explanation goes here
% Add capability to save other parameters: clocking field-wavelength, and
% period, speed of bit packet (from sinusoid)

    Path = getappdata(gcf,'Path');
    
    cd('C:\Users\jprev\Desktop\QCA\QCA Research\QCAInputSim\Circuits folder');
%     cd('\Circuits folder');
    Circuit=getappdata(f, 'myCircuit' );
    File = uiputfile('*.mat');
    
    save(File, 'Circuit');
%     home=('C:\Users\jprev\Desktop\QCA\QCA Research\QCAInputSim');
    cd(Path.home);

end

