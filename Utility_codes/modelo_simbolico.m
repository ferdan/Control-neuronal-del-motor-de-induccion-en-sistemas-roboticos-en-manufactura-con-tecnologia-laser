clc
%%clear

% Grados de libertad del robot manipulador
ndof = 6;

syms q dq ddq [ndof 1]
syms g

syms m [ndof 1]
syms d [ndof 1]
syms l [ndof 1]
syms lc [ndof 1]
syms dc [ndof 1]

syms yl [ndof 1]
syms yc [ndof 1]

syms I [ndof 1]

%Parametros DH 

if ndof == 2
    DH = [l(1)  0     0    q(1,1);
          l(2)  0     0    q(2,1)];
elseif ndof == 3
    DH = [0     pi/2  d(1) q(1,1);
          l(2)  0     0    q(2,1);
          l(3)  0     0    q(3,1)];
elseif ndof == 6
    DH = [0     pi/2  d(1) q(1,1);
          l(2)  0     0    q(2,1);
          l(3)  0     0    q(3,1);
          0     pi/2  d(4) q(4,1);
          0     -pi/2 d(5) q(5,1);   
          0     0     d(6) q(6,1)];
end

%% Cinematica directa
disp("Cinematica directa")

% l(1) es ficticio, para colocar lc(1)
DH(1,1) = l(1);

A = sym(zeros(4,4,ndof));

T0 = sym(zeros(4,4,ndof));
P = sym(zeros(3,1,ndof));

T0(:,:,1) = sym(eye(4,4));
A(:,:,1) = transformacion_homogenea(DH(1,:),sym(0));
T0(:,:,1) = T0(:,:,1)*A(:,:,1);

