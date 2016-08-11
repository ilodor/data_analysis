function the_color = trode_pos_color_map(trode_name)
% trode_pos_color_map returns an rgb color for a given trode name

the_map = cell({'a1',[1 0.5 0];...
    'a2',[0.9 0.5 0];...
    'b1',[0.8 0.7 0];...
    'b2',[0.7 0.8,0];...
    'c1',[0.6 0.9,0];...
    'c2',[0.5 1,0];...
    'd1',[1 0.5 0.5];...
    'd2',[0.9 0.6 0.5];...
    'e1',[0.8 0.7 0.5];...
    'e2',[0.7 0.8,0.5];...
    'f1',[0.6 0.9,0.5];...
    'f2',[0.5 1,0.5] });

trode_names = the_map(:,1);
colors = the_map(:,2);

the_color = colors{strcmp(trode_names, trode_name)};