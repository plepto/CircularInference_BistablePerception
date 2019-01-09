%% FUNCTION MeanSquaredError 

function E = MeanSquaredErrorCI(expmat1,expmat2,expmat3,expmatTilted,param)

Likelihood = [0; param(3); -param(3); param(4); -param(4)];
Prior = [param(2)+param(1),-param(2)+param(1),param(1),0];

theormat = zeros(5,4);
for cue = 1:5
    for instr = 1:3
        SE = Likelihood(cue);
        Pr = Prior(instr);
        Ls = log(((param(5)*exp(SE))+1-param(5))/(((1-param(5))*exp(SE))+param(5)));
        Lp = log(((param(6)*exp(Pr))+1-param(6))/(((1-param(6))*exp(Pr))+param(6)));
        preds = log(((param(5)*exp(SE+Lp+Ls))+1-param(5))/(((1-param(5))*exp(SE+Lp+Ls))+param(5)));
        predp = log(((param(6)*exp(Pr+Ls+Lp))+1-param(6))/(((1-param(6))*exp(Pr+Ls+Lp))+param(6)));
        theormat(cue,instr) = preds + predp;
    end
end

for cue = 1:5
    instr = 4;
    SE = Likelihood(cue);
    Pr = Prior(instr);
    Ls = log(((param(5)*exp(SE))+1-param(5))/(((1-param(5))*exp(SE))+param(5)));
    Lp = log(((0.5*exp(Pr))+1-0.5)/(((1-0.5)*exp(Pr))+0.5));
    preds = log(((param(5)*exp(SE+Lp+Ls))+1-param(5))/(((1-param(5))*exp(SE+Lp+Ls))+param(5)));
    predp = log(((0.5*exp(Pr+Ls+Lp))+1-0.5)/(((1-0.5)*exp(Pr+Ls+Lp))+0.5));
    theormat(cue,instr) = preds + predp;
end

sqerr1 = (expmat1 - repmat(theormat(:,1),1,size(expmat1,2))).^2;
sqerr2 = (expmat2 - repmat(theormat(:,2),1,size(expmat2,2))).^2;
sqerr3 = (expmat3 - repmat(theormat(:,3),1,size(expmat3,2))).^2;
sqerrTilted = (expmatTilted - repmat(theormat(:,4),1,size(expmatTilted,2))).^2;

sqerror = [sqerr1,sqerr2,sqerr3,sqerrTilted];

E = mean(mean(sqerror,2),1);

end