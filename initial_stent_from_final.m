function [stentObj, stent_radii] = initial_stent_from_final(arteryObj)


% initial radius is radius of trunk
stent_idx(3) = min(arteryObj.centerline(1).len,find(cumsum(arteryObj.centerline(1).seglen)>4,1), 'omitnan');
stent_idx(2) = round(0.8*(arteryObj.centerline(2).len-arteryObj.opening(2).index))+arteryObj.opening(2).index; %left
stent_idx(1) = round(2/3*(arteryObj.centerline(1).len-arteryObj.opening(1).index))+arteryObj.opening(1).index;
stent_radii = [1.1*max(arteryObj.radii_avg(arteryObj.opening(1).index:stent_idx(1),1)), 1.1*max(arteryObj.radii_avg(arteryObj.opening(2).index:stent_idx(2),2)), min(1.3, 1.0*max(arteryObj.radii_avg(:,3)))];
stent_length = [2/3*arteryObj.centerline(1).length, 0.8*arteryObj.centerline(2).length, 4.0];
stent_params = csvread('foreshortening_chart_perc.csv');   
arteryObj = update_centerline(arteryObj, stent_radii);
stent_params(stent_params == 0) = NaN;
sizes = [0.1,0.1,0.2];
for i = 1:3 
    scale = interp1(stent_params(3:end,1), stent_params(3:end,2:end), stent_radii(i),'linear','extrap');% initial radius * 2 /2 -> params are lumen
    [~,idx] = min(abs(scale.*stent_params(2,2:end)-stent_length(i)));
    initial_length_idx = min(arteryObj.centerline(i).len, round((2-scale(idx))*stent_idx(i)));
    stentObj(i) = Stent([stent_params(:,1),stent_params(:,idx+1)], arteryObj.centerline(i), ones(1,initial_length_idx)*sizes(i), initial_length_idx, scale(idx)*stent_params(2,idx+1)/arteryObj.centerline(i).length);
end