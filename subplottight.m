function h = subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    ax = subplot('Position', [(c-1)/m, 1-(r)/(n*1.02), 1/m, 0.80/n ]);
    if(nargout > 0)
      h = ax;
    end
end