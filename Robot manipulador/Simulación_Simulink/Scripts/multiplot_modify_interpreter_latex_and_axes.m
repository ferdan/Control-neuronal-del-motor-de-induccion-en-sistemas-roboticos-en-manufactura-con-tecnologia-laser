for i = 1:3
    for j = 1:3
        subplot(3,3,(i-1)*3+j)
        set(gca,'xminorgrid','on','yminorgrid','on','TickLabelInterpreter','latex')
        xticks([20,40,60])
    end
end
