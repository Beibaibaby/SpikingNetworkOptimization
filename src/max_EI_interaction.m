function [x_hat,y_hat] = max_EI_interaction(gp_object,gp_object_feas,f_plus,epsilon,n_sample,x_range,n_local)

ndim=size(x_range,1);
x_samples=rand(n_sample,ndim).*repmat((x_range(:,2)-x_range(:,1))', n_sample,1)+ repmat(x_range(:,1)', n_sample,1);


%[miu_x,sigma_x]= predict(gp_object,cat(2,x_samples(:,:),x_samples(:,1)./x_samples(:,2),x_samples(:,3)./x_samples(:,4),x_samples(:,6).*x_samples(:,7)));
%[mu_feas,std_feas]= predict(gp_object_feas,cat(2,x_samples(:,:),x_samples(:,1)./x_samples(:,2),x_samples(:,3)./x_samples(:,4),x_samples(:,6).*x_samples(:,7)));
[miu_x,sigma_x]= predict(gp_object,cat(2,x_samples(:,:),x_samples(:,3)./x_samples(:,4),x_samples(:,6).*x_samples(:,7)-x_samples(:,8).*x_samples(:,9)));
[mu_feas,std_feas]= predict(gp_object_feas,cat(2,x_samples(:,:),x_samples(:,3)./x_samples(:,4),x_samples(:,6).*x_samples(:,7)-x_samples(:,8).*x_samples(:,9)));


prob_feas = normcdf((mu_feas-.5)./std_feas);

Z=(f_plus-epsilon-miu_x)./sigma_x;
y_samples=prob_feas.*((f_plus-epsilon-miu_x).*normcdf(Z)+sigma_x.*normpdf(Z));

func=@(x)EI_interaction(x,gp_object,gp_object_feas,f_plus,epsilon)*(-1);
[max_vals, max_inds] = maxk(y_samples,n_local);
x_locals=x_samples(max_inds,:);


x_hats=zeros(length(max_inds),ndim);
local_optima=zeros(length(max_inds),1);

for i=1:length(max_inds)
    [x_hats(i,:), local_optima(i)]=fminsearchbnd(func,x_locals(i,:),x_range(:,1)',x_range(:,2)',optimset(...
                                                                                                'MaxIter', 10, ...
                                                                                                'TolX', Inf, ...
                                                                                                'TolFun', 1e-3,...
                                                                                                'Display','none'));
end 
[I,J]= max(-local_optima);
x_hat=x_hats(J,:);
y_hat=I;



