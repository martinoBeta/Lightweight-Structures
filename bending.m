function [defl,teta,fi,umax,tetamax,fimax]=bending(Ks,Qs,K,Q,nnode,node_z)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate deformed beam bending and torsion shape and plot results
    % File name: bending.m
    %
    % Ks		Structural stiffness matrix
    % Qs		Structural load vector
    % K		System stiffness matrix 
    % Q		System load vector
    % nnode		Number of nodes
    % node_z	Nodal z-coordinates
    %
    % defl		Deflection vector of size nnodes
    % teta		Rotation vector of size nnodes
    % fi		Twist vector of size nnodes
    % umax		Maximum deflection
    % tetamax	Maximum rotation
    % fimax		Maximum twist
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Solve system of equations
    W=Ks\Qs;
    defl=zeros(nnode,1);
    teta=zeros(nnode,1);
    fi=zeros(nnode,1);
    W_tot=[0;0;0;W];



    % Split deflections, rotations and twist into separate vectors
    for z=1:nnode
        defl(z)=W_tot(z*3-2);
        teta(z)=W_tot(z*3-1);
        fi(z)=W_tot(z*3);
    end

    [~,n]=max(abs(defl));
    umax=defl(n);

    [~,n]=max(abs(teta));
    tetamax=teta(n);
        
    [~,n]=max(abs(fi));
    fimax=fi(n);

    uNorm = norm(defl);
    tetaNorm = norm(teta);
    fiNorm = norm(fi);


    % Normalise deflections, rotations and twist and plot results
    defl_norm=defl./uNorm;
    teta_norm=teta./tetaNorm;
    fi_norm=fi./fiNorm;
    figure
    tiledlayout(1,3)
    nexttile
    plot(node_z,defl_norm)
    title('Deflection (normalized)')
    grid on
    nexttile
    plot(node_z,teta_norm)
    title('Bending rotation')
    grid on 

    nexttile
    plot(node_z,fi_norm)
    title('Torsional rotation')
    grid on

    % Present displacements at the free end
    disp("Displacement at free end:")
    disp(defl(end))
    % Present reaction forces
    R=K*W_tot -Q;
    disp("Reaction forces:")
    disp(R(1:3))
    % Create result vector containing deflections, rotations and twist
end