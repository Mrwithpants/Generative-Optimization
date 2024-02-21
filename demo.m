clc;clear;
load('demo_data.mat')
transformed_pc=cell(length(source_mat),1);
for i=1:length(source_mat)
    %% Normalization
    modelSmp = source_mat{i,1}';
    modelSmp = bsxfun(@minus,modelSmp,min(modelSmp,[],2));
    modelSmp = bsxfun(@minus,modelSmp,max(modelSmp,[],2)/2);
    modelSmp = modelSmp / max(abs(modelSmp(:)));
    modelSmp_c = target_mat{i,1}';
    modelSmp_c = bsxfun(@minus,modelSmp_c,min(modelSmp_c,[],2));
    modelSmp_c = bsxfun(@minus,modelSmp_c,max(modelSmp_c,[],2)/2);
    modelSmp_c = modelSmp_c / max(abs(modelSmp_c(:)));
    %% 
    sigmaSq = 0.3; 
    nMap=10;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    gridStep=0.5;
    Xtrain={modelSmp_c};
    pcmptFeattr = cell(1,length(Xtrain));
    for k=1: length(Xtrain)
        pcmptFeattr{1,k} = precomputeFeature_GO(Xtrain{1,k},sigmaSq,gridStep);
    end
    maxIter = 1000;
    stopThres = 0.001;
    [D1,YRMODEL_X] =learnDO3D_2_train_Comparison(modelSmp,Xtrain,0,pcmptFeattr);% without Z/learn Z
    [D2,YRMODEL_Y] =learnDO3D_2_train_Comparison(modelSmp,Xtrain,1,pcmptFeattr);% without Y/learn Y
    [D3,YRMODEL_Z] =learnDO3D_2_train_Comparison(modelSmp,Xtrain,2,pcmptFeattr);% without X/learn X
    clear D1 D2 D3 
    YRMODEL_F(1,:)=(YRMODEL_X{end,1}(1,:)+YRMODEL_Y{end,1}(1,:))/2;
    YRMODEL_F(2,:)=(YRMODEL_X{end,1}(2,:)+YRMODEL_Z{end,1}(2,:))/2;
    YRMODEL_F(3,:)=(YRMODEL_Z{end,1}(3,:)+YRMODEL_Y{end,1}(3,:))/2;
    transformed_pc{i,1}=YRMODEL_F';
end