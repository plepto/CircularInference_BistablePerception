%%% Naive Bayes
%%% After DataAnalysis_Normal/Tilted

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

expmatrix1 = logrrpperpart1;
expmatrix2 = logrrpperpart2;
expmatrix3 = logrrpperpart3;
expmatrixTilted = logrrpperpartTilted;

vIB = [-5:0.05:5]; % discretization for initial values
vInstr = [-5:0.05:5];
vCueStr = [-5:0.05:5];
vCueWeak = [-5:0.05:5];
for i = 1:100 % 100 repetitions starting from different initial values and choosing the parameters that give the best fit
    rpIB = vIB(randperm(length(vIB))); % initial values
    IB0 = rpIB(1);
    rpInstr = vInstr(randperm(length(vInstr)));
    Instr0 = rpInstr(1);
    rpCueStr = vCueStr(randperm(length(vCueStr)));
    CueStr0 = rpCueStr(1);
    rpCueWeak = vCueWeak(randperm(length(vCueWeak)));
    CueWeak0 = rpCueWeak(1);
    [par(:,i),fval(:,i)] = fminsearch(@(x)MeanSquaredErrorNB(expmatrix1,expmatrix2,expmatrix3,expmatrixTilted,x),[IB0,Instr0,CueStr0,CueWeak0],optimset('MaxFunEvals',10000));
%    [par(:,i),fval(:,i)] = fmincon(@(x)MeanSquaredErrorNB(expmatrix1,expmatrix2,expmatrix3,expmatrixTilted,x),[IB0,Instr0,CueStr0,CueWeak0],[],[],[],[],[-5,-5,-5,-5],[5,5,5,5]);
end
[u,v]=min(fval); 
param=par(:,v); % values of free parameters
error=u; % error for optimal parameters

n = (npart1+npart2+npart3+n_part)*5; % data points
k = 4; % free parameters
BIC_NB = n*log(error) + k*log(n)

