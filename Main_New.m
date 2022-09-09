%% Initialisation
close all
clear variables
set(0,'defaultAxesFontSize',16);
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');

%
% writerObj = VideoWriter('CC_5agnt.avi','Motion JPEG AVI');
% writerObj.FrameRate = 1/1.5;
% writerObj.Quality = 95;
% open(writerObj);

%%Ground truth measurements
data = importdata('GT_data2.mat');
GT_conc = extractfield(data, 'GT_conc');
pts = find(GT_conc==0);
GT_conc(pts) = min(GT_conc(GT_conc>0),[],'all');
GT = reshape(GT_conc,[116 116]);
GT(:,11:110) = GT(:,1:100);
GT(:,1:10) = min(GT_conc(GT_conc>0),[],'all');
GT = [GT zeros(116,3)];
GT = [zeros(3,119); GT];
res = 0.05;
% GT(GT<=1e-1) = NaN;
GMRF_VISUALISE(GT,1,res); hold on;

[ylen, xlen] = size(GT);
mean_prior = zeros([ylen xlen]); %min(GT_conc(GT_conc>0),[],'all')*ones([ylen xlen]);
occ = ones(ylen,xlen);
t_sam = 5;
dt = 1;
inst = 1;


%% sweep trajectory
% xsweep = 0:0.1:5.95;
% ysweep = 0.0:0.1:5.95;
% xsweep = xsweep/0.05;
% ysweep = ysweep/0.05;
% 
% [Xsweep,Ysweep] = meshgrid(xsweep,ysweep);
% Xsweep(1:2:length(ysweep),:) = fliplr(Xsweep(1:2:length(ysweep),:));
% Xmsweep = reshape(Xsweep',numel(Xsweep)/5,[]);
% Ymsweep = reshape(Ysweep',numel(Xsweep)/5,[]);

xsweep = 0.05:0.12:5.95;
ysweep = 0.05:0.1:5.95;
xsweep = xsweep/0.05;
ysweep = ysweep/0.05;

[Xsweep,Ysweep] = meshgrid(xsweep,ysweep);
Ysweep(:,1:2:length(xsweep)) = flipud(Ysweep(:,1:2:length(xsweep)));
Xmsweep = reshape(Xsweep,numel(Xsweep)/5,[]);
Ymsweep = reshape(Ysweep,numel(Xsweep)/5,[]);



%%
InpDom = [1 1; 1 ylen; xlen ylen; xlen 1]; % external boundary
x = min(InpDom(:,1)):1:max(InpDom(:,1));
y = min(InpDom(:,2)):1:max(InpDom(:,2));
[Xm,Ym] = meshgrid(x,y);
X = Xm(:); Y = Ym(:);
% figure(1); plot3(X*0.05,Y*0.05,100*ones(size(X)),'r.');

%Initialise map with default observation of zero mean where not visited
obs.pos=[0]; % pos is set to [0], this concentration value is set across all nodes as default value
obs.conc = 0; % can change to whatever background concentration is
obs.lambda = 1e-3; %lambda_d
obs.time=0;

%Initilialize Agent locations
Agnt_pos = [5.75,5;
    5.5,4;
    4.75,5.5;
    4.25,4.75;
    5,4.25]/0.05;
% Agnt_pos = [5.75,5;
%     5.5,4]/0.05;
% Agnt_pos = [Xmsweep(inst,1)+2 Ymsweep(inst,1);
%     Xmsweep(inst,2)+2 Ymsweep(inst,2);
%     Xmsweep(inst,3)+2 Ymsweep(inst,3);
%     Xmsweep(inst,4)+2 Ymsweep(inst,4);
%     Xmsweep(inst,5)+2 Ymsweep(inst,5)];
% Agnt_pos = [Xmsweep(inst,1) Ymsweep(inst,1);
%             Xmsweep(inst,2) Ymsweep(inst,2);
%             Xmsweep(inst,3) Ymsweep(inst,3);
%             Xmsweep(inst,4) Ymsweep(inst,4);
%             Xmsweep(inst,5) Ymsweep(inst,5)];
robotspeed = 2;
% NoA = 4;
% Agnt_pos = unifrnd(4/0.05,5/0.05,[NoA,2]);
NoA  = length(Agnt_pos(:,1)); % no. of Agents
APos_vec = zeros(NoA,2,1000);
rmse_vec = zeros(1,1000);
var_vec = zeros(1,1000);
APos_vec(:,:,1) = Agnt_pos;

%Create first observation (need at least 1 observation)
t_now=0; % current time
for noa = 1:NoA
    nGP_ind = dsearchn([X Y],[Agnt_pos(noa,1), Agnt_pos(noa,2)]);
    obs(end+1).pos=[X(nGP_ind),Y(nGP_ind)]; %new obs at pose x=50, y=50
    obs(end).conc = (1 + 0.02)*GT(obs(end).pos(2), obs(end).pos(1));
    obs(end).lambda=1e1; %observation lambda value for this obs
    obs(end).time=0; %time reading was taken at
end

%-----------------------------------------------------------------------
% For the first time the factor graph based on occ needs to be created
% (H_p), this can then be input in subsequent iterations to save time
lambda.p = 1; % set prior factor precision
lambda.t = 1e6; % set time factor precision (lower = trust measurements less over time)
[mean_posterior, var_posterior, Hp]=GMRF_sparse(mean_prior, occ, lambda, obs, t_now);
rmse_vec(1) = sqrt(sum((GT-mean_posterior).^2,'all')/numel(GT));
var_vec(1) = sum(var_posterior,'all');
tup_counter = 2;

beta_nom = 2; dlam = 0.01;
beta = beta_nom*(1 - exp(-dlam*t_now));
density = density_gen(mean_posterior,var_posterior,beta);
GMRF_VISUALISE(mean_posterior,2,res) % Visualises the mean map on fig 2
GMRF_VISUALISE(var_posterior,3,res) % Visualises the var map on fig 3
GMRF_VISUALISE(density,4,res) % Visualises the var map on fig 3
t_now
% Frame = getframe(4);
% writeVideo(writerObj, Frame);


while t_now<600
    
    %     density = density_gen(mean_posterior,var_posterior,beta);
    
    for t_curr = 1:t_sam/dt
                VSet = partition_generation(Agnt_pos(:,1),Agnt_pos(:,2),X,Y,InpDom,NoA);
        %centroid based coverage control
%                 Centroid_control;
        %inverted plume control
                Inverted_plume_control;
        %sweep
%         sweep_traj;
        %levy
        %         levy_flight;
        %% updating observation vector by appending new value (must keep old samples in obs)
        for noa = 1:NoA
            obsNew=length(obs)+1;
            nGP_ind = dsearchn([X Y],[Agnt_pos(noa,1), Agnt_pos(noa,2)]);
            obs(obsNew).pos = [X(nGP_ind),Y(nGP_ind)]; %random new sensor location
            obs(obsNew).conc = (1 + 0.02)*GT(obs(obsNew).pos(2), obs(obsNew).pos(1));
            %obs(obsNew).conc=rand;
            obs(obsNew).lambda=1e1;
            obs(obsNew).time=t_now;
            obs(obsNew).time=t_now + t_curr*dt; % default factors must be set to current time
        end
    end
    %% Update observation part of the factor graph then recalculate GMRF
    [mean_posterior,var_posterior]=GMRF_sparse_obs(mean_prior,occ,lambda,obs,Hp,t_now);
    
    %% Step forward time and visualise
    t_now = t_now+t_sam;
    beta = beta_nom*(1 - exp(-dlam*t_now));
    density = density_gen(mean_posterior,var_posterior,beta);
    
    rmse_vec(tup_counter) = sqrt(sum((GT(GT>=1e-1)-mean_posterior(GT>=1e-1)).^2,'all')/numel(GT(GT>=1e-1)));
    var_vec(tup_counter) = sum(var_posterior,'all');
    tup_counter = tup_counter+1;
    
    GMRF_VISUALISE(mean_posterior,2,res)
    GMRF_VISUALISE(var_posterior,3,res)
    GMRF_VISUALISE(density,4,res)
    fprintf('t_now = %f\n',t_now);
    %     figure(4); hold on;
    %     for ii = 1:NoA
    %         plot(squeeze(APos_vec(ii,1,inst-5:inst))*0.05,squeeze(APos_vec(ii,2,inst-5:inst))*0.05,'--','Markersize',8)
    %         plot(squeeze(APos_vec(ii,1,inst))*0.05,squeeze(APos_vec(ii,2,inst))*0.05,'s','Markersize',8)
    %     end
    %     Frame = getframe(4);
    %     writeVideo(writerObj, Frame);
    %     figure(4); hold off;
end

figure(4); hold on;
for ii = 1:NoA
    plot(squeeze(APos_vec(ii,1,1:inst))*0.05,squeeze(APos_vec(ii,2,1:inst))*0.05,'--','Markersize',8)
    plot(squeeze(APos_vec(ii,1,inst))*0.05,squeeze(APos_vec(ii,2,inst))*0.05,'s','Markersize',8)
    plot(squeeze(APos_vec(ii,1,1))*0.05,squeeze(APos_vec(ii,2,1))*0.05,'o','Markersize',8)
end

% VoronoiLimit(squeeze(APos_vec(:,1,inst))*0.05,squeeze(APos_vec(:,2,inst))*0.05,'bs_ext',InpDom*0.05,'figure','on');

% save(['Dataset/Workspace_IPCC_5agnt_TD_1e6_repeat']);
% close(writerObj);