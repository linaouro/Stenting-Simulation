function [stentObj] = initial_stent_from_final(arteryObj)
%TODO COMMENTS!!
%TODO then go to expansion and change
% how the stent trunctation is done etc
stentFinal = stentY_centerline(arteryObj, arteryObj.final_radii);
stent_length = [sum(stentFinal.centerline(1).seglen(1:stentFinal.endpoint(1).index)), sum(stentFinal.centerline(2).seglen(1:stentFinal.endpoint(2).index)), 4.0];
stent_params = csvread('foreshortening_chart_perc.csv');   
stent_params(stent_params == 0) = NaN;
sizes = [0.13,0.13,0.26];
stentInitial = stentY_centerline(arteryObj, sizes);
stentObj = [Stent(),Stent(),Stent()];
for i = 1:3 
    % percentage of foreshortening for the different stent types at
    % expansion radius r = final radius
    scale = interp1(stent_params(3:end,1), stent_params(3:end,2:end), arteryObj.final_radii(i),'linear','extrap');
    % the stent with the smallest length difference after expansion to
    % radius r
    [~,idx] = min(abs(scale.*stent_params(2,2:end)-stent_length(i)));
    initial_length_idx = min(stentInitial.centerline(i).len, find(cumsum(stentInitial.centerline(i).seglen)>stent_params(2,idx+1),1), 'omitnan');
    stentObj(i) = Stent([stent_params(:,1),stent_params(:,idx+1)], stentInitial.centerline(i), ones(1,initial_length_idx)*sizes(i), initial_length_idx);%, scale(idx)*stent_params(2,idx+1)/sum(arteryObj.centerline(i).seglen(arteryObj.opening(i).index:end)));
end