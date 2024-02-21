 function [D,Trandom,Y_Dmodel] = learnDO3D_2_train_(Xmodel,X,nMap,flag,pcmptFeattr)
%  Please note that X represents the coordinates on a certain axis
%  Xmodel is the source model
%  X is the target model
%  nMap is the iteration number

fprintf('Training DO with %d maps\n',nMap)
fprintf('#data: %d \n',length(X))

Ygoal  = DataRedcell2D(X,flag); %Num_cor * Ntrain
Yinitial = DataRed(Xmodel,flag); % 1* Num_cor (fixed)
X_= X;
Ymodel = cell(1,length(X_));
if size(Yinitial,1)<size(Ygoal,1)
    a=size(Ygoal,1)-size(Yinitial,1);
    Yinitial=[Yinitial;zeros(a,1)];
end
Y = repmat(Yinitial,1,length(X));  % Num_cor * Ntrain (fixed)
clear Yinitial
% YRmodel = cell(1,length(X_));
fprintf('------------------------------------------------------------------------------------It: %d, err: %f\n',0,norm(Ygoal-Y,'fro').^2/length(X))
itMap=1;
error1=norm(Ygoal-Y,'fro').^2/length(X);
while itMap~=nMap
    %% train
    for k = 1 : length(X_)
        R1 = reshape(Y(:,k)',size(Ygoal,1)/2,2)';
        if flag==0
            Ymodel{1,k} = [R1; X_{1,k}(3,:)];% change the X-axis and Y-axis, fix the Z-axis
        elseif flag==1
            Ymodel{1,k} = [R1(1,:); X_{1,k}(2,:);R1(2,:)];
        else
            Ymodel{1,k} = [X_{1,k}(1,:);R1];
        end
        Trandom{1,itMap}(:,k) = 0.03*rand(size(Y,1),1);% generate the vector of normally distributed random numbers
        featXtr(:,k) = extFeat1D({Ymodel{1,k}},pcmptFeattr{1,k})+Trandom{1,itMap}(:,k);
        Y_Dmodel{itMap,k} = Ymodel{1,k};
    end
    featYtr = Y - Ygoal;
    D{1, itMap}= (featYtr*featXtr')/(featXtr*featXtr'+1e-4*length(X)*(eye(size(featXtr,1))));% Calculate regressors
    Y = Y - D{1, itMap}*featXtr; % Update coordinates of pseudo point cloud
    clear featXtr featYtr
    error1 = norm(Ygoal-Y,'fro')^2/length(X); % Calculate registration error
    error(itMap) = error1;
    fprintf('------------------------------------------------------------------------------------It: %d, err: %f\n',itMap,error(itMap));
    clear Ymodel
    itMap = itMap +1;
end

end



