function [pcmptFeat] = precomputeFeature_GO(Xmodel,sigmaSq,gridStep)
%PRECOMPUTEFEATURE 
%% with back or front information

% set parameters
sparseMapThreshold = 1e-6;
x = -2:gridStep:2;
[X,Y,Z] = meshgrid(x,x,x);
D = [X(:) Y(:) Z(:)]';

% Compute the grids by finding all pairwise distance between all points in
% the model and the grids. This could cause error if memory is not large
% enough. If it happens, reduce the grid size or write a loop instead.
pcmptFeat.map = exp(-pwSqDist(Xmodel,D)/sigmaSq);
pcmptFeat.minVal = -2;
pcmptFeat.size = length(x)*[1 1 1];
pcmptFeat.maxSize = pcmptFeat.size(1);
pcmptFeat.numStepPerUnit = 1/gridStep; 

% calculate normal vector
[ normals ] = findPointNormals(Xmodel',6,[0 0 0]);
% normals=pcnormals(pointCloud(Xmodel'));
dirMat = bsxfun(@gt,normals*D,sum(normals.*Xmodel',2));

clear D

% compute grid in front and in the back of normal vectors
mapTmp1 = pcmptFeat.map;
mapTmp1(dirMat) = 0;% mapTmp1 means the grid is on the front of the model point
mapTmp2 = pcmptFeat.map;
mapTmp2(~dirMat) = 0;
pcmptFeat.map = [mapTmp1;mapTmp2];

clear mapTmp1
clear mapTmp2

% set small values to zero and make the matrix sparse
if sparseMapThreshold > 0
    spPcmptFeatTmp = pcmptFeat.map;
    spPcmptFeatTmp(spPcmptFeatTmp < sparseMapThreshold) = 0;
%     pcmptFeat.map = sparse(spPcmptFeatTmp); 
    pcmptFeat.map = sparse(spPcmptFeatTmp);
end
clear spExpMapTmp


end