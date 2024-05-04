function [percentshared, d_shared,normevals] = compute_shared(estParams, thresh, normalize)
%% Extract the three population statistics from the estimated FA params
       
       
L = estParams.L;
Ph = estParams.Ph;
     
%% Compute d_shared
if ~isempty(L)
    shared = L*L';
    evals = eig(shared);
    if normalize
        normevals = sort(evals,'descend')/sum(evals);
    else 
        normevals = sort(evals,'descend');
    end
    d_shared = sum(cumsum(normevals/sum(normevals))<thresh)+1;
else
    d_shared = 0;
    percentshared = 0;
end

%% Compute % shared variance
        if ~isempty(L) && ~isempty(Ph)
            sharedvar = diag(L*L');
            percentshared = mean(sharedvar./(sharedvar+Ph));
        else
            percentshared = 0;
        end
end