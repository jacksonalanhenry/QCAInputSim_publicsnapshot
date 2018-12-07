function normpsi = Relax2GroundState_parallelCalculation(mycircuit, time, idx, chi)






        %get the new groundstate, average and normalize
        %the current groundstate and the new
        %groundstate then calculate pol with that psi
        [V, EE] = eig(hamiltonian);
        newpsi = V(:,1);



        normpsi = (1-chi)*mycircuit.Device{idx}.Wavefunction + chi*newpsi;
        normpsi = normalize_psi_1D(normpsi');


% 
%         %calculate polarization
%         mycircuit.Device{idx} = mycircuit.Device{idx}.Calc_Polarization_Activation(normpsi');
% 
%         if(isa(mycircuit.Device{idx}, 'QCASuperCell'))
%             NewCircuitPols(idx) = 0;
%         else
%             NewCircuitPols(idx) = mycircuit.Device{idx}.getPolarization(time);
%         end

        %disp(['id: ', num2str(id), ' pol: ', num2str(pol)  ' nl: ', num2str(nl)])

    

    
end