P(:,1,1) = subs(T0(1:3,4,1).',l(1),lc(1));
P(:,1,1) = simplify(subs(P(:,1,1),d(1),dc(1)));
%P(:,1,1) = simplify(subs(P(:,1,1),yl(1),yc(1)));

% A(:,:,1) = subs(A(:,:,1),yl(1),0);
% T0(:,:,1) = subs(T0(:,:,1),yl(1),0);

if ndof ~= 2
    A(:,:,1) = subs(A(:,:,1),l(1),0);
    T0(:,:,1) = subs(T0(:,:,1),l(1),0);
end

z(:,1,1) = A(1:3,3,1);
I(1) = 1/2*m(1)*d(1);

for i = 2:ndof
    A(:,:,i) = transformacion_homogenea(DH(i,:),sym(0));
    T0(:,:,i) = simplify(T0(:,:,i-1)*A(:,:,i));

    P(:,1,i) = subs(T0(1:3,4,i).',l(i),lc(i)); % Posicion del centro de gravedad
    P(:,1,i) = simplify(subs(P(:,1,i),d(i),dc(i)));
    %P(:,1,i) = simplify(subs(P(:,1,i).',yl(i),yc(i)));

    % A(:,:,i) = subs(A(:,:,i),yl(i),0);
    % T0(:,:,i) = subs(T0(:,:,i),yl(i),0);

    z(:,1,i) = T0(1:3,3,i);
    if d(i) ~= 0
        I(i) = 1/2*m(i)*d(i);
    else
        I(i) = 1/2*m(i)*l(i);
    end
end

%% Jacobiano
disp("Jacobiano")

JP = sym(zeros(3,ndof));
JO = sym(zeros(3,ndof));

JP(:,1) = simplify(cross(z(:,1,1),(P(:,1,ndof)-[0;0;0]))); % P0 = [0;0;0]
JO(:,1) = [0;0;1]; % z0 = [0;0;1]

for i = 2:ndof
    JP(:,i) = simplify(cross(z(:,1,i),(P(:,1,ndof)-P(:,1,i-1))));
    JO(:,i) = z(:,i);
end

J = cat(1,JP,JO);

JPinv = sym(zeros(3,ndof));
JOinv = sym(zeros(3,ndof));

% Calcular pseudoinversa NO EJECUTAR, SE ACABA LA MEMORIA
% Calcular numericamente
% JPinv = simplify(simplify(simplify((JP.'*JP))^-1)*JP.');
% JOinv = simplify(simplify(simplify((JO.'*JO))^-1*JO.');

dJ = zeros(size(J));
for i = 1:ndof
    dJ = dJ + diff(J,q(i))*dq(i);
end
dJ = simplify(dJ);

dJP = dJ(1:3,:);
dJO = dJ(4:6,:);


%% Energia cinetica y potencial
disp("Modelo dinamico")

dP = sym(zeros(3,1,ndof));
dPsqr = sym(zeros(3,1));

K = sym(zeros(ndof,1));
V = sym(zeros(ndof,1));

partial_q = sym(zeros(ndof,1));
partial_dq = sym(zeros(ndof,1));
dt_dq = sym(zeros(ndof,1));


for i = 1:ndof
    for k = 1:ndof
        dP(:,1,i) = dP(:,1,i) + diff(P(:,1,i),q(k)).*dq(k);
    end
    dPsqr(i,1) = simplify(sum(dP(:,1,i).*dP(:,1,i)));
end

dP = simplify(dP);

for i = 1:ndof
    K(i,1) = 1/2*m(i)*dPsqr(i,1);
    % for j = 1:n
    %     K(i,1) = K(i,1) + 1/2*I(i,j)*dq(j)^2;
    % end
    if ndof ~= 2
        V(i) = m(i)*P(3,1,i)*g;
    else
        V(i) = m(i)*P(2,1,i)*g;
    end
    % if i == 5 || i == 6 % Revisar direccion de eje z de eje de articulacion contra eje z original
    %     V(i) = - V(i);
    % end
end

%Editar manualmente inercias de cada eslabon

if ndof == 2
    K(1) = K(1) + 1/2*(I(1)*dq1^2);
    K(2) = K(2) + 1/2*(I(2)*dq1^2 + I(2)*(dq2^2));
elseif ndof == 3
    K(1) = K(1) + 1/2*(I(1)*dq1^2);
    K(2) = K(2) + 1/2*(I(2)*dq1^2 + I(2)*(dq2^2));
    K(3) = K(3) + 1/2*(I(3)*dq1^2 + I(3)*(dq2^2+dq3^2));
elseif ndof == 6
    K(1) = K(1) + 1/2*(I(1)*dq1^2);
    K(2) = K(2) + 1/2*(I(2)*dq1^2 + I(2)*(dq2^2));
    K(3) = K(3) + 1/2*(I(3)*dq1^2 + I(3)*(dq2^2+dq3^2));
    K(4) = K(4) + 1/2*(I(4)*dq1^2 + I(4)*(dq2^2+dq3^2) + I(4)*(dq4^2));
    K(5) = K(5) + 1/2*(I(5)*(dq1^2+dq5^2) + I(5)*(dq2^2+dq3^2) + I(5)*(dq4^2));
    K(6) = K(6) + 1/2*(I(6)*(dq1^2+dq5^2) + I(6)*(dq2^2+dq3^2) + I(6)*(dq4^2+dq6^2));
end

K = simplify(K);
V = simplify(V);

% Lagrangiano
L = simplify(sum(K) - sum(V));

% Derivadas parciales
for i = 1:ndof
    disp("Derivada paracial de articulacion "+string(i))
    partial_q(i) = simplify(diff(L, q(i)));
    partial_dq(i) = simplify(diff(L, dq(i)));
    for k = 1:ndof
        dt_dq(i) = dt_dq(i) + diff(partial_dq(i),q(k))*dq(k) + diff(partial_dq(i), dq(k))*ddq(k);
    end
    dt_dq(i) = simplify(dt_dq(i));

    % partial_q(i)
    % partial_dq(i)
    % dt_dq(i)
end

% Ecuaciones de movimiento
dyn_model = simplify(dt_dq - partial_q);

%% Coeficientes matrices D,C,G
disp("Separacion de terminos matrices D,C,G")

D = sym(zeros(ndof,ndof));
C = sym(zeros(ndof,ndof));
G = sym(zeros(ndof,1));

for i = 1:ndof
    terms = children(expand(dyn_model(i)));
    for k = 1:size(terms,2) 
        disp("Articulacion "+string(i)+",termino "+string(k)+" de "+string(size(terms,2))+": "+string(terms{k}));
        
        if has(terms{k},g) % terminos matriz G
            G(i) = simplify(G(i) + terms{k}/g);
            disp('term placed in G')
            continue
        end
        placed = false;
        for j = 1:ndof
            if has(terms{k},ddq(j)) % terminos matriz D
                D(i,j) = simplify(D(i,j) + terms{k}/ddq(j));
                disp('term placed in D')
                break
            end
            for kk = 1:ndof 
                ii = min(j,kk);
                jj = max(j,kk);
                if has(terms{k},dq(ii)*dq(jj)) % terminos matriz C
                    if jj == kk
                        C(i,kk) = simplify(C(i,kk) + terms{k}/dq(kk));
                        disp('term placed in C')
                        placed = true;
                        break
                    end
                end
            end
            if placed
                % disp('term placed')
                break
            end
        end
    end
end

D = simplify(D);
C = simplify(C);
G = simplify(G);

% Comprobar
% simplify(dyn_model - D*ddq - C*dq - G*g)

%% Suma de elementos

for i = 1:ndof
    numterms = 0;
    numtermsndof = size(children(expand(dyn_model(i))),2);
    Dnum = children(expand(D(i,:)));
    Cnum = children(expand(C(i,:)));
    Gnum = children(expand(G(i,:)));
    for j = 1:ndof
        if size(Dnum{j},2) ~= 1
            numterms = numterms + size(Dnum{j},2);
        else
            if Dnum{j}{1} ~= 0
                numterms = numterms + 1;
            end
        end
        if size(Cnum{j},2) ~= 1
            numterms = numterms + size(Cnum{j},2);
        else
            if Cnum{j}{1} ~= 0
                numterms = numterms + 1;
            end
        end
    end
    if size(Gnum,2) ~= 1
        numterms = numterms + size(Gnum,2);
    else
        if Gnum{1} ~= 0
            numterms = numterms + 1;
        end
    end
    disp("Articulacion " + string(i) + ". Terms of dyn_model: " + string(numtermsndof) + ", terms in matrices: " + string(numterms));
end


%% guardar en archivo
fileID = fopen('cin_dir_'+string(ndof)+'dof_robot.txt','w');

for i = 1:ndof
    printmatrix(fileID,T0(:,:,i),"T"+string(i-1)+string(i),"Cinematica_directa_q"+string(i),4,4);
end

fclose(fileID);

fileID = fopen('modelo_'+string(ndof)+'dof_robot.txt','w');

printmatrix(fileID,JP,"JP","Jacobiano",3,ndof);
%printmatrix(fileID,JPinv,"JPinv","Inversa del Jacobiano",3,n);
printmatrix(fileID,dJP,"dJP","Derivada del Jacobiano",3,ndof);
printmatrix(fileID,D,"D","Matriz de Inercia",ndof,ndof);
printmatrix(fileID,C,"C","Matriz de Coriollis",ndof,ndof);
printmatrix(fileID,G,"G","Matriz de Gravedad",ndof,1);

fclose(fileID);

% for i = 1:n
%     fprintf('Ecuación de Torque Aplicado del Eslabón '+string(i)+' del Robot Manipulador Antropomórfico:\n\n')
%     pretty(dyn_model(i))
% end

function printmatrix(fileName,matrix,matrixName,matrixDescription,matrixdimN,matrixdimM)
    fprintf(fileName,"\n%% "+matrixDescription+" "+matrixName+": \n\n");
    for i = 1:matrixdimN
        for j = 1:matrixdimM
            fprintf(fileName,matrixName+"("+string(i)+","+string(j)+") = "+string(matrix(i,j))+";\n");
        end
        fprintf(fileName,"\n");
    end
end

function m = transformacion_homogenea(DH_i,yc)

a_i = DH_i(1);
alpha_i = DH_i(2);
d_i = DH_i(3);
theta_i = DH_i(4);

ma_i = [1 0 0 a_i;
        0 1 0 0;
        0 0 1 0;
        0 0 0 1];

md_i = [1 0 0 0;
        0 1 0 0;
        0 0 1 d_i;
        0 0 0 1];

myc_i = [1 0 0 0;
        0 1 0 yc;
        0 0 1 0;
        0 0 0 1];

mtheta_i = [cos(theta_i) -sin(theta_i) 0 0;
            sin(theta_i) cos(theta_i) 0 0;
            0 0 1 0;
            0 0 0 1];

malpha_i = [1 0 0 0;
            0 cos(alpha_i) -sin(alpha_i) 0;
            0 sin(alpha_i) cos(alpha_i) 0;
            0 0 0 1];

m = mtheta_i * md_i * ma_i * myc_i * malpha_i;

end


