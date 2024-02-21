function [Xori] =DataRedcell2D(X,flag)
    % project the taget model to the side, front and top views
    if size(X,1)~=1
        for i=1:length(X)
            if flag==0
                 Xori(:,i) =[X{i,1}(1,:),X{i,1}(2,:)]';
            elseif flag==1
                 Xori(:,i) =[X{i,1}(1,:),X{i,1}(3,:)]';
            else
                 Xori(:,i)=[X{i,1}(2,:),X{i,1}(3,:)]';
            end
        end
    else
         for i=1:length(X)
            if flag==0
                 Xori(:,i) =[X{1,i}(1,:),X{1,i}(2,:)]';
            elseif flag==1
                 Xori(:,i) =[X{1,i}(1,:),X{1,i}(3,:)]';
            else
                 Xori(:,i)=[X{1,i}(2,:),X{1,i}(3,:)]';
            end
        end
    end

end
