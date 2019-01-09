%%% Data Analysis (Normal Cube)


%% PARAMETERS
npart = 50; %nb of participants
ntrperrun=25; %nb of trials/run
nruns=30; %nb of runs
nrunsamb = 10; %nb of runs - ambiguous condition
nrunscue = 5; %nb of runs - cue conditions
ntrials=ntrperrun*nruns;  % nb of trials
ncol=9; % nb of columns in raw data
% col1: control
% col2: group
% col3: cue
% col4: condition
% col5: trial
% col6: inter-stimulus interval
% col7: reaction time
% col8: response
% col9: response time
ncond = 5; % nb of conditions

%% LOAD
data = zeros(ntrials,ncol,npart);

for part = 1:npart
    data(:,:,part) = importdata([cd filesep sprintf('HP%d.mat',part)]); 
end    

%% SWITCH 0-1 (1 - SFA, 0 - SFB)
for part=1:npart
    for tr = 1:ntrials
        if data(tr,8,part) == 1
            data(tr,8,part) = 0;
        elseif data(tr,8,part) == 0
            data(tr,8,part) = 1;
        end
    end
end

%% CHANGE MISATTRIBUTIONS (WRONG GROUP IN THE RAW DATA)
misind = [35,36,37];
misnewgroup = [3,1,2];

data(:,2,misind(1)) = misnewgroup(1);
data(:,2,misind(2)) = misnewgroup(2);
data(:,2,misind(3)) = misnewgroup(3);

%% FORM GROUPS
part1 = [];
part2 = [];
part3 = [];
npart1 = 0;
npart2 = 0;
npart3 = 0;
for part = 1:npart
    group = data(1,2,part);
    if group == 1
        part1 = [part1,part];
        npart1 = npart1 + 1;
    elseif group == 2
        part2 = [part2,part];
        npart2 = npart2 + 1;
    elseif group == 3
        part3 = [part3,part];
        npart3 = npart3 + 1;
    end
end

%% REARRANGE (SEPARATE GROUPS, RUNS)
indata1 = zeros(ntrials,ncol,npart1);
indata2 = zeros(ntrials,ncol,npart2);
indata3 = zeros(ntrials,ncol,npart3);

for part = 1:npart1
    participant = part1(part);
    indata1(:,:,part) = data(:,:,participant);
end

for part = 1:npart2
    participant = part2(part);
    indata2(:,:,part) = data(:,:,participant);
end

for part = 1:npart3
    participant = part3(part);
    indata3(:,:,part) = data(:,:,participant);
end

data1 = zeros(ntrperrun,ncol,nruns,npart1);
data2 = zeros(ntrperrun,ncol,nruns,npart2);
data3 = zeros(ntrperrun,ncol,nruns,npart3);

for part = 1:npart1
    for run = 1:nruns
        for trial = 1:ntrperrun
            data1(trial,:,run,part) = indata1(((run-1)*ntrperrun)+trial,:,part);
        end
    end
end

for part = 1:npart2
    for run = 1:nruns
        for trial = 1:ntrperrun
            data2(trial,:,run,part) = indata2(((run-1)*ntrperrun)+trial,:,part);
        end
    end
end

for part = 1:npart3
    for run = 1:nruns
        for trial = 1:ntrperrun
            data3(trial,:,run,part) = indata3(((run-1)*ntrperrun)+trial,:,part);
        end
    end
end

%% MISSED ANSWERS (NaN)
for part = 1:npart1
    for run = 1:nruns
        for tr = 1:ntrperrun
            if data1(tr,8,run,part) == -1
                data1(tr,8,run,part) = NaN;
            end
        end
    end
end

for part = 1:npart2
    for run = 1:nruns
        for tr = 1:ntrperrun
            if data2(tr,8,run,part) == -1
                data2(tr,8,run,part) = NaN;
            end
        end
    end
end

for part = 1:npart3
    for run = 1:nruns
        for tr = 1:ntrperrun
            if data3(tr,8,run,part) == -1
                data3(tr,8,run,part) = NaN;
            end
        end
    end
end

%% OUTLIER (1.5 IQ RANGE ABOVE/BELOW 3RD/1ST Q)
% data1(:,:,:,[11,13]) = []; 
% npart1 = npart1 - 2;
% data2(:,:,:,[11,12]) = [];
% npart2 = npart2 - 2;
% data3(:,:,:,[5,11,17]) = [];
% npart3 = npart3 - 3;

