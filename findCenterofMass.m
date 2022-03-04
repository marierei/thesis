% Funksjon for å finne tyngdepunkt
function centerofMass = findCenterofMass(T)

topMiddle = (T(9,:) + T(10,:) + T(11,:) + T(12,:))/4;
midMiddle = (T(5,:) + T(6,:) + T(7,:) + T(8,:))/4;
bottomMiddle = (T(1,:) + T(2,:) + T(3,:) + T(4,:))/4;

lower_lim = bottomMiddle(3) + (topMiddle(3) - bottomMiddle(3))/2;

% Difference of placement of topMiddle and midMiddle in the xy-plane
diff = abs(topMiddle(1) - midMiddle(1)) + abs(topMiddle(2) - midMiddle(2));

if midMiddle(3) >= lower_lim & midMiddle(3) <= topMiddle(3)
    centerofMass = diff;
elseif midMiddle(3) < lower_lim & midMiddle(3) > bottomMiddle(3)
    factor = 1 + abs(lower_lim - midMiddle(3));
    centerofMass = diff * factor^factor;
% Gives a very large value if the center of mass is below the bottom layer
% or above the top layer
elseif midMiddle(3) < bottomMiddle(3) | midMiddle(3) > topMiddle(3)
    centerofMass = 10^21;
else
    centerofMass = 10^21;
end