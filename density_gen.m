function density = density_gen(mean,var,beta)
    mean_min = min(mean,[],'all'); 
    mean_max = max(mean,[],'all'); 
    var_min = min(var,[],'all'); 
    var_max = max(var,[],'all');
    
    mean_norm = (mean-mean_min)./(mean_max - mean_min);
    var_norm = (var-var_min)./(var_max - var_min);
    
    density = mean_norm + beta*var_norm;
end