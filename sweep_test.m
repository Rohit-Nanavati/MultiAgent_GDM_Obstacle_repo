clc;
close all;
clear;

NoA = 5;
x = 0.05:0.12:5.95;
y = 0.05:0.1:5.95;

[X,Y] = meshgrid(x,y);
Y(:,1:2:length(x)) = flipud(Y(:,1:2:length(x)));

% Xm = reshape(X',[],1);
% Ym = reshape(Y',[],1);

Xm = reshape(X,numel(X)/NoA,[]);
Ym = reshape(Y,numel(X)/NoA,[]);

% figure(1); hold on;
% for row = 1:10
%     plot((X(row,:)),(Y(row,:)),'-');
%     plot((X(row,1)),(Y(row,1)),'o');
%     plot((X(row,end)),(Y(row,end)),'s');
% end
% axis([0 6 0 6]);

figure(2); hold on;
for noa = 1:NoA
    plot(Xm(:,noa),Ym(:,noa),'-');
    plot(Xm(1,noa),Ym(1,noa),'o');
end
axis([0 6 0 6]);

% Randagntpos = zeros(5,2,10);
% for runno = 1:10
%     Randagntpos(:,:,runno) = randi([1,119],5,2);
% end
% save('randpos.mat','Randagntpos');