function [ coords, tangents ] = read_path( filename )
%READ_PATH Summary of this function goes here
%   Detailed explanation goes here

fid=fopen(filename, 'r'); %Open the file, assumes STL ASCII format.
if fid == -1 
    error('File could not be opened, check name or path.')
end


for i=1:3
    tline = fgetl(fid); 
end
fword = sscanf(tline, '%s ');
n_points = sscanf(fword, '<path id="%*f" method="%*f" calculation_number="%f%*s',1);


i = 1;
coords = zeros(n_points,3);
tangents = zeros(n_points,3);
while feof(fid) == 0                    % test for end of file
    tline = fgetl(fid);                 % reads a line of data from file.
    fword = sscanf(tline, '%s ');       % make the line a character string
    
    if ~isempty(strfind(fword, 'pos'))    % Checking if line includes "pos"
       coords(i,:) = sscanf(fword, '<pos x="%f" y="%f" z="%f%*s',3); % get coordinates
       fword = sscanf(fgetl(fid),'%s'); % next line
       tangents(i,:) = sscanf(fword, '<tangent x="%f" y="%f" z="%f%*s',3); % get tangent
       i=i+1;
    end  
    
end

end

