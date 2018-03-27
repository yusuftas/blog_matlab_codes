function new_handle = draw_robot(old_handle, robot)

    delete(old_handle);
    new_handle= scatter(robot.x,robot.y,robot.size,robot.mark,'filled');   
    
end
