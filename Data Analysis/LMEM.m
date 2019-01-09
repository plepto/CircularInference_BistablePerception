%%% LMEM
%%% (After running DataAnalysis_Normal/Tilted)


npart1 = 14;
npart2 = 14;
npart3 = 15;
npartTilted = 12;

% Model 1: Var = Prior + Cue + (1|Subj) + (Cue - 1|Subj)
% Model 2: Var = Prior + Cue + (Prior*Cue) + (1|Subj) + (Cue-1|Subj)

% Prior: Instr. Supp. ,Instr. Contr. ,Implicit Bias, No Prior
% Cue: Contrast --> diff/256: Cond1 = 0, Cond2 = 0.31, Cond3 = -0.31, 
% Cond4 = 0.19, Cond5 = -0.19

% SETUP

lmegroup=[repmat(['s'],npart1,1);repmat(['c'],npart2,1);repmat(['n'],npart3,1);repmat(['t'],npartTilted,1);repmat(['s'],npart1,1);repmat(['c'],npart2,1);repmat(['n'],npart3,1);repmat(['t'],npartTilted,1);repmat(['s'],npart1,1);repmat(['c'],npart2,1);repmat(['n'],npart3,1);repmat(['t'],npartTilted,1);repmat(['s'],npart1,1);repmat(['c'],npart2,1);repmat(['n'],npart3,1);repmat(['t'],npartTilted,1);repmat(['s'],npart1,1);repmat(['c'],npart2,1);repmat(['n'],npart3,1);repmat(['t'],npartTilted,1)];  
lmecue=[repmat(0,npart1+npart2+npart3+npartTilted,1);repmat(0.31,npart1+npart2+npart3+npartTilted,1);repmat(-0.31,npart1+npart2+npart3+npartTilted,1);repmat(0.19,npart1+npart2+npart3+npartTilted,1);repmat(-0.19,npart1+npart2+npart3+npartTilted,1)];  
lmepart=['s01';'s02';'s03';'s04';'s05';'s06';'s07';'s08';'s09';'s10';'s11';'s12';'s13';'s14';'s15';'s16';'s17';'s18';'s19';'s20';'s21';'s22';'s23';'s24';'s25';'s26';'s27';'s28';'s29';'s30';'s31';'s32';'s33';'s34';'s35';'s36';'s37';'s38';'s39';'s40';'s41';'s42';'s43';'s44';'s45';'s46';'s47';'s48';'s49';'s50';'s51';'s52';'s53';'s54';'s55';'s01';'s02';'s03';'s04';'s05';'s06';'s07';'s08';'s09';'s10';'s11';'s12';'s13';'s14';'s15';'s16';'s17';'s18';'s19';'s20';'s21';'s22';'s23';'s24';'s25';'s26';'s27';'s28';'s29';'s30';'s31';'s32';'s33';'s34';'s35';'s36';'s37';'s38';'s39';'s40';'s41';'s42';'s43';'s44';'s45';'s46';'s47';'s48';'s49';'s50';'s51';'s52';'s53';'s54';'s55';'s01';'s02';'s03';'s04';'s05';'s06';'s07';'s08';'s09';'s10';'s11';'s12';'s13';'s14';'s15';'s16';'s17';'s18';'s19';'s20';'s21';'s22';'s23';'s24';'s25';'s26';'s27';'s28';'s29';'s30';'s31';'s32';'s33';'s34';'s35';'s36';'s37';'s38';'s39';'s40';'s41';'s42';'s43';'s44';'s45';'s46';'s47';'s48';'s49';'s50';'s51';'s52';'s53';'s54';'s55';'s01';'s02';'s03';'s04';'s05';'s06';'s07';'s08';'s09';'s10';'s11';'s12';'s13';'s14';'s15';'s16';'s17';'s18';'s19';'s20';'s21';'s22';'s23';'s24';'s25';'s26';'s27';'s28';'s29';'s30';'s31';'s32';'s33';'s34';'s35';'s36';'s37';'s38';'s39';'s40';'s41';'s42';'s43';'s44';'s45';'s46';'s47';'s48';'s49';'s50';'s51';'s52';'s53';'s54';'s55';'s01';'s02';'s03';'s04';'s05';'s06';'s07';'s08';'s09';'s10';'s11';'s12';'s13';'s14';'s15';'s16';'s17';'s18';'s19';'s20';'s21';'s22';'s23';'s24';'s25';'s26';'s27';'s28';'s29';'s30';'s31';'s32';'s33';'s34';'s35';'s36';'s37';'s38';'s39';'s40';'s41';'s42';'s43';'s44';'s45';'s46';'s47';'s48';'s49';'s50';'s51';'s52';'s53';'s54';'s55'];

% LMEM

rp = [rpperpart1(1,:)';rpperpart2(1,:)';rpperpart3(1,:)';RelPperpart(1,:)';rpperpart1(2,:)';rpperpart2(2,:)';rpperpart3(2,:)';RelPperpart(2,:)';rpperpart1(3,:)';rpperpart2(3,:)';rpperpart3(3,:)';RelPperpart(3,:)';rpperpart1(4,:)';rpperpart2(4,:)';rpperpart3(4,:)';RelPperpart(4,:)';rpperpart1(5,:)';rpperpart2(5,:)';rpperpart3(5,:)';RelPperpart(5,:)'];
rptab=table(rp,lmegroup,lmecue,lmepart);
lmerp1 = fitlme(rptab,'rp~lmecue+lmegroup+(1|lmepart)+(lmecue-1|lmepart)')
lmerp2 = fitlme(rptab,'rp~lmecue*lmegroup+(1|lmepart)+(lmecue-1|lmepart)')
