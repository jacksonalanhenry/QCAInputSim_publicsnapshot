function [x,iter] = invitr(A, ep,  numitr)  
        [m,n] = size(A);
        if m~=n
          disp('matrix A  is not square')  ;
          return;
        end;
        x=rand(n,1); 
        for k = 1 :  numitr
        iter = k;
         xhat = A \ x;
         x = xhat/norm(xhat,2);
         if norm((A)* x , inf) <= ep
           break;
         end;
        end;
   end