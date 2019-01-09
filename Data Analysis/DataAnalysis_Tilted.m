%%% Data Analysis (Tilted Cube)


%% PARAMETERS
n_trperrun=25; % nb of trials/run
n_runs=30; % nb of runs
n_nocueruns=10; % nb of ambiguous runs
n_cueruns = 5; % nb of runs / cue cond.
n_cond = 5; % nb of conditions
n_nocuetrials=n_trperrun * n_nocueruns; % nb of ambiguous trials
n_cuetrials=n_trperrun * n_cueruns; % nb of trials/cue cond.
n_trials=n_trperrun * n_runs; % nb of trials
n_col=8; % nb of columns in raw data 
  %Col1 = cpgroup --> 1
  %Col2 = run
  %Col3 = contrast
  %Col4 = trial
  %Col5 = IBI
  %Col6 = reaction time
  %Col7 = response
  %Col8 = response time
n_part=15; % nb of participants

%% LOAD
data = zeros(n_trials,n_col,n_part);

for part = 1:n_allpart
    data(:,:,part) = importdata([cd filesep sprintf('tilted_%d.mat',part)]); 
end   

%% SWITCH 0-1 (1 - SFA, 0 - SFB)
for part=1:n_part
    for tr = 1:n_trials
        if data(tr,7,part) == 1
            data(tr,7,part) = 0;
        elseif data(tr,7,part) == 0
            data(tr,7,part) = 1;
        end
    end
end

%% REARRANGEMENT (SEPARATE RUNS)
datanew = zeros(n_trperrun,n_col,n_runs,n_part);
for part = 1:n_part
    for run = 1:n_runs
        for tr = 1:n_trperrun
            datanew(tr,:,run,part)=data(((run-1)*n_trperrun)+tr,:,part);
        end
    end
end

%% REPLACE MISSING RESPONSES (NaN)
data2 = datanew;
for part=1:n_part
    for run = 1:n_runs
        for tr = 1:n_trperrun
            if data2(tr,7,run,part)==-1
                data2(tr,7,run,part) = NaN;
            end
        end
    end
end

%% OUTLIERS (1.5 IQ RANGE ABOVE/BELOW 3RD/1ST Q)
% data(:,:,[2,10,11]) = []; 
% n_part = n_part - 3;

%% SEPARATE CONDITIONS
datac1 = zeros(n_trperrun,n_col,n_nocueruns,n_part);
datac2 = zeros(n_trperrun,n_col,n_cueruns,n_part);
datac3 = zeros(n_trperrun,n_col,n_cueruns,n_part);
datac4 = zeros(n_trperrun,n_col,n_cueruns,n_part);
datac5 = zeros(n_trperrun,n_col,n_cueruns,n_part);

for part = 1:n_part
    counter1 = 0;
    counter2 = 0;
    counter3 = 0;
    counter4 = 0;
    counter5 = 0;
    for run = 1:n_runs
        for tr = 1:n_trperrun
            if tr == 1
                if data2(tr,3,run,part) == 1
                    counter1 = counter1 + 1;
                    datac1(1,: ,counter1,part) = data2(1,:,run,part);
                elseif data2(tr,3,run,part) == 2
                    counter2 = counter2 + 1;
                    datac2(1,: ,counter2,part) = data2(1,:,run,part);
                elseif data2(tr,3,run,part) == 3
                    counter3 = counter3 + 1;
                    datac3(1,: ,counter3,part) = data2(1,:,run,part);
                elseif data2(tr,3,run,part) == 4
                    counter4 = counter4 + 1;
                    datac4(1,: ,counter4,part) = data2(1,:,run,part); 
                elseif data2(tr,3,run,part) == 5
                    counter5 = counter5 + 1;
                    datac5(1,: ,counter5,part) = data2(1,:,run,part);  
                end
            else
                if data2(tr,3,run,part) == 1
                    datac1(tr,: ,counter1,part) = data2(tr,:,run,part);
                elseif data2(tr,3,run,part) == 2
                    datac2(tr,: ,counter2,part) = data2(tr,:,run,part);
                elseif data2(tr,3,run,part) == 3
                    datac3(tr,: ,counter3,part) = data2(tr,:,run,part);
                elseif data2(tr,3,run,part) == 4
                    datac4(tr,: ,counter4,part) = data2(tr,:,run,part);   
                elseif data2(tr,3,run,part) == 5
                    datac5(tr,: ,counter5,part) = data2(tr,:,run,part);   
                end
            end
        end
    end
end

%% RELATIVE PREDOMINANCE 
RelPperpart = zeros(n_cond,n_part);
RelPperpart([1:n_cond],:) = [(squeeze(mean(nanmean(datac1(:,7,:,:),1),3)))'; (squeeze(mean(nanmean(datac2(:,7,:,:),1),3)))'; (squeeze(mean(nanmean(datac3(:,7,:,:),1),3)))'; (squeeze(mean(nanmean(datac4(:,7,:,:),1),3)))'; (squeeze(mean(nanmean(datac5(:,7,:,:),1),3)))'];
meanRelP = nanmean(RelPperpart,2);
seRelP = std(RelPperpart,0,2) / sqrt(n_part);

%% STATISTICS

% Ambiguous vs chance (sign rank)
[prp1randrank,hrp1rand,statsrp1rand]=signrank(RelPperpart(1,:)'-0.5) % 

% Ambiguous vs Normal cube (No Instr.)
[prp1normHP2,hrp1norm,statsrp1norm] = ranksum(RelPperpart(1,:)', rpperpart3(1,:)')

