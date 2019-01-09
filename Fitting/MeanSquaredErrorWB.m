%% FUNCTION MeanSquaredError 


function E = MeanSquaredErrorWB(expmat1,expmat2,expmat3,expmatTilted,param)

Likelihood = [0; param(3); -param(3); param(4); -param(4)];
Prior = [param(2)+param(1),-param(2)+param(1),param(1),0];

theormat = zeros(5,4);
for cue = 1:5
    for instr = 1:4
        Ls = log(((param(5)*exp(Likelihood(cue)))+1-param(5))/(((1-param(5))*exp(Likelihood(cue)))+param(5)));
        Lp = log(((param(6)*exp(Prior(instr)))+1-param(6))/(((1-param(6))*exp(Prior(instr)))+param(6)));
        theormat(cue,instr) = Ls + Lp;
    end
end

sqerr1 = (expmat1 - repmat(theormat(:,1),1,size(expmat1,2))).^2;
sqerr2 = (expmat2 - repmat(theormat(:,2),1,size(expmat2,2))).^2;
sqerr3 = (expmat3 - repmat(theormat(:,3),1,size(expmat3,2))).^2;
sqerrTilted = (expmatTilted - repmat(theormat(:,4),1,size(expmatTilted,2))).^2;

sqerror = [sqerr1,sqerr2,sqerr3,sqerrTilted];

E = mean(mean(sqerror,2),1);

end