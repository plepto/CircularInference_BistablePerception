%%% Weighted Bayes 


%% IF RP = 0 --> RP = 0.02
rpperpart1(rpperpart1 == 0) = 0.02;
rpperpart2(rpperpart2 == 0) = 0.02;
rpperpart3(rpperpart3 == 0) = 0.02;
RelPperpart(RelPperpart == 0) = 0.02;

%% LOG RATIO RP
logrrpperpart1 = log(rpperpart1./(1-rpperpart1));
logrrpperpart2 = log(rpperpart2./(1-rpperpart2));
logrrpperpart3 = log(rpperpart3./(1-rpperpart3));
logrrpperpartTilted = log(RelPperpart./(1-RelPperpart));

%% FITTING

% Parameters: 
% 1 - IB: Implicit Bias
% 2 - Instr: Instructions
% 3 - CueStr: Cue Strong
% 4 - CueWeak: Cue Weak
% 5 - ws: sensory weight
% 6 - wp: prior weight

expmatrix1 = logrrpperpart1;
expmatrix2 = logrrpperpart2;
expmatrix3 = logrrpperpart3;
expmatrixTilted = logrrpperpartTilted;

vIB = [-5:0.05:5]; % Discretization for initial values
vInstr = [-5:0.05:5];
vCueStr = [-5:0.05:5];
vCueWeak = [-5:0.05:5];
vws = [0.5:0.01:1];
vwp = [0.5:0.01:1];
for i = 1:100 % 100 repetitions starting from different initial values
    rpIB = vIB(randperm(length(vIB)));
    IB0 = rpIB(1);
    rpInstr = vInstr(randperm(length(vInstr)));
    Instr0 = rpInstr(1);
    rpCueStr = vCueStr(randperm(length(vCueStr)));
    CueStr0 = rpCueStr(1);
    rpCueWeak = vCueWeak(randperm(length(vCueWeak)));
    CueWeak0 = rpCueWeak(1);
    rpws = vws(randperm(length(vws)));
    ws0 = rpws(1);
    rpwp = vwp(randperm(length(vwp)));
    wp0 = rpwp(1);
    [par(:,i),fval(:,i)] = fmincon(@(x)MeanSquaredErrorWB(expmatrix1,expmatrix2,expmatrix3,expmatrixTilted,x),[IB0,Instr0,CueStr0,CueWeak0,ws0,wp0],[],[],[],[],[-5,-5,-5,-5,0.5,0.5],[5,5,5,5,1,1]);
end
[u,v]=min(fval);
param=par(:,v); % values of free parameters
error=u; % error for optimal values

n = (npart1+npart2+npart3+n_part)*5; % nb of data points
k = 6; % free parameters
BIC_WB = n*log(error) + k*log(n)


