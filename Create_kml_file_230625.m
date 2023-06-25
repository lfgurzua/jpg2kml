% Created by FGU on 25/06/23
% Modified by XXX on XX/XX/XX
% This script reads the jpg files in the folder and writes a kml file for
% google earth to geolocate the pictures on the globe

clear
clc

%% Create empty table
% Create an empty table
data = table();

% Define column types
data.name = cell(0, 1);
data.lat = double.empty(0, 1);
data.lon = double.empty(0, 1);

%% Read pictures and populate table

All_pictures = dir('*.jpg'); % Reads all jpg pictures in folder
for k = 1:length(All_pictures) % Create data frame with relevant data
    % Assign the file name to the table
    data.name{k} = All_pictures(k).name;
    % Extract lat-lon info
    clear temp % Clear any previous temp variable
    temp = imfinfo(All_pictures(k).name); % Extract metadata
    try
        lat = temp.GPSInfo.GPSLatitude; % Assign latitude to temporary variable
        data.lat(k) = lat(1)+lat(2)/60+lat(3)/3600; % Convert to decimal and assign
        lon = temp.GPSInfo.GPSLongitude; % Assign latitude to temporary variable
        data.lon(k) = lon(1)+lon(2)/60+lon(3)/3600; % Convert to decimal and assign     
    catch % If no lat-lon information available, assign 0
        data.lat(k) = 0;
        data.lon(k) = 0;
    end
    disp(['Picture ',num2str(k),' out of ',num2str(length(All_pictures))])
end

%% Write the kml file

has_gps = 1:length(All_pictures);
has_gps = has_gps(~(data.lat == 0))'; % Include only pictures with GPS data
fid = fopen(['Mapped_pictures_',num2str(yyyymmdd(datetime('now'))),num2str(hour(datetime('now'))),num2str(minute(datetime('now'))),'.kml'], 'w' ); % 
    % Text at the beginning of kml file
    fprintf(fid,'% s\n',"<?xml version=""1.0"" encoding=""UTF-8""?>");
    fprintf(fid,'% s\n',"<kml xmlns=""http://www.opengis.net/kml/2.2"">");
    fprintf(fid,'% s\n',"  <Document>");
    fprintf(fid,'% s\n',"    <name>Fotos importadas</name>");
    fprintf(fid,'% s\n',"    <Style id=""icon-1899-DB4436-normal"">");
    fprintf(fid,'% s\n',"      <IconStyle>");
    fprintf(fid,'% s\n',"        <color>ff3644db</color>");
    fprintf(fid,'% s\n',"        <scale>1</scale>");
    fprintf(fid,'% s\n',"        <Icon>");
    fprintf(fid,'% s\n',"          <href>https://www.gstatic.com/mapspro/images/stock/503-wht-blank_maps.png</href>");
    fprintf(fid,'% s\n',"        </Icon>");
    fprintf(fid,'% s\n',"        <hotSpot x=""32"" xunits=""pixels"" y=""64"" yunits=""insetPixels""/>");
    fprintf(fid,'% s\n',"      </IconStyle>");
    fprintf(fid,'% s\n',"      <LabelStyle>");
    fprintf(fid,'% s\n',"        <scale>0</scale>");
    fprintf(fid,'% s\n',"      </LabelStyle>");
    fprintf(fid,'% s\n',"    </Style>");
    fprintf(fid,'% s\n',"    <Style id=""icon-1899-DB4436-highlight"">");
    fprintf(fid,'% s\n',"      <IconStyle>");
    fprintf(fid,'% s\n',"        <color>ff3644db</color>");
    fprintf(fid,'% s\n',"        <scale>1</scale>");
    fprintf(fid,'% s\n',"        <Icon>");
    fprintf(fid,'% s\n',"          <href>https://www.gstatic.com/mapspro/images/stock/503-wht-blank_maps.png</href>");
    fprintf(fid,'% s\n',"        </Icon>");
    fprintf(fid,'% s\n',"        <hotSpot x=""32"" xunits=""pixels"" y=""64"" yunits=""insetPixels""/>");
    fprintf(fid,'% s\n',"      </IconStyle>");
    fprintf(fid,'% s\n',"      <LabelStyle>");
    fprintf(fid,'% s\n',"        <scale>1</scale>");
    fprintf(fid,'% s\n',"      </LabelStyle>");
    fprintf(fid,'% s\n',"    </Style>");
    fprintf(fid,'% s\n',"    <StyleMap id=""icon-1899-DB4436"">");
    fprintf(fid,'% s\n',"      <Pair>");
    fprintf(fid,'% s\n',"        <key>normal</key>");
    fprintf(fid,'% s\n',"        <styleUrl>#icon-1899-DB4436-normal</styleUrl>");
    fprintf(fid,'% s\n',"      </Pair>");
    fprintf(fid,'% s\n',"      <Pair>");
    fprintf(fid,'% s\n',"        <key>highlight</key>");
    fprintf(fid,'% s\n',"        <styleUrl>#icon-1899-DB4436-highlight</styleUrl>");
    fprintf(fid,'% s\n',"      </Pair>");
    fprintf(fid,'% s\n',"    </StyleMap>");

    % Text to represent pictures
    for k = 1:length(has_gps)
        pic = has_gps(k);
        fprintf(fid,'% s\n', '    <Placemark>');
        fprintf(fid,'% s\n',['      <name>',data.name{pic},'</name>']);
        fprintf(fid,'% s\n',['      <description><![CDATA[<img src="',data.name{pic},'" height="600" width="auto" /><br><br>]]></description>']);
        fprintf(fid,'% s\n', '      <styleUrl>#icon-1899-DB4436</styleUrl>');
        fprintf(fid,'% s\n', '      <ExtendedData>');
        fprintf(fid,'% s\n', '        <Data name="gx_media_links">');
        fprintf(fid,'% s\n',['          <value><![CDATA[',data.name{pic},']]></value>']);
        fprintf(fid,'% s\n', '        </Data>');
        fprintf(fid,'% s\n', '      </ExtendedData>');
        fprintf(fid,'% s\n', '      <Point>');
        fprintf(fid,'% s\n', '        <coordinates>');
        fprintf(fid,'% s\n',['          ',num2str(data.lon(pic)),',',num2str(data.lat(pic)),',0']);
        fprintf(fid,'% s\n', '        </coordinates>');
        fprintf(fid,'% s\n', '      </Point>');
        fprintf(fid,'% s\n', '    </Placemark>');

    end
    
    % Text at the end of file
    fprintf(fid,'% s\n',"  </Document>");
    fprintf(fid,'% s\n',"</kml>");

fclose(fid);


























