dbstop if error;
clearvars;
global dt;
global k;

%%%%%%%%%%%%%% Combination functions used %%%%%%%%%%%%
mcf=[2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////%

%%%%%%%%%%%%%% Value role matrices %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% and Initial values %%%%%%%%%%%%%%%%%%%

mb=[2 3 4
2 NaN NaN
1 4 3
1 2 NaN
];

mcwv=[-0.1 1 1
1 NaN NaN
-1 -0.1 1
-1 -0.1 NaN
];
msv=[0.4
0.4
0.4
0.4
];
mcfwv=[1
1
1
1
];
mcfpv = cat(3,[5	0.6
5	0.2
5	-0.7 
5	-0.5 
]);


iv = [0.01; 0.1; 0.8; 0.1];
% This is the vector of initial values for all states

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////%



%%%%%%%%%%%%% End time and Step size dt %%%%%%%%%%%%%
endtimeofsimulation=60;
dt=0.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////%

% dt is the time difference for each of the steps
% note that the time t is k*dt with k = the number of 
% steps made in the simulation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Initialisation for states and time %%%%%%%%
X(:,1)=iv
t(1)=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Setting dimensions %%%%%%%%%%%%%%%%%
nos = numel(iv);
nocf = numel(mcf);
nocfp = size(mcfpv,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This identifies some of the dimensions of the vectors and matrices
% nos = number of states
% nocf = number of combination functions used
% nocfp = number of combination function parameters used

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Simulation steps %%%%%%%%%%%%%%%%%

for k=1:endtimeofsimulation/dt
    
        % First the values from the prespecified role matrices representing the 
        % characteristics of the network are read. These prespecified matrices are 
        %     msv, mbv, mcwv, mcfwv, mcfpv 
        % for the values of static network characteristics. If a NaN value is
        % found,a default value 0 or 1 is chosen.
       
    for j = 1:nos

    if not(isnan(msv(j, 1))) 
        s(j, k) = msv(j, 1);
    elseif isnan(msv(j, 1)) 
        s(j, k) = 0;
    end

    for p=1:1:size(mb,2)
        if not(isnan(mb(j, p)))
            b(j, p, k) = X(mb(j,p), k);
        elseif isnan(mb(j, p))
            b(j, p, k) = 0;
        end
    end
    for p=1:1:size(mcwv,2)
        if not(isnan(mcwv(j, p))) 
            cw(j, p, k) = mcwv(j, p);
        elseif isnan(mcwv(j, p)) 
            cw(j, p, k) = 0;
        end
    end
    for m=1:1:nocf
        if not(isnan(mcfwv(j, m))) 
            cfw(j, m, k) = mcfwv(j, m);   
        elseif isnan(mcfwv(j, m)) 
            cfw(j, m, k) = 0;
        end
    end
    for p=1:1:nocfp  
        for m=1:1:nocf 
           if not(isnan(mcfpv(j, p, m))) 
                cfp(j, p, m, k) = mcfpv(j, p, m);
           elseif isnan(mcfpv(j, p, m)) 
                cfp(j, p, m, k) = 1;
           end
        end
    end
    
            % Next, the actual simulation step follows. 
            % Here, first
            %       squeeze(cw(j, :, k)).*squeeze(b(j, :, k)) 
            % indicates the vector v of single impacts for state j at k
            % used as values in the m-th selected combination function bcf(mcf(m),p,v). 
            % (See Book 2, Chapter 2, Section 2.3.1, Table 2.2, second row)
            % This v is the calculated as the elementwise multiplication of the vectors 
            %       squeeze(cw(j, :, k)) and  squeeze(b(j, :, k))
            % of connection weights and of state values, respectively.
            % Moreover,
            %       squeeze(cfp(j, :, m, k)) 
            % is the vector p of parameter values for combination function
            % bcf(mcf(m),p,v) for state j at k.
            % This calculates the combination function values cfv(j,m,k)for each selected  
            % combination function bcf(mcf(m),p,v) for state j at k
        for m=1:1:nocf
                cfv(j,m,k) = bcf(mcf(m), squeeze(cfp(j, :, m, k)), squeeze(cw(j, :, k)).*squeeze(b(j, :, k)));
        end
           
        aggimpact(j, k) = dot(cfw(j, :, k), cfv(j, :, k))/sum(cfw(j, :, k));
            % The aggregated impact for state j at k is calculated as dotproduct (inproduct) of
            % combination function weights and combination function values
            % scaled by the sum of these weights.
            % (See Book 2, Chapter 2, Section 2.3.1, Table 2.2, third row, and formula (2) in Section 2.3.2)
        
        X(j,k+1) = X(j,k) + s(j,k)*(aggimpact(j,k) - X(j,k))*dt;
            % This is the actual iteration step from k to k+1 for state j;
            % (See Book 2, Chapter 2, Section 2.3.1, Table 2.2, third row)
            
        t(k+1) = t(k)+dt;
            % This keeps track on time t;
       end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%\\\\\\\\\\\\\\\\\ TO BE FILLED \\\\\\\\\\\\\\\\\\\\%
%%%%%%%%%%%% Plot graph and store data %%%%%%%%%%%%%%
% Plot with vertical legend: 
%legend(plot([t;t;t;t]', [X(1,:);X(2,:);X(3,:);X(4,:)}), {"Killer"; "Explorer"; "Socializer"; "Achiever"});
% Plot with horizontal legend: 
legend(plot([t;t;t;t]', [X(1,:);X(2,:);X(3,:);X(4,:)]'),{'X1 Killer','X2 Explorer','X3 Socializer','X4 Achiever'});
% Store data in Excel file:
% xlswrite('example.xls',X');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////%