%% SEPARATE CONDITIONS
datac1 = zeros(ntrperrun,ncol,ncond,nrunsamb,npart1);
datac2 = zeros(ntrperrun,ncol,ncond,nrunsamb,npart2);
datac3 = zeros(ntrperrun,ncol,ncond,nrunsamb,npart3);

for part = 1:npart1
    nruncond = zeros(ncond,1);
    for run = 1:nruns
        condition = data1(1,4,run,part);
        nruncond(condition) = nruncond(condition) + 1;
        datac1(:,:,condition,nruncond(condition),part) = data1(:,:,run,part);
    end
end

for part = 1:npart2
    nruncond = zeros(ncond,1);
    for run = 1:nruns
        condition = data2(1,4,run,part);
        nruncond(condition) = nruncond(condition) + 1;
        datac2(:,:,condition,nruncond(condition),part) = data2(:,:,run,part);
    end
end

for part = 1:npart3
    nruncond = zeros(ncond,1);
    for run = 1:nruns
        condition = data3(1,4,run,part);
        nruncond(condition) = nruncond(condition) + 1;
        datac3(:,:,condition,nruncond(condition),part) = data3(:,:,run,part);
    end
end

for part = 1:npart1
    for run = 1:nrunsamb
        for cond = 1:ncond
            if datac1(1,1,cond,run,part) == 0
                datac1(:,:,cond,run,part) = NaN;
            end
        end
    end
end

for part = 1:npart2
    for run = 1:nrunsamb
        for cond = 1:ncond
            if datac2(1,1,cond,run,part) == 0
                datac2(:,:,cond,run,part) = NaN;
            end
        end
    end
end

for part = 1:npart3
    for run = 1:nrunsamb
        for cond = 1:ncond
            if datac3(1,1,cond,run,part) == 0
                datac3(:,:,cond,run,part) = NaN;
            end
        end
    end
end

%% RELATIVE PREDOMINANCE (PROB.(SFA))
rpperrun1 = squeeze(nanmean(datac1(:,8,:,:,:),1));
rpperrun2 = squeeze(nanmean(datac2(:,8,:,:,:),1));
rpperrun3 = squeeze(nanmean(datac3(:,8,:,:,:),1));

rpperpart1 = squeeze(nanmean(rpperrun1,2));
rpperpart2 = squeeze(nanmean(rpperrun2,2));
rpperpart3 = squeeze(nanmean(rpperrun3,2));

rp1 = squeeze(nanmean(rpperpart1,2));
rp2 = squeeze(nanmean(rpperpart2,2));
rp3 = squeeze(nanmean(rpperpart3,2));

serp1 = squeeze(nanstd(rpperpart1,0,2))./sqrt(npart1);
serp2 = squeeze(nanstd(rpperpart2,0,2))./sqrt(npart2);
serp3 = squeeze(nanstd(rpperpart3,0,2))./sqrt(npart3);

%% STATISTICS

% Effect of Instructions (Kruskal - Wallis : G1 vs. G2 vs. G3_Ambiguous)
group = [repmat(1,npart1,1);repmat(2,npart2,1);repmat(3,npart3,1)];
[prp123amb,hrp123amb,statsrp123amb]=kruskalwallis([rpperpart1(1,:)';rpperpart2(1,:)';rpperpart3(1,:)'],group) 

% Instructions Post-Hoc (Ramk Sum)
[prp12amb,hrp12amb,statsrp12amb]=ranksum(rpperpart1(1,:)',rpperpart2(1,:)') %G1 vs. G2_Amb
[prp23amb,hrp23amb,statsrp23amb]=ranksum(rpperpart2(1,:)',rpperpart3(1,:)') %G2 vs. G3_Amb
[prp13amb,hrp13amb,statsrp13amb]=ranksum(rpperpart1(1,:)',rpperpart3(1,:)') %G1 vs. G3_Amb

% No Cue vs chance (sign rank)
prp1amb = signrank(rpperpart1(1,:)'-0.5) %G1 vs chance 
prp2amb = signrank(rpperpart2(1,:)'-0.5) %G2 vs chance 
prp3amb = signrank(rpperpart3(1,:)'-0.5) %G3 vs chance 

