function [Xori] =DataRed(X,flag)
    % Project the source model to the side, front and top views
    if size(X,1)==3
            if flag==0
                 Xori=[X(1,:),X(2,:)]';
            elseif flag==1
                 Xori =[X(1,:),X(3,:)]';
            else
                 Xori=[X(2,:),X(3,:)]';
            end

    else
            if flag==0
                 Xori =[X(:,1),X(:,2)]';
            elseif flag==1
                 Xori =[X(:,1),X(:,3)]';
            else
                 Xori=[X(:,2),X(:,3)]';
            end
    end
end
