close all;
clear;
clc;

h = figure;
hold on;
grid on;
grid minor;

marker_size = 50;


[robots,field_size,robot_count] = read_config('random_robots.config',marker_size);

disp('Successfully read!\n');

filename = 'rnd_walk2_forblog_2.gif';

fieldx = field_size(1);
fieldy = field_size(2);

% set the range of axis on the plot
axis([1,fieldx,1,fieldy]);


%field information to check if there is a robot in that spot
% 0 no robot in that spot, 1 mean there is a robot in that spot

all_field = zeros(fieldx,fieldy);



%Initial plotting and creating handles : for each robot, we will plot it and 
%hold the handle in the struct to use it later on

for i=1:robot_count
    robots{i}.handle =  scatter(robots{i}.x,robots{i}.y,robots{i}.size,robots{i}.mark,'filled'); 
    
    all_field(robots{i}.x,robots{i}.y) = 1;     %robot occupies the position in the map
end


frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 

imwrite(imind,cm,filename,'gif','DelayTime',0.2, 'Loopcount',inf);


%when all robots stop finish the animation
num_running_robots = robot_count;
delay_interval = 0.5;                     %0.5 second delay between each move
pause(1);

while num_running_robots > 0
    
    
    % for each robot generate a random move and if that place is empty,
    % move the robot
    
    for i=1:robot_count
    
        robot = robots{i};
        
        if robot.isStopped
            continue;
        end
        
        newx = robot.x;
        newy = robot.y;
        
        rand_num = randi([1,4],1);

        if rand_num == 1
            newy = newy + 1;
        elseif rand_num == 2
            newy = newy - 1;
        elseif rand_num == 3
            newx = newx - 1;
        elseif rand_num == 4
            newx = newx + 1;
        end        
        
        
        %check if place is empty before moving
        
        if all_field(newx,newy) == 1    %occupied dont move
            continue;
        end
        
        %not occupied move
        
        all_field(robot.x,robot.y) = 0;
        all_field(newx,newy) = 1;
        
        robots{i}.x = newx;
        robots{i}.y = newy;  
        
        
        %check if robot is at the boundary
        
        if robots{i}.x == 1 || robots{i}.y == 1 || robots{i}.x == fieldx || robots{i}.y == fieldy
            robots{i}.isStopped = true;
            num_running_robots = num_running_robots - 1;
        end
        
        %draw it
        robots{i}.handle = draw_robot(robots{i}.handle,robots{i});
        
    end   
    
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 

    imwrite(imind,cm,filename,'gif','DelayTime',0.2,'WriteMode','append');
    
    pause(delay_interval);

end



function [robots,field_size,robot_count] = read_config(config,marker_size)

    fileID = fopen(config,'r');
    
    field_size = fscanf(fileID,'%d,%d\n',2)
    robot_count = fscanf(fileID, '%d\n',1);
        
    robots = {};
    
    for i=1:robot_count
        
        robot_position = fscanf(fileID,'%d,%d,',2);
        color = fscanf(fileID,'%s\n',1);
        
        robot.x = robot_position(1);
        robot.y = robot_position(2);
        robot.mark = color;
        robot.size   = marker_size;
        robot.isStopped = false;
        
        robots{i} = robot;
        
    end
    
    
    fclose(fileID);

end