% Network-Oriented Modeling in which we take Bartle´s taxonomy of players
% and apply them on a simulation

dbstop if error;
clearvars;
global dt;
global k;

%%%%%%%%%%%%%% Combination functions used %%%%%%%%%%%%
mcf=[2 3 37]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////%

%%%%%%%%%%%%%%% Value role matrices %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% and Initial values %%%%%%%%%%%%%%%%%
mb=[2 3 4 % X1 Killers
2 NaN NaN % X2 Explorers
1 4 3 % X3 Socialicers
1 2 NaN % X4 Achievers
3 1 5 % X5 Ws,k
1 3 6 % X6 Wk,s
1 4 7 % X7 Wk,a
4 1 8 % X8 Wa,k
4 3 9 % X9 Wa,s
2 1 10 % X10 We,k
2 4 11 % X11 We,a
]
mcwv=[NaN NaN NaN % X1 Killers
1 NaN NaN % X2 Explorers
NaN NaN 1 % X3 Socialicers
NaN NaN NaN % X4 Achievers
1 1 1 % X5 Ws,k
1 1 1 % X6 Wk,s
1 1 1 % X7 Wk,a
1 1 1 % X8 Wa,k
1 1 1 % X9 Wa,s
1 1 1 % X10 We,k
1 1 1 % X11 We,a
]
msv=[0.5 % X1 Killers
0.5 % X2 SSs
0.1 % X3 SRSs
0.1 % X4 PSa
1 % X5 SRSe
1 % X6 ESa
1 % X7 W SRSs,PSa
1 % X8 W SRSe,PSa
0.4 % X9 W PSa, SRSe
0.4 % X10 H W SRSs,PSa
0.4 % X11 We,a
]
mcfwv=[1 NaN NaN % X1 Killers
1 NaN NaN % X2 SSs
1 NaN NaN % X3 SRSs
1 NaN NaN % X4 PSa
NaN 1 NaN % X5 SRSe
NaN NaN 1 % X6 ESa
NaN NaN 1 % X7 W SRSs,PSa
NaN 1 NaN % X8 W SRSe,PSa
NaN NaN 1 % X9 W PSa, SRSe
NaN NaN 1 % X10 H W SRSs,PSa
NaN NaN 1 % X11 We,a
]	
mcfpv=cat(3,[5 0.6 % X1 Killers
5 0.2 % X2 SSs
5 -0.7 % X3 SRSs
5 -0.5 % X4 PSa
NaN NaN % X5 SRSe
NaN NaN % X6 ESa
NaN NaN % X7 W SRSs,PSa
NaN NaN % X8 W SRSe,PSa
NaN NaN % X9 W PSa, SRSe
NaN NaN % X10 H W SRSs,PSa
NaN NaN % X11 We,a
],[NaN NaN % X1 Killers
NaN NaN
NaN NaN
NaN NaN
0.999 NaN
NaN NaN
NaN NaN
0.9 NaN
NaN NaN
NaN NaN
NaN NaN % X11 We,a
], [NaN NaN % X1 Killers
NaN NaN
NaN NaN
NaN NaN
NaN NaN
0.999 NaN
0.999 NaN
NaN NaN
0.1 NaN
0.1 NaN
0.1 NaN
])

iv = [0.2; 0.1; 0.8; 0.1; 0.5; -0.1; -0.1; 0.5; -0.1; -0.1; -0.1]
% This is the vector of initial values for all states


%%%%%%%%%%%%%% Adaptation role matrices %%%%%%%%%%%%%
mcwa=[10 5 8 % X1 Killers
NaN NaN NaN
6 9 NaN
7 11 NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN % X11 We,a
]
msa=[NaN % X1 Killers
NaN
NaN
NaN
NaN
NaN
NaN
NaN
NaN
NaN
NaN % X11 We,a
]
mcfwa=[
NaN NaN NaN % X1 Killers
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN
NaN NaN NaN % X11 We,a
]
mcfpa=cat(3,[NaN NaN % X1 Killers
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN % X11 We,a
],[NaN NaN % X1 Killers
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN % X11 We,a
],[NaN NaN % X1 Killers
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN
NaN NaN % X11 We,a
])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////%

