function SaveCircuit(f)
%   Detailed explanation goes here
    cd('C:\Users\jprev\Desktop\QCA\QCA Research\QCAInputSim\Circuits folder');
    Circuit=getappdata(f, 'myCircuit' );
    File = uiputfile('*.mat');
    save(File, 'Circuit');
    home=('C:\Users\jprev\Desktop\QCA\QCA Research\QCAInputSim');
    cd(home);

end

