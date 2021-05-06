funksjon gold = goldenRatio(vann, lodd)

% Can I do function inside of function?? YES!
% Single out the ones needed Egen funksjon for dette og så sette det inn i
% denne som vannrette og loddrette elementer som sammenlignes
% Need a ratio of vann/lodd el. lodd/vann to compare it to the golden ratio.
global gR;
golden = 0;


for i = 1 : size(vann)
    for j = 1 : size(lodd)
        comp1 = vann(i)/lodd(j);
        comp2 = lodd(j)/vann(i);
        comp = min(comp1, comp2);
        vekt = abs(gR - comp);
        golden = golden + vekt;
    end
end

% Add together the golden ratios
% Will have 4 for each level = 8 values
gold = 3;