%%%%%%%%%%%%% End time and Step size dt %%%%%%%%%%%%%
endtimeofsimulation=50;
dt=0.25;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////%
% dt is the time difference for each of the steps
% note that the time t is k*dt with k = the number of
% steps made in the simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Initialisation for states and time %%%%%%%%
X(:,1)=iv
t(1)=0
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
% Reading the values from the prespecified matrices representing the
% characteristics of the network. As indicated above, these prespecified
% matrices are:
% 1. The base connectivity and nonadaptive values role matrices:
% mb, msv, mcwv, mcfwv, mcfpv
% for the base connectivity and values of the nonadaptive characteristics
% (speed factors, connection weights, combination function
% weights, and combination function parameters), and
% 2. The adaptivity role matrices:
% msa, mcwa, mcfwa, mcfpa
% for adaptive network characteristics.
% If only a NaN value is found in both types of role matrices,
% a default value 0 or 1 is chosen.
for j = 1:nos
if not(isnan(msa(j, 1)))
s(j, k) = X(msa(j, 1), k);
elseif not(isnan(msv(j, 1)))
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
if not(isnan(mcwa(j, p)))
cw(j, p, k) = X(mcwa(j,p), k);
elseif not(isnan(mcwv(j, p)))
cw(j, p, k) = mcwv(j, p);
elseif isnan(mcwv(j, p))
cw(j, p, k) = 0;
end
end
for m=1:1:nocf
if not(isnan(mcfwa(j, m)))
cfw(j, m, k) = X(mcfwa(j, m), k);
elseif not(isnan(mcfwv(j, m)))
cfw(j, m, k) = mcfwv(j, m);
elseif isnan(mcfwv(j, m))
cfw(j, m, k) = 0;
end
end
for p=1:1:nocfp
for m=1:1:nocf
if not(isnan(mcfpa(j, p, m)))
cfp(j, p, m, k) = X(mcfpa(j, p, m), k);
elseif not(isnan(mcfpv(j, p, m)))
cfp(j, p, m, k) = mcfpv(j, p, m);
elseif isnan(mcfpv(j, p, m))
cfp(j, p, m, k) = 1;
end
end
end
% The actual simulation
% Next, the actual simulation step follows.
% Here, first
% squeeze(cw(j, :, k)).*squeeze(b(j, :, k))
% indicates the vector v of single impacts for state j at k
% used as values in the m-th selected combination function bcf(mcf(m),p,v).
% (See Book 2, Chapter 2, Section 2.3.1, Table 2.2, second row)
% This v is the calculated as the elementwise multiplication of the vectors
% squeeze(cw(j, :, k)) and squeeze(b(j, :, k))
% of connection weights and of state values, respectively.
% Moreover,
% squeeze(cfp(j, :, m, k))
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
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% Plot graph and store data %%%%%%%%%%%%%%
% Plot with vertical legend:
legend(plot([t;t;t;t;t;t;t;t;t;t;t]', [X(1,:);X(2,:);X(3,:);X(4,:); X(5,:);X(6,:);X(7,:);X(8,:);X(9,:);X(10,:);X(11,:);]'),{'X1 Killer','X2 Explorers','X3 Socialisers','X4 Achievers','X5','X6','X7','X8','X9','X10','X11'});
% Plot with horizontal legend:
% legend(plot([t;t;t;t;t;t;t;t;t;t]', [X(1,:);X(2,:);X(3,:);X(4,:); X(5,:);X(6,:);X(7,:);X(8,:);X(9,:);X(10,:);]'),{'X1','X2','X3','X4','X5','X6','X7','X8','X9','X10'},'Orientation','horizontal');
% Store data in Excel file:
% xlswrite('example.xls',X');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////%

