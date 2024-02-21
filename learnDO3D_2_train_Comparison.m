function [D,Y_Dmodel] = learnDO3D_2_train_Comparison(Xmodel,X,flag,pcmptFeattr)
    fprintf('#data: %d \n',length(X))
    %% Project the 3D model to a certain view
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
    fprintf('------------------------------------------------------------------------------------It: %d, err: %f\n',0,norm(Ygoal-Y,'fro').^2/length(X))
    itMap=1; % Iteration Number
    error1=norm(Ygoal-Y,'fro').^2/length(X);
    while error1> 0.001
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Estimation Step
        %% Generate the pseudo point cloud: Ymodel
               k = 1;
               R1 = reshape(Y(:,k)',size(Ygoal,1)/2,2)';
                if flag==0
                    Ymodel = [R1; X_{1,k}(3,:)];% change the X-axis and Y-axis, fix the Z-axis
                elseif flag==1
                    Ymodel = [R1(1,:); X_{1,k}(2,:);R1(2,:)]; 
                else
                    Ymodel = [X_{1,k}(1,:);R1];  
                end
         %% Extract the feature of pseudo point cloud
            featXtr = extFeat1D({Ymodel},pcmptFeattr{1,k})+0.03*rand(size(Y,1),1); 
            Y_Dmodel{itMap,k} = Ymodel;
         %% Pseudo point cloud estimation
            featYtr = Y - Ygoal;  % fixed-train

         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Updating Step
         %% Calculate regressors
            D = (featYtr*featXtr')/(featXtr*featXtr'+1e-4*length(X)*(eye(size(featXtr,1))));% Discriminative Optimization 
         %% Coordinates updating  
            Y = Y - D*featXtr; % The coordinates transformation on fixed data
            error1 =norm(Ygoal-Y,'fro')^2/length(X);
            fprintf('------------------------------------------------------------------------------------It: %d, err: %f\n',itMap,error1);
            itMap = itMap +1;
            R1 = reshape(Y(:,k)',size(Ygoal,1)/2,2)';
            if flag==0
                Ymodel = [R1; X_{1,k}(3,:)];% change the X-axis and Y-axis, fix the Z-axis
            elseif flag==1
                Ymodel = [R1(1,:); X_{1,k}(2,:);R1(2,:)]; 
            else
                Ymodel = [X_{1,k}(1,:);R1];  
            end
             Y_Dmodel{itMap,k} = Ymodel;
    end
    % time_=toc;
end