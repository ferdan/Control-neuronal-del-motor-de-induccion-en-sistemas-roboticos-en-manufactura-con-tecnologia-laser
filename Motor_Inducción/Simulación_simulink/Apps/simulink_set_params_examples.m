path = 'slexAircraftExample/Controller/Alpha-sensor Low-pass Filter';
h = getSimulinkBlockHandle(path,true);
set_param(h,'Numerator','1.2','Denominator','[0.8*Tal,1]');


mdl = 'Torque_controller3';
load_system(mdl)
paths = find_system(mdl+"/Controlador PBC/Perfil torque de referencia/Sine Wave");

get_param(mdl+"/Controlador PBC/Perfil torque de referencia/Sine Wave","SineType");
get_param(mdl+"/Controlador PBC/Perfil torque de referencia/Sine Wave","DialogParameters")
get_param(mdl+"/Controlador PBC/Perfil torque de referencia/Sine Wave","BlockType")

set_param(mdl+"/Controlador PBC/Perfil torque de referencia/Sine Wave","Amplitude",string(3));

perfil_paths = find_system("Torque_controller3/Controlador PBC/Perfil torque de referencia tau_Rref");
blocksPerfil = perfil_paths(contains(perfil_paths,"escalon"));
