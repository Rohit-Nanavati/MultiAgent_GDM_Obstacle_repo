function [mean_out,var_out,Hp]=GMRF_sparse(mean,occ,lambda,obs,t)
tic
[y_len,x_len]=size(mean);
N=x_len*y_len;
mean_vec=reshape(mean',1,x_len*y_len);
for i=2:length(obs) % loop for converting from x,y to vector index          %% why?
    obs(i).pos=(obs(i).pos(2)-1)*x_len+obs(i).pos(1);
end
%----------------Set the prior factor values for observations and cells
sigma_t=1/lambda.t;
sigma_o=1./[obs.lambda];
lambda_o=1./(sigma_o+(sigma_t*(t-[obs.time])));              %% Are the sigma the variance or standard deviations?
g=zeros(1,N); %initialise gradient vector
lambda_p = (lambda.p);

%% Jacobian
Hs=sparse(N,N); %initialise Jacobain under assumption all cells connected

%------------------L portion----------------------------
%Cycles through the occ and checks which cells are connected to which
%others, checks cells right,left,up, and down, once a connection is found
%adds the connection to the Hessian
for i=1:y_len
    for j=1:x_len

            idx=(i-1)*x_len+j; %convert from matrix to vector index
            Hs(idx,idx) = Hs(idx,idx) + lambda_o(1); %add default lambda_d
            if occ(i,j) ~= 0 %if itself is not an obstacle
                if not(i+1>y_len) %if 1 step up is not out of bounds
                    if occ(i+1,j) ~=0 %if 1 step up is not an obstacle
                        Hs(idx,idx)=Hs(idx,idx)+lambda_p; % increase self potential
                        Hs(idx,idx+x_len)=-lambda_p; % increase edge potential
                    end
                end
                if not(i-1<=0) 
                    if occ(i-1,j) ~=0 %if 1 step down is not an obstacle
                        Hs(idx,idx)=Hs(idx,idx)+lambda_p;
                        Hs(idx,idx-x_len)=-lambda_p;
                    end
                end
                if not(j+1>x_len)
                    if occ(i,j+1) ~=0 %if 1 step right is not an obstacle
                        Hs(idx,idx)=Hs(idx,idx)+lambda_p;
                        Hs(idx,idx+1)=-lambda_p;
                    end
                end
                if not(j-1<=0)
                    if occ(i,j-1) ~=0 %if 1 step left is not an obstacle
                        Hs(idx,idx)=Hs(idx,idx)+lambda_p;
                        Hs(idx,idx-1)=-lambda_p;
                    end
                end
            end
    end
end
Hp=Hs; % stores occ factor graph for later use
%------------------M portion----------------------------
% cycles through observations and appends them to the Hessian
for i=2:length(obs) % add all the observations (remember (1) is the default) 
    idx=obs(i).pos;
    pVal=Hs(idx,idx);
    Hs(idx,idx)=pVal+lambda_o(i);
end

%% gradient vector
% Cycles through cells calculating gradient vector
obstmp=[obs.pos]; % convert from struct to vector
for i=1:y_len
    for j=1:x_len
        if occ(i,j)~=0 %if cell isn't an obstacle
            g_prior= lambda_o(1).* (mean(i,j)-[obs(1).conc]); %initialise with default value
            %observation portion of the gradient vector
            obsId=find(obstmp==(i-1)*x_len+j); % find if any obs match the current cell
            if ~isempty(obsId) % if there is an obs, add to gradient vector
                g_prior=g_prior+sum(lambda_o(obsId).*(mean(i,j)-[obs(obsId).conc]));
            end

            %prior connection portion of the gradient vector
            if not(i+1>y_len) %if 1 step right is not out of bounds
                if occ(i+1,j) ~=0 %if 1 step right is not an obstacle
                    g_prior=g_prior+lambda_p*(mean(i,j)-mean(i+1,j));
                end
            end
            if not(i-1<=0)
                if occ(i-1,j) ~=0
                    g_prior=g_prior+lambda_p*(mean(i,j)-mean(i-1,j));
                end
            end
            if not(j+1>x_len)
                if occ(i,j+1) ~=0
                    g_prior=g_prior+lambda_p*(mean(i,j)-mean(i,j+1));
                end
            end
            if not(j-1<=0)
                if occ(i,j-1) ~=0
                    g_prior=g_prior+lambda_p*(mean(i,j)-mean(i,j-1));
                end
            end

            g((i-1)*x_len+j)=g_prior; %assign gradient to g vector

        end
    end
end

%% Currently using Matlab solver but can use Cholesky decomp, LDL or whatever
% HsI=inv(Hs); % inverse the Hessian
HsI = sparseinv(Hs);
%[R]=chol(Hs);

% H=p'*Hs*p;
% H=R'*R;
%[L,D,P]=ldl(Hs);
% if flag~=0
%     true
% end

delta_m=Hs\(g');
%delta_m=R\(R'\(g'));
%delta_m=P*(L'\(D\(L\((P'*(-g'))))));


mean_new=mean_vec-delta_m'; % solves for delta mean therefore subtract from prior

mean_out=vec2mat(mean_new,x_len); % converts back to matrix from vector

%% Variance
%Invert Hessian to calculate uncertainty
K=full(diag(HsI)); % take diagonals for variance

var_out=vec2mat(K,x_len);
var_out(occ==0)=0;

toc
